import 'dart:async';
import 'dart:convert';
import 'package:demo_shop/Helper/logHelper.dart';
import 'package:http/http.dart' as http;

enum ApiMethod { get, post, put, patch, delete }

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic body;

  ApiException({required this.message, this.statusCode, this.body});

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  ApiService._internal();

  static final ApiService instance = ApiService._internal();
  String baseUrl = 'https://dummyjson.com';
  Duration timeout = const Duration(seconds: 15);
  String? _authToken;

  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  final http.Client _client = http.Client();

  /// Call once at app startup to set environment-specific values.
  void configure({
    String? baseUrl,
    Duration? timeout,
    Map<String, String>? defaultHeaders,
  }) {
    if (baseUrl != null) this.baseUrl = baseUrl;
    if (timeout != null) this.timeout = timeout;
    if (defaultHeaders != null) _defaultHeaders.addAll(defaultHeaders);
  }

  void setAuthToken(String? token) => _authToken = token;

  void clearAuthToken() => _authToken = null;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) {
    coloredLog(
      "Requesting API via Get! queryParams: $queryParams, path: $path ",
      color: LogColor.magenta,
      tag: "Api Service",
    );

    return _request(
      ApiMethod.get,
      path,
      queryParams: queryParams,
      headers: headers,
    );
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) {
    return _request(
      ApiMethod.post,
      path,
      body: body,
      queryParams: queryParams,
      headers: headers,
    );
  }

  // Core request handling
  Future<dynamic> _request(
    ApiMethod method,
    String path, {
    Object? body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    final mergedHeaders = _buildHeaders(headers);
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _send(
        method,
        uri,
        mergedHeaders,
        encodedBody,
      ).timeout(timeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException(message: 'Request timed out. Please try again.');
    } on FormatException {
      throw ApiException(message: 'Received an invalid response from server.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Network error: $e');
    }
  }

  Future<http.Response> _send(
    ApiMethod method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) {
    switch (method) {
      case ApiMethod.get:
        return _client.get(uri, headers: headers);
      case ApiMethod.post:
        return _client.post(uri, headers: headers, body: body);
      case ApiMethod.put:
        return _client.put(uri, headers: headers, body: body);
      case ApiMethod.patch:
        return _client.patch(uri, headers: headers, body: body);
      case ApiMethod.delete:
        return _client.delete(uri, headers: headers, body: body);
    }
  }

  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final fullPath = path.startsWith('http') ? path : '$baseUrl$path';
    final uri = Uri.parse(fullPath);

    if (queryParams == null || queryParams.isEmpty) return uri;

    final stringParams = queryParams.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    coloredLog(
      "Requesting uri: $uri",
      color: LogColor.cyan,
      tag: "Api Service",
    );

    return uri.replace(
      queryParameters: {...uri.queryParameters, ...stringParams},
    );
  }

  Map<String, String> _buildHeaders(Map<String, String>? extra) {
    final headers = {..._defaultHeaders};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final rawBody = response.body;

    dynamic decoded;
    if (rawBody.isNotEmpty) {
      try {
        decoded = jsonDecode(rawBody);
      } on FormatException {
        decoded = rawBody; // fall back to raw text
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final message =
        _extractErrorMessage(decoded) ??
        'Request failed with status code $statusCode';

    throw ApiException(statusCode: statusCode, message: message, body: decoded);
  }

  String? _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      return decoded['message'] ?? decoded['error'] ?? decoded['detail'];
    }
    return null;
  }

  void dispose() => _client.close();
}
