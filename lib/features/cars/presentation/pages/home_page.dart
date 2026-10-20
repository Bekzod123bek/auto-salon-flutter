import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities.dart';
import '../cubit/cars_cubit.dart';
import '../widgets/car_card.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/filter_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthCubit c) => c.state.user);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => context.read<CarsCubit>().load(),
          child: BlocBuilder<CarsCubit, CarsState>(
            builder: (context, state) {
              final searching = state.filter.query.isNotEmpty ||
                  state.filter.brand != null ||
                  state.filter.activeCount > 0;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _Header(user: user)),
                  const SliverToBoxAdapter(child: _SearchRow()),
                  SliverToBoxAdapter(
                    child: _BrandRow(
                      brands: state.brands,
                      selected: state.filter.brand,
                    ),
                  ),
                  if (!searching && state.featured.isNotEmpty) ...[
                    const SliverToBoxAdapter(child: _SectionTitle('Featured')),
                    SliverToBoxAdapter(
                      child: FeaturedCarousel(cars: state.featured),
                    ),
                  ],
                  SliverToBoxAdapter(
                    child: _SectionTitle(
                      searching
                          ? '${state.cars.length} cars found'
                          : 'All cars',
                      trailing: const _SortButton(),
                    ),
                  ),
                  if (state.loading && state.cars.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(child: CarListSkeleton()),
                    )
                  else if (state.cars.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No cars match',
                        message: 'Try a different search or clear the filters.',
                        action: OutlinedButton(
                          onPressed: () => context
                              .read<CarsCubit>()
                              .applyFilter(const CarFilter()),
                          child: const Text('Clear all'),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList.separated(
                        itemCount: state.cars.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, i) => CarCard(car: state.cars[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final String? user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, ${user ?? 'guest'} 👋',
                    style: TextStyle(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text('Find your dream car',
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          CircleAvatar(
            radius: 24,
            backgroundColor: scheme.primary,
            child: Text(
              (user ?? 'G').characters.first.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    final filter = context.select((CarsCubit c) => c.state.filter);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: context.read<CarsCubit>().search,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search brand or model',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Badge(
            isLabelVisible: filter.activeCount > 0,
            label: Text('${filter.activeCount}'),
            child: IconButton.filled(
              tooltip: 'Filters',
              style: IconButton.styleFrom(
                minimumSize: const Size(54, 54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                final cubit = context.read<CarsCubit>();
                final result = await showFilterSheet(context, cubit.state.filter);
                if (result != null) await cubit.applyFilter(result);
              },
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.brands, required this.selected});

  final List<String> brands;
  final String? selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = <String?>[null, ...brands];
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final brand = items[i];
          final active = brand == selected;
          return GestureDetector(
            onTap: () => context.read<CarsCubit>().selectBrand(brand),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 54,
                  width: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? scheme.primary : scheme.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: brand == null
                      ? Icon(Icons.apps_rounded,
                          color: active ? Colors.white : scheme.onSurface)
                      : Text(
                          brand.substring(0, 1),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: active ? Colors.white : scheme.onSurface,
                          ),
                        ),
                ),
                const SizedBox(height: 6),
                Text(brand ?? 'All',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton();

  @override
  Widget build(BuildContext context) {
    final sort = context.select((CarsCubit c) => c.state.filter.sort);
    return PopupMenuButton<SortOrder>(
      tooltip: 'Sort',
      initialValue: sort,
      onSelected: context.read<CarsCubit>().setSort,
      itemBuilder: (_) => [
        for (final s in SortOrder.values)
          PopupMenuItem(value: s, child: Text(s.label)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded, size: 20),
            const SizedBox(width: 4),
            Text(sort.label),
          ],
        ),
      ),
    );
  }
}
