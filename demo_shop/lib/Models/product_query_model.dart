class ProductQuery {
  final int? limit;
  final int? skip;
  final String? category;
  final String? search;
  final String? sortBy;
  final String? order;

  const ProductQuery({
    this.limit,
    this.skip,
    this.category,
    this.search,
    this.sortBy,
    this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductQuery &&
          runtimeType == other.runtimeType &&
          limit == other.limit &&
          skip == other.skip &&
          category == other.category &&
          search == other.search &&
          sortBy == other.sortBy &&
          order == other.order;

  @override
  int get hashCode => Object.hash(limit, skip, category, search, sortBy, order);
}
