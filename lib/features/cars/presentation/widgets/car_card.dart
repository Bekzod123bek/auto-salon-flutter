import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/car_image.dart';
import '../../domain/entities.dart';
import '../cubit/favorites_cubit.dart';
import '../pages/car_detail_page.dart';

void openCar(BuildContext context, Car car, String heroTag) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => CarDetailPage(car: car, heroTag: heroTag),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.car, this.onPhoto = true});

  final Car car;
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final favorite =
        context.select((FavoritesCubit c) => c.state.contains(car.id));
    final button = IconButton(
      tooltip: favorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () => context.read<FavoritesCubit>().toggle(car),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
        child: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(favorite),
          color: favorite
              ? const Color(0xFFE5484D)
              : (onPhoto ? Colors.white : null),
        ),
      ),
    );
    if (!onPhoto) return button;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        shape: BoxShape.circle,
      ),
      child: button,
    );
  }
}

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.car, this.heroPrefix = 'list'});

  final Car car;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    final heroTag = '$heroPrefix-${car.id}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openCar(context, car, heroTag),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 190,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(tag: heroTag, child: CarImage(car.images.first)),
                  const ImageScrim(strength: 0.45),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _Pill(
                      icon: Icons.star_rounded,
                      label: car.rating.toStringAsFixed(1),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: FavoriteButton(car: car),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 12,
                    child: Text(
                      formatPrice(car.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      _Spec(Icons.calendar_today_outlined, '${car.year}'),
                      _Spec(Icons.speed_outlined, formatKm(car.mileageKm)),
                      _Spec(Icons.local_gas_station_outlined, car.fuel.label),
                      _Spec(Icons.settings_outlined, car.transmission.label),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 13)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFF5B942)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
