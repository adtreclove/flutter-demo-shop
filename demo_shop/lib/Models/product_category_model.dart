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
