import 'package:demo_shop/Controler/category_controller.dart';
import 'package:demo_shop/Controler/drawer_controller.dart'; // drawerProvider, DrawerItem
import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHighlightBanner extends ConsumerWidget {
  final String imageUrl;
  final String headline;
  final String? eyebrowLeft;
  final String? eyebrowRight;

  final String categorySlug;
  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  const CategoryHighlightBanner({
    super.key,
    required this.imageUrl,
    required this.headline,
    required this.categorySlug,
    this.eyebrowLeft,
    this.eyebrowRight,
    this.height = 270,
    this.borderRadius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasEyebrow = eyebrowLeft != null && eyebrowLeft!.isNotEmpty;

    return GestureDetector(
      onTap: onTap ?? () => _openCategory(context, ref),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(color: AppColors.glassSubtle),
              ),

              // Darkens the top so the headline stays readable on any image
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),

              Positioned(
                left: 20,
                right: 20,
                top: 22,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasEyebrow) _buildEyebrowRow(),
                    if (hasEyebrow) const SizedBox(height: 8),
                    Text(
                      headline,
                      style: GoogleFonts.montserrat(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),

              // Small "go" button that hints the banner is tappable
              Positioned(
                right: 16,
                bottom: 16,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_outward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEyebrowRow() {
    final style = GoogleFonts.montserrat(
      color: AppColors.textSecondary,
      fontSize: 12,
      letterSpacing: 0.5,
    );

    final hasRight = eyebrowRight != null && eyebrowRight!.isNotEmpty;
    if (!hasRight) {
      return Text(eyebrowLeft!, style: style);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(eyebrowLeft!, style: style),
        Text(eyebrowRight!, style: style),
      ],
    );
  }

  void _openCategory(BuildContext context, WidgetRef ref) {
    ref.read(selectedCategoryProvider.notifier).state = categorySlug;

    ref.read(drawerProvider.notifier).selectItem(DrawerItem.category);
  }
}
