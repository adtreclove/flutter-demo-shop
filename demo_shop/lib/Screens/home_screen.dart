import 'package:demo_shop/Controler/auth_controller.dart';
import 'package:demo_shop/Controler/product_controller.dart';
import 'package:demo_shop/Helper/design_helper.dart';
import 'package:demo_shop/Helper/time_helper.dart';
import 'package:demo_shop/Models/product_query_model.dart';
import 'package:demo_shop/Screens/product_detail_screen.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:demo_shop/Widgets/Products/highlighted_product_card.dart';
import 'package:demo_shop/Widgets/Products/product_card.dart';
import 'package:demo_shop/Widgets/Sections/bestseller_section.dart';
import 'package:demo_shop/Widgets/Sections/section_header.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const double _edge = 20;
  static const double _sectionGap = 36;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(
      productsProvider(const ProductQuery(category: "womens-watches")),
    );
    final specificProductAsync = ref.watch(productProvider("155"));
    final user = ref.watch(authProvider).value?.firstName ?? '';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(userName: user),
          const SizedBox(height: 28),

          // New products
          SectionHeader(
            getIt<LocalizationService>()
                .localizations
                .home_screen_new_prod_header,
          ),
          const SizedBox(height: 12),
          categoryAsync.when(
            skipError: true,
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (products) => SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: _edge,
                  vertical: 8,
                ),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    imageUrl: product.thumbnail,
                    title: product.title,
                    cornerText: product.formattedPrice,
                    heroTag: product.id,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    ),
                  );
                },
              ),
            ),
            loading: () => const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => const SizedBox(
              height: 250,
              child: Center(child: Text('Error loading products')),
            ),
          ),

          const SizedBox(height: _sectionGap),

          // Highlight banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _edge),
            child: specificProductAsync.when(
              skipError: true,
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (product) => CategoryHighlightBanner(
                imageUrl: product.thumbnail,
                headline:
                    getIt<LocalizationService>().localizations.highlight_header,
                eyebrowLeft: getIt<LocalizationService>()
                    .localizations
                    .highlight_headline,
                eyebrowRight: "",
                categorySlug: "sunglasses",
              ),
              loading: () => const SizedBox(
                height: 270,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => const SizedBox(
                height: 270,
                child: Center(child: Text('Error loading product')),
              ),
            ),
          ),

          const SizedBox(height: _sectionGap),

          // Bestsellers
          const BestsellerSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String userName;

  const _HomeHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        HomeScreen._edge,
        topInset + 24,
        HomeScreen._edge,
        24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.22),
            AppColors.background,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            getGreeting(),
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          if (userName.isNotEmpty)
            Flexible(
              child: ShimmerText(
                baseColor: AppColors.primary,
                highlightColor: Colors.white,
                child: Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
