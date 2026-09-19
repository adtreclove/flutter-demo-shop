/// Simplified order, built from dummyjson's /carts/user/{id} endpoint
/// (dummyjson has no dedicated "orders" concept, so past carts are used
/// to stand in for order history).
class Order {
  final int id;
  final int totalProducts;
  final int totalQuantity;
  final double total;
  final double discountedTotal;

  const Order({
    required this.id,
    required this.totalProducts,
    required this.totalQuantity,
    required this.total,
    required this.discountedTotal,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      totalProducts: json['totalProducts'] as int? ?? 0,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      discountedTotal: (json['discountedTotal'] as num?)?.toDouble() ?? 0,
    );
  }
}
