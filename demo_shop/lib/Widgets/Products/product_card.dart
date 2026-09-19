import 'package:demo_shop/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  /// Network image URL. Use [imageAsset] instead if you're bundling
  /// images locally.
  final String? imageUrl;

  /// Local asset path, alternative to [imageUrl].
  final String? imageAsset;

  /// Optional product name. When set, it is shown bottom-left and
  /// [cornerText] moves into a price chip on the bottom-right.
  final String? title;

  /// Text shown bottom-left (or in the price chip when [title] is set),
  /// e.g. product name or price.
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
    this.title,
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
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
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

            // Gradient so the bottom text stays readable
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55],
                ),
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: title == null
                  ? Text(
                      cornerText,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            title!,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _PriceChip(cornerText),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceChip extends StatelessWidget {
  final String text;

  const _PriceChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
