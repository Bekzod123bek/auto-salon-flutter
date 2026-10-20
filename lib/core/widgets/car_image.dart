import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'skeleton.dart';

/// Network photo with a shimmer placeholder and a neutral fallback.
class CarImage extends StatelessWidget {
  const CarImage(this.url, {super.key, this.fit = BoxFit.cover});

  final String url;
  final BoxFit fit;

  /// Disk caching needs platform plugins; tests switch it off and fall back
  /// to [Image.network].
  static bool useCache = true;

  Widget _fallback(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.directions_car_filled_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (!useCache) {
      return Image.network(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, _, _) => _fallback(context),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (_, _) => const Skeleton(),
      errorWidget: (context, _, _) => _fallback(context),
    );
  }
}

/// Dark gradient laid over photos so white text stays readable.
class ImageScrim extends StatelessWidget {
  const ImageScrim({super.key, this.strength = 0.75});

  final double strength;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: strength),
          ],
          stops: const [0.35, 1],
        ),
      ),
    );
  }
}
