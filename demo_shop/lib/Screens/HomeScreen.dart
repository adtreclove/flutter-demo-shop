import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Controler/product_controller.dart';
import 'package:demo_shop/Helper/designHelper.dart';
import 'package:demo_shop/Helper/timeHelper.dart';
import 'package:demo_shop/Models/ProductQuery.dart';
import 'package:demo_shop/Screens/ProductDetailScreen.dart';
import 'package:demo_shop/Widgets/Products/HighlightedProductCard.dart';
import 'package:demo_shop/Widgets/Products/ProductCard.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(
      productsProvider(const ProductQuery(category: "womens-watches")),
    );
    final specificProductAsync = ref.watch(productProvider("155"));
    final userAsync = ref.watch(authProvider);
    String user = userAsync.when(
      data: (user) {
        if (user != null) {
          return user.firstName;
        }
        return "";
      },
      error: (Object error, StackTrace stackTrace) {
        return "";
      },
      loading: () {
        return "";
      },
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),
          SizedBox(height: 20),
          // New Products slidable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 15),
                  child: Text(
                    "Discover new products",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                categoryAsync.when(
                  skipError: true,
                  skipLoadingOnRefresh: true,
                  skipLoadingOnReload: true,
                  data: (products) {
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductCard(
                              imageUrl: product.thumbnail,
                              cornerText: product.formattedPrice,
                              heroTag: product.id,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      Center(child: Text('Error loading products')),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 50),
            child: specificProductAsync.when(
              skipError: true,
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (product) {
                return CategoryHighlightBanner(
                  imageUrl: product.thumbnail,
                  headline: "New sunglasses",
                  eyebrowLeft: "SHOP NOW",
                  eyebrowRight: "",
                  categorySlug: "sunglasses",
                );
              },
              loading: () => Padding(
                padding: const EdgeInsets.only(top: 50),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(child: Text('Error loading product')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 50, top: 30),
          child: Text(
            getGreeting(),
            style: GoogleFonts.montserrat(
              color: AppColors.textSecondary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 70, bottom: 5),
          child: ShimmerText(
            baseColor: AppColors.primary,
            highlightColor: Colors.white,
            child: Text(
              user,
              style: GoogleFonts.montserrat(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors
                    .white, // must be white/opaque — ShaderMask needs full alpha to blend against
              ),
            ),
          ),
        ),
      ],
    );
  }
}
