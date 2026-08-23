import 'package:demo_shop/Controler/category_controller.dart';
import 'package:demo_shop/Controler/product_controller.dart';
import 'package:demo_shop/Models/ProductQuery.dart';
import 'package:demo_shop/Screens/ProductDetailScreen.dart';
import 'package:demo_shop/Widgets/Category/AnimatedCategoryList.dart';
import 'package:demo_shop/Widgets/Products/ProductCardSmall.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender = ref.watch(selectedGenderProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productsAsync = ref.watch(
      productsProvider(ProductQuery(category: selectedCategory)),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(ref, selectedGender),
          SizedBox(height: 10),
          const AnimatedCategoryScroller(),
          SizedBox(height: 30),

          productsAsync.when(
            skipError: true,
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Fehler: $e'),
            ),
            data: (products) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return ProductCardSmall(
                  product: products[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: products[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

Widget _buildHeader(WidgetRef ref, Gender selectedGender) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        TextButton(
          onPressed: () {
            ref.read(selectedGenderProvider.notifier).state = Gender.men;
          },
          child: Text(
            "MEN",
            style: GoogleFonts.montserrat(
              fontSize: 25,
              color: selectedGender == Gender.men
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            ref.read(selectedGenderProvider.notifier).state = Gender.women;
          },
          child: Text(
            "WOMEN",
            style: GoogleFonts.montserrat(
              fontSize: 25,
              color: selectedGender == Gender.women
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
