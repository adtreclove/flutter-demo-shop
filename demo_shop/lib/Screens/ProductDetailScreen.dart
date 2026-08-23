import 'package:demo_shop/Controler/cart_controller.dart';
import 'package:demo_shop/Helper/designHelper.dart';
import 'package:demo_shop/Models/Product.dart';
import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  final Color accentColor;
  final Color buyButtonColor;

  const ProductDetailScreen({
    super.key,
    required this.product,

    this.accentColor = AppColors.primary,
    this.buyButtonColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroImage(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: GoogleFonts.montserrat(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              product.description,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                height: 1.4,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                children: [
                  SizedBox(width: 30),
                  ShimmerText(
                    baseColor: AppColors.textPrimary,
                    highlightColor: AppColors.primaryLight,
                    child: Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              _buildBottomBar(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    // Falls back to the single thumbnail if the product has no
    // (or an empty) images list, so the carousel always has at least
    // one image to show.
    final images = product.images.isNotEmpty
        ? product.images
        : [product.thumbnail];

    return _ProductImageCarousel(images: images, heroTag: product.id);
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // BUY NOW LOGIC
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buyButtonColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Buy Now',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 52,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ref.read(cartProvider.notifier).addProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} zum Warenkorb hinzugefügt'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                elevation: 2,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontally swipeable product image gallery with a dot indicator.
/// Only the first image carries the [Hero] tag, since that's the image
/// that was visible on the product card this screen was opened from —
/// the flight animation only makes sense for that one.
class _ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final Object heroTag;

  const _ProductImageCarousel({required this.images, required this.heroTag});

  @override
  State<_ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<_ProductImageCarousel> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 450,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final image = Image.network(
                widget.images[index],
                fit: BoxFit.contain,
              );
              return index == 0
                  ? Hero(tag: widget.heroTag, child: image)
                  : image;
            },
          ),
        ),

        // Dot indicator, only shown when there's actually more than one
        // image to swipe through.
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 10 : 8,
                height: isActive ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
