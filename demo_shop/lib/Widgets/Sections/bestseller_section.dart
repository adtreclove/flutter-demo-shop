import 'package:demo_shop/Controler/product_controller.dart';
import 'package:demo_shop/Models/product_query_model.dart';
import 'package:demo_shop/Screens/product_detail_screen.dart';
import 'package:demo_shop/Services/localization_service.dart';
import 'package:demo_shop/Widgets/Products/product_card_small.dart';
import 'package:demo_shop/Widgets/Sections/section_header.dart';
import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// "Top bewertet" section for the home screen: horizontally scrollable
/// row of the highest-rated products, each in a ProductCardSmall.
class BestsellerSection extends ConsumerWidget {
  const BestsellerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = getIt<LocalizationService>().localizations;
    final productsAsync = ref.watch(
      productsProvider(
        const ProductQuery(sortBy: 'rating', order: 'desc', limit: 10),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(l10n.bestseller_header),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: productsAsync.when(
            skipError: true,
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.bestseller_error,
                style: GoogleFonts.montserrat(color: AppColors.error),
              ),
            ),
            data: (products) {
              if (products.isEmpty) return const SizedBox.shrink();

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];

                  return SizedBox(
                    width: 160,
                    child: ProductCardSmall(
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
