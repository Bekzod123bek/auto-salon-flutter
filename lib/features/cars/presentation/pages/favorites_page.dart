import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../cubit/cars_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../widgets/car_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesCubit>().state;
    final all = context.select((CarsCubit c) => c.state.all);
    final cars = all.where((c) => ids.contains(c.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: cars.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Tap the heart on any car to save it here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: cars.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (_, i) => CarCard(car: cars[i], heroPrefix: 'fav'),
            ),
    );
  }
}
