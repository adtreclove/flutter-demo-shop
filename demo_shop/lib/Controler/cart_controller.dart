import 'package:demo_shop/Models/Cart.dart';
import 'package:demo_shop/Models/Product.dart';
import 'package:demo_shop/Services/ApiService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Holds the cart contents locally. This is the source of truth for the
/// UI — the dummyjson API doesn't persist carts server-side, so there's
/// nothing to "fetch" the cart from; it only exists here until you call
/// [checkout].
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addProduct(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      state = [...state, CartItem(product: product, quantity: quantity)];
    } else {
      final updated = [...state];
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity + quantity,
      );
      state = updated;
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }

  void clear() => state = [];

  /// Sends the current cart to POST /carts/add and returns the server's
  /// calculated response (total, discountedTotal, etc.).
  ///
  /// Since this endpoint doesn't actually persist anything, this is best
  /// used as a "checkout" action (e.g. to show the final discounted
  /// price) rather than a way to save the cart across sessions. userId
  /// is required by the API — pass a real logged-in user id if you have
  /// auth, or a placeholder like 1 while you don't.
  Future<Map<String, dynamic>> checkout({required int userId}) async {
    final response = await ApiService.instance.post(
      '/carts/add',
      body: {
        'userId': userId,
        'products': state
            .map(
              (item) => {
                'id': int.parse(item.product.id),
                'quantity': item.quantity,
              },
            )
            .toList(),
      },
    );
    return response as Map<String, dynamic>;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.lineTotal);
});

/// Total number of items (sum of quantities)

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0, (sum, item) => sum + item.quantity);
});
