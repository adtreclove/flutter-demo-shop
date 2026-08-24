import 'package:demo_shop/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  /// Network image URL. Use [imageAsset] instead if you're bundling
  /// images locally.
  final String? imageUrl;

  /// Local asset path, alternative to [imageUrl].
  final String? imageAsset;

  /// Text shown bottom-left, e.g. product name or price.
  final String cornerText;

  final double height;
  final double borderRadius;
  final VoidCallback? onTap;

  /// When set, wraps the image in a [Hero] with this tag. Use the same
  /// tag (e.g. the product id) on the image in your detail screen and
  /// Flutter will automatically animate the image flying/morphing into
  /// place when you navigate there — this is what makes the card feel
  /// like it "opens" into the detail page.
  final Object? heroTag;

  const ProductCard({
    super.key,
    this.imageUrl,
    this.imageAsset,
    required this.cornerText,
    this.height = 220,
    this.borderRadius = 20,
    this.onTap,
    this.heroTag,
  }) : assert(
         imageUrl != null || imageAsset != null,
         'Provide either imageUrl or imageAsset',
       );

  Widget _buildImage() {
    final image = imageUrl != null
        ? Image.network(imageUrl!, fit: BoxFit.cover)
        : Image.asset(imageAsset!, fit: BoxFit.cover);

    if (heroTag == null) return image;
    return Hero(tag: heroTag!, child: image);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.84,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: BoxBorder.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background product image
            _buildImage(),

            // Gradient so bottom-left text stays readable
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                  stops: const [0.0, 0.5],
                ),
              ),
            ),

            // Bottom-left corner text
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Text(
                cornerText,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
