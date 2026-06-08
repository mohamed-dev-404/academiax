import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

///? A wrapper widget that shows a skeleton loading effect
/// while data is being fetched.
///
///? Usage:
/// ```dart
/// CustomSkeletonizer(
///   isLoading: true, // true → show shimmer skeleton
///   shimmerDuration: Duration(milliseconds: 1200), // optional
///   child: Column(
///     children: [
///       ListTile(
///         leading: CircleAvatar(),
///         title: Text("User Name"),
///         subtitle: Text("Subtitle here"),
///       ),
///       Text("Some content"),
///     ],
///   ),
/// )
/// ```
///* Set `isLoading: false` to show the actual content instead of skeleton.
class AppSkeletonizer extends StatelessWidget {
  /// Whether the data is loading (true → show skeleton)
  final bool isLoading;

  /// The actual content to display once loading is complete
  final Widget child;

  /// Duration of the shimmer animation (optional)
  final Duration shimmerDuration;

  const AppSkeletonizer({
    super.key,
    required this.isLoading,
    required this.child,
    this.shimmerDuration = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading, // true → show shimmer effect
      effect: ShimmerEffect(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        duration: shimmerDuration,
      ),
      child: child, // the widget that will be transformed into a skeleton
    );
  }
}
