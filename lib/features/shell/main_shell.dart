import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cars/presentation/cubit/compare_cubit.dart';
import '../cars/presentation/cubit/favorites_cubit.dart';
import '../cars/presentation/pages/compare_page.dart';
import '../cars/presentation/pages/favorites_page.dart';
import '../cars/presentation/pages/home_page.dart';
import '../cars/presentation/pages/profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final favorites = context.select((FavoritesCubit c) => c.state.length);
    final compare = context.select((CompareCubit c) => c.state.length);
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [HomePage(), FavoritesPage(), ComparePage(), ProfilePage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: favorites > 0,
              label: Text('$favorites'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: const Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: compare > 0,
              label: Text('$compare'),
              child: const Icon(Icons.compare_arrows_outlined),
            ),
            selectedIcon: const Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
