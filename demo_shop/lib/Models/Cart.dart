import 'package:demo_shop/Models/Product.dart';

/// One line item in the cart: a product plus how many of it.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);
}
