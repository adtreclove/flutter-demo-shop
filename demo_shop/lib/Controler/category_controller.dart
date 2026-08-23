import 'package:demo_shop/Models/ProductCategory.dart';
import 'package:demo_shop/Services/ApiService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  final response = await ApiService.instance.get('/products/categories');

  return (response as List<dynamic>)
      .map((item) => ProductCategory.fromJson(item as Map<String, dynamic>))
      .toList();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

enum Gender { men, women }

/// Currently selected gender tab. Defaults to men
final selectedGenderProvider = StateProvider<Gender>((ref) => Gender.men);

final filteredCategoriesProvider = Provider<AsyncValue<List<ProductCategory>>>((
  ref,
) {
  final categoriesAsync = ref.watch(categoriesProvider);
  final gender = ref.watch(selectedGenderProvider);

  return categoriesAsync.whenData((categories) {
    final prefix = gender == Gender.men ? 'mens-' : 'womens-';
    final otherPrefix = gender == Gender.men ? 'womens-' : 'mens-';

    final matching = categories.where((c) => c.slug.startsWith(prefix));
    final neutral = categories.where(
      (c) => !c.slug.startsWith(prefix) && !c.slug.startsWith(otherPrefix),
    );

    return [...matching, ...neutral];
  });
});

final orderedCategoriesProvider = Provider<AsyncValue<List<ProductCategory>>>((
  ref,
) {
  final categoriesAsync = ref.watch(filteredCategoriesProvider);
  final selectedSlug = ref.watch(selectedCategoryProvider);

  return categoriesAsync.whenData((categories) {
    if (selectedSlug == null) return categories;

    final index = categories.indexWhere((c) => c.slug == selectedSlug);
    if (index <= 0) return categories; // not found, or already first

    final reordered = List<ProductCategory>.from(categories);
    final selected = reordered.removeAt(index);
    reordered.insert(0, selected);
    return reordered;
  });
});
