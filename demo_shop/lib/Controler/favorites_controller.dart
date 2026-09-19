import 'package:demo_shop/Models/product_model.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Local, in-memory wishlist (like the cart, dummyjson has no real
/// per-user favorites endpoint to persist this server-side).
class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  bool isFavorite(String productId) =>
      state.any((product) => product.id == productId);

  void toggle(Product product) {
    if (isFavorite(product.id)) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<Product>>(
      (ref) => FavoritesNotifier(),
    );
