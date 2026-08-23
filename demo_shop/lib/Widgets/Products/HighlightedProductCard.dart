import 'package:demo_shop/Controler/category_controller.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:demo_shop/Controler/drawer_controller.dart';
import 'package:google_fonts/google_fonts.dart'; // for drawerProvider, DrawerItem

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
    return GestureDetector(
      onTap: onTap ?? () => _openCategory(context, ref),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(decoration: BoxDecoration(color: AppColors.glassSubtle)),

            Positioned(
              left: 40,
              right: 20,
              top: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (eyebrowLeft != null) _buildEyebrowRow(),
                  if (eyebrowLeft != null) const SizedBox(height: 8),
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
          ],
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

    if (eyebrowRight == null) {
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
