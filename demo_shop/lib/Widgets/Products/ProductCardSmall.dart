import 'package:demo_shop/Models/Product.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Compact product card for grid listings (e.g. category pages)

class ProductCardSmall extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double borderRadius;

  const ProductCardSmall({
    super.key,
    required this.product,
    this.onTap,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.glassBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: AppColors.background,
                child: Image.network(product.thumbnail, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _StarRating(
                    rating: product.rating,
                    reviewCount: product.reviewCount,
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: Text(
                product.formattedPrice,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _StarRating({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          IconData icon;
          if (rating >= starValue) {
            icon = Icons.star;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half;
          } else {
            icon = Icons.star_border;
          }
          return Icon(icon, size: 14, color: AppColors.textPrimary);
        }),
        const SizedBox(width: 4),
        Text(
          '($reviewCount)',
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
