import 'package:demo_shop/Controler/ticker_controller.dart';
import 'package:demo_shop/Models/Product.dart';
import 'package:demo_shop/Models/ProductQuery.dart';
import 'package:demo_shop/Services/ApiService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsProvider = FutureProvider.family<List<Product>, ProductQuery>((
  ref,
  query,
) async {
  ref.watch(tickerProvider);

  final hasSearch = query.search != null && query.search!.trim().isNotEmpty;

  // dummyjson has a dedicated search endpoint — /products?search=... is
  // NOT a thing, the param has to be "q" on /products/search.
  final path = hasSearch
      ? '/products/search'
      : query.category != null
      ? '/products/category/${query.category}'
      : '/products';

  final queryParams = <String, dynamic>{
    if (query.limit != null) 'limit': query.limit,
    if (query.skip != null) 'skip': query.skip,
    if (query.sortBy != null) 'sortBy': query.sortBy,
    if (query.order != null) 'order': query.order,
    if (hasSearch) 'q': query.search,
  };

  final response = await ApiService.instance.get(
    path,
    queryParams: queryParams,
  );

  // dummyjson wraps the list as { "products": [...] }
  final List<dynamic> rawList = response is List
      ? response
      : (response['products'] as List<dynamic>);

  return rawList
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
});

/// A product category as returned by GET /products/categories.
class ProductCategory {
  final String slug;
  final String name;

  const ProductCategory({required this.slug, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      slug: json['slug'] as String,
      name: json['name'] as String,
    );
  }
}

/// Fetches a single product by id, useful for a product detail screen.
final productProvider = FutureProvider.family<Product, String>((
  ref,
  productId,
) async {
  final response = await ApiService.instance.get('/products/$productId');
  return Product.fromJson(response as Map<String, dynamic>);
});
