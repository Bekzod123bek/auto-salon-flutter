import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/car_image.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities.dart';
import '../cubit/compare_cubit.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cars = context.watch<CompareCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare'),
        actions: [
          if (cars.isNotEmpty)
            TextButton(
              onPressed: context.read<CompareCubit>().clear,
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cars.isEmpty
          ? const EmptyState(
              icon: Icons.compare_arrows_rounded,
              title: 'Nothing to compare',
              message:
                  'Open a car and tap the compare button. You can add up to 3 cars.',
            )
          : _CompareTable(cars: cars),
    );
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable({required this.cars});

  final List<Car> cars;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Rows: label plus a value per car. `best` marks the winning index.
    final rows = <(String, List<String>, int?)>[
      (
        'Price',
        [for (final c in cars) formatPrice(c.price)],
        _bestIndex(cars, (c) => -c.price.toDouble()),
      ),
      ('Year', [for (final c in cars) '${c.year}'],
          _bestIndex(cars, (c) => c.year.toDouble())),
      (
        'Mileage',
        [for (final c in cars) formatKm(c.mileageKm)],
        _bestIndex(cars, (c) => -c.mileageKm.toDouble()),
      ),
      ('Power', [for (final c in cars) '${c.powerHp} hp'],
          _bestIndex(cars, (c) => c.powerHp.toDouble())),
      ('0–100', [for (final c in cars) '${c.acceleration} s'],
          _bestIndex(cars, (c) => -c.acceleration)),
      ('Engine', [for (final c in cars) c.engine], null),
      ('Fuel', [for (final c in cars) c.fuel.label], null),
      ('Gearbox', [for (final c in cars) c.transmission.label], null),
      ('Drive', [for (final c in cars) c.drive.label], null),
      ('Body', [for (final c in cars) c.body.label], null),
      ('Rating', [for (final c in cars) '${c.rating}'],
          _bestIndex(cars, (c) => c.rating)),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            const SizedBox(width: 84),
            for (final car in cars)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 80,
                              child: CarImage(car.images.first),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              tooltip: 'Remove',
                              visualDensity: VisualDensity.compact,
                              style: IconButton.styleFrom(
                                  backgroundColor: Colors.black45),
                              onPressed: () =>
                                  context.read<CompareCubit>().toggle(car),
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(car.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        for (final (i, (label, values, best)) in rows.indexed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: i.isEven ? scheme.surfaceContainer : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 76,
                  child: Text(label,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                ),
                for (final (j, value) in values.indexed)
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: (cars.length > 1 && best == j)
                            ? scheme.primary
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Text(
          'Highlighted values are the best in each row.',
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }

  static int _bestIndex(List<Car> cars, double Function(Car) score) {
    var best = 0;
    for (var i = 1; i < cars.length; i++) {
      if (score(cars[i]) > score(cars[best])) best = i;
    }
    return best;
  }
}
