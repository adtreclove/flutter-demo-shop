import 'package:demo_shop/Controler/product_controller.dart';
import 'package:demo_shop/Models/ProductQuery.dart';
import 'package:demo_shop/Screens/ProductDetailScreen.dart';
import 'package:demo_shop/Widgets/Products/ProductCardSmall.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String value) {
    setState(() {
      _search = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = _search.isEmpty
        ? null
        : ref.watch(productsProvider(ProductQuery(search: _search, limit: 20)));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              'Search',
              style: GoogleFonts.montserrat(
                color: AppColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchProducts,
              style: GoogleFonts.montserrat(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: GoogleFonts.montserrat(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _search = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.glass,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: AppColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: AppColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Search results
          if (_search.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Search for a product',
                  style: GoogleFonts.montserrat(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            productsAsync!.when(
              skipError: true,
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,

              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),

              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Something went wrong.\n$error',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(color: AppColors.error),
                ),
              ),

              data: (products) {
                if (products.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'No products found',
                        style: GoogleFonts.montserrat(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
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
                    final product = products[index];

                    return ProductCardSmall(
                      product: product,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(product: product),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
