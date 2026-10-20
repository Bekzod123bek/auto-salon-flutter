import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/car_image.dart';
import '../../domain/entities.dart';
import '../cubit/compare_cubit.dart';
import '../widgets/car_card.dart';
import '../widgets/loan_calculator_card.dart';
import '../widgets/test_drive_sheet.dart';

class CarDetailPage extends StatefulWidget {
  const CarDetailPage({super.key, required this.car, required this.heroTag});

  final Car car;
  final String heroTag;

  @override
  State<CarDetailPage> createState() => _CarDetailPageState();
}

class _CarDetailPageState extends State<CarDetailPage> {
  int _photo = 0;

  Car get car => widget.car;

  void _toggleCompare() {
    final result = context.read<CompareCubit>().toggle(car);
    final message = switch (result) {
      CompareResult.added => '${car.title} added to compare',
      CompareResult.removed => '${car.title} removed from compare',
      CompareResult.full =>
        'You can compare up to ${CompareCubit.maxCars} cars',
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inCompare = context.select((CompareCubit c) => c.state.contains(car));
    final specs = [
      (Icons.settings_input_component_outlined, 'Engine', car.engine),
      (Icons.bolt_outlined, 'Power', '${car.powerHp} hp'),
      (Icons.timer_outlined, '0–100 km/h', '${car.acceleration} s'),
      (Icons.local_gas_station_outlined, 'Fuel', car.fuel.label),
      (Icons.settings_outlined, 'Gearbox', car.transmission.label),
      (Icons.all_inclusive, 'Drive', car.drive.label),
      (Icons.calendar_today_outlined, 'Year', '${car.year}'),
      (Icons.speed_outlined, 'Mileage', formatKm(car.mileageKm)),
      (Icons.directions_car_outlined, 'Body', car.body.label),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: scheme.surface,
            foregroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.black38,
                child: BackButton(color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FavoriteButton(car: car),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: car.images.length,
                    onPageChanged: (i) => setState(() => _photo = i),
                    itemBuilder: (_, i) => i == 0
                        ? Hero(tag: widget.heroTag, child: CarImage(car.images[i]))
                        : CarImage(car.images[i]),
                  ),
                  const IgnorePointer(child: ImageScrim(strength: 0.6)),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('${_photo + 1} / ${car.images.length}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < car.images.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: i == _photo ? 20 : 6,
                            decoration: BoxDecoration(
                              color: i == _photo ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFF5B942), size: 20),
                              Text(' ${car.rating}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              Text('  •  ${car.body.label}',
                                  style:
                                      TextStyle(color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(formatPrice(car.price),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: scheme.primary)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(car.description,
                    style: TextStyle(
                        color: scheme.onSurfaceVariant, height: 1.5)),
                const SizedBox(height: 24),
                Text('Specifications',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95,
                  children: [
                    for (final (icon, label, value) in specs)
                      _SpecTile(icon: icon, label: label, value: value),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Features', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final f in car.features)
                      Chip(
                        avatar: Icon(Icons.check_circle,
                            size: 18, color: scheme.primary),
                        label: Text(f),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                LoanCalculatorCard(price: car.price),
                const SizedBox(height: 16),
                Text(
                  'Photos are illustrative and may not show this exact car.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: OutlinedButton(
                  onPressed: _toggleCompare,
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Icon(
                    inCompare ? Icons.compare_arrows : Icons.compare_arrows_outlined,
                    color: inCompare ? scheme.primary : null,
                    semanticLabel: inCompare ? 'Remove from compare' : 'Add to compare',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => showTestDriveSheet(context, car),
                  icon: const Icon(Icons.event_available_outlined),
                  label: const Text('Book a test drive'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecTile extends StatelessWidget {
  const _SpecTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
