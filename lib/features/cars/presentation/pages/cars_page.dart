import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../cubit/cars_cubit.dart';
import 'car_detail_page.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Salon'),
        actions: [
          BlocBuilder<CarsCubit, CarsState>(
            buildWhen: (a, b) => a.sort != b.sort,
            builder: (context, state) => PopupMenuButton<SortOrder>(
              tooltip: 'Sort',
              icon: const Icon(Icons.sort),
              initialValue: state.sort,
              onSelected: context.read<CarsCubit>().setSort,
              itemBuilder: (_) => [
                for (final s in SortOrder.values)
                  PopupMenuItem(value: s, child: Text(s.label)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<CarsCubit, CarsState>(
            buildWhen: (a, b) => a.brand != b.brand || a.brands != b.brands,
            builder: (context, state) => SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _BrandChip(
                    label: 'All',
                    selected: state.brand == null,
                    onTap: () => context.read<CarsCubit>().selectBrand(null),
                  ),
                  for (final b in state.brands)
                    _BrandChip(
                      label: b,
                      selected: state.brand == b,
                      onTap: () => context.read<CarsCubit>().selectBrand(b),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CarsCubit, CarsState>(
              builder: (context, state) {
                if (state.loading && state.cars.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cars.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final car = state.cars[i];
                    return _CarCard(
                      car: car,
                      favorite: state.favorites.contains(car.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
        ),
      );
}

class _CarCard extends StatelessWidget {
  const _CarCard({required this.car, required this.favorite});

  final Car car;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BlocProvider.value(
              value: context.read<CarsCubit>(),
              child: CarDetailPage(car: car),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              color: Color(car.colorValue),
              alignment: Alignment.center,
              child: const Icon(Icons.directions_car, color: Colors.white, size: 56),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(car.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        Text('${car.year}  •  ${car.mileageKm} km  •  ${car.fuel}'),
                      ],
                    ),
                  ),
                  Text('\$${car.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    tooltip: favorite ? 'Remove from favorites' : 'Add to favorites',
                    icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
                    onPressed: () => context.read<CarsCubit>().toggleFavorite(car),
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
