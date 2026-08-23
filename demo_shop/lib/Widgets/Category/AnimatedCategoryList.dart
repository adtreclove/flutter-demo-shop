import 'package:demo_shop/Controler/category_controller.dart';
import 'package:demo_shop/Models/ProductCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedCategoryScroller extends ConsumerStatefulWidget {
  const AnimatedCategoryScroller({super.key});

  @override
  ConsumerState<AnimatedCategoryScroller> createState() =>
      _AnimatedCategoryScrollerState();
}

class _AnimatedCategoryScrollerState
    extends ConsumerState<AnimatedCategoryScroller> {
  final _scrollController = ScrollController();
  final Map<String, GlobalKey> _measureKeys = {};
  final Map<String, double> _measuredWidths = {};

  static const _chipHeight = 44.0;
  static const _spacing = 8.0;
  static const _edgePadding = 16.0;
  static const _textStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const _fallbackWidth = 90.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(String slug) =>
      _measureKeys.putIfAbsent(slug, () => GlobalKey());

  /// Measures any category chip we don't have a real width for yet by
  /// rendering it off-screen (still laid out, just not painted) and
  /// reading its RenderBox size after the frame completes.
  void _scheduleMeasurement(List<ProductCategory> categories) {
    final unmeasured = categories
        .where((c) => !_measuredWidths.containsKey(c.slug))
        .toList();
    if (unmeasured.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      var changed = false;
      for (final c in unmeasured) {
        final box =
            _measureKeys[c.slug]?.currentContext?.findRenderObject()
                as RenderBox?;
        if (box != null && box.hasSize) {
          _measuredWidths[c.slug] = box.size.width;
          changed = true;
        }
      }
      if (changed) setState(() {});
    });
  }

  Widget _buildChip(ProductCategory c, {required bool isSelected, Key? key}) {
    return ChoiceChip(
      key: key,
      label: Text(c.name, style: _textStyle),
      selected: isSelected,
      // Keeps the chip's width identical whether selected or not, so we
      // don't need to re-measure (and re-animate width) on every tap.
      showCheckmark: false,
      onSelected: (_) {
        ref.read(selectedCategoryProvider.notifier).state = isSelected
            ? null
            : c.slug;
      },
    );
  }

  void _scrollToStart() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(orderedCategoriesProvider);
    final selectedSlug = ref.watch(selectedCategoryProvider);

    // Whenever the selection changes, scroll back to the start so the
    // newly-moved-to-front chip is actually visible, even if the user
    // had scrolled further right beforehand.
    ref.listen(selectedCategoryProvider, (previous, next) {
      if (next != null) _scrollToStart();
    });

    return categoriesAsync.when(
      loading: () => const SizedBox(
        height: _chipHeight,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => SizedBox(
        height: _chipHeight,
        child: Center(child: Text('Fehler: $e')),
      ),
      data: (categories) {
        _scheduleMeasurement(categories);

        // Compute each chip's left offset and width up front, based on
        // the current order and whatever widths are known so far.
        double cursor = _edgePadding;
        final left = <String, double>{};
        final width = <String, double>{};

        for (final c in categories) {
          final w = _measuredWidths[c.slug] ?? _fallbackWidth;
          width[c.slug] = w;
          left[c.slug] = cursor;
          cursor += w + _spacing;
        }
        final totalWidth = cursor + _edgePadding;

        final unmeasured = categories.where(
          (c) => !_measuredWidths.containsKey(c.slug),
        );

        return SizedBox(
          height: _chipHeight,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: totalWidth,
              height: _chipHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Invisible copies used purely to measure real width —
                  // still laid out (so we can read their size), just not
                  // painted or hit-testable.
                  ...unmeasured.map(
                    (c) => Offstage(
                      key: ValueKey('measure-${c.slug}'),
                      offstage: true,
                      child: _buildChip(
                        c,
                        isSelected: false,
                        key: _keyFor(c.slug),
                      ),
                    ),
                  ),

                  // The real, visible, animated chips.
                  ...categories.map((c) {
                    final isSelected = c.slug == selectedSlug;
                    return AnimatedPositioned(
                      key: ValueKey(c.slug),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: left[c.slug],
                      top: 0,
                      width: width[c.slug],
                      height: _chipHeight,
                      child: _buildChip(c, isSelected: isSelected),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
