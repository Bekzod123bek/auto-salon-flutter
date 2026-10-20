import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/test_drive_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = context.select((AuthCubit c) => c.state.user) ?? 'Guest';
    final requests = context.watch<TestDriveCubit>().state;
    final favorites = context.select((FavoritesCubit c) => c.state.length);
    final dark = context.select((ThemeCubit c) => c.isDark);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.primary.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Text(user.characters.first.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      Text('$favorites favorites  •  ${requests.length} test drives',
                          style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('My test drives', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (requests.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.event_busy_outlined, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Text('No requests yet. Book one from a car page.')),
                  ],
                ),
              ),
            )
          else
            for (final r in requests)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Card(
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: scheme.primary.withValues(alpha: 0.15),
                      child: Icon(Icons.event_available, color: scheme.primary),
                    ),
                    title: Text(r.carTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${formatDate(r.date)}\n${r.phone}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      tooltip: 'Cancel request',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        context.read<TestDriveCubit>().cancel(r.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Request cancelled')),
                        );
                      },
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 24),
          Text('Settings', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark mode'),
                  value: dark,
                  onChanged: context.read<ThemeCubit>().setDark,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: scheme.error),
                  title: Text('Log out', style: TextStyle(color: scheme.error)),
                  onTap: () => context.read<AuthCubit>().signOut(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Auto Salon demo  •  sample data, photos from Unsplash',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
