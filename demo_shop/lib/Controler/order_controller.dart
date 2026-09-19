import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Models/order_model.dart';
import 'package:demo_shop/Services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = FutureProvider.autoDispose<List<Order>>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];

  final response = await ApiService.instance.get('/carts/user/${user.id}');
  final rawList = (response as Map<String, dynamic>)['carts'] as List<dynamic>;

  return rawList
      .map((item) => Order.fromJson(item as Map<String, dynamic>))
      .toList();
});
