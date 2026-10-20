import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmering block used while content loads.
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width, this.radius = 0});

  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Placeholder list shown before the first cars arrive.
class CarListSkeleton extends StatelessWidget {
  const CarListSkeleton({super.key, this.count = 3});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Skeleton(height: 240, radius: 24),
          ),
      ],
    );
  }
}
