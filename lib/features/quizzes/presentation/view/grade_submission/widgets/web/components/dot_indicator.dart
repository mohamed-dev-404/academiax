import 'package:flutter/material.dart';
import 'package:sams_app/core/utils/colors/app_colors.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Animated dot indicator for question navigation in the web layout.
///
/// Uses ScrollingDotsEffect for scalable rendering natively handling an arbitrary number of dots.
class DotIndicator extends StatelessWidget {
  final int total;
  final int current;
  final PageController? pageController;
  final ValueChanged<int>? onDotClicked;

  const DotIndicator({
    super.key,
    required this.total,
    required this.current,
    this.pageController,
    this.onDotClicked,
  });

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();

    final effect = ScrollingDotsEffect(
      fixedCenter: true,
      maxVisibleDots: 5,
      activeDotScale: 1,
      spacing: 10,
      dotHeight: 9,
      dotWidth: 9,
      activeDotColor: AppColors.primary,
      dotColor: AppColors.secondaryLightActive.withValues(alpha: 0.6),
    );

    if (pageController != null) {
      return SmoothPageIndicator(
        controller: pageController!,
        count: total,
        onDotClicked: onDotClicked,
        effect: effect,
      );
    }

    return AnimatedSmoothIndicator(
      activeIndex: current,
      count: total,
      onDotClicked: onDotClicked,
      effect: effect,
    );
  }
}
