import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';
import 'features/cars/presentation/cubit/cars_cubit.dart';
import 'features/cars/presentation/cubit/compare_cubit.dart';
import 'features/cars/presentation/cubit/favorites_cubit.dart';
import 'features/cars/presentation/cubit/test_drive_cubit.dart';
import 'features/shell/main_shell.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const AutoSalonApp());
}

class AutoSalonApp extends StatelessWidget {
  const AutoSalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<CarsCubit>()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
        BlocProvider(create: (_) => sl<TestDriveCubit>()),
        BlocProvider(create: (_) => sl<CompareCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          title: 'Auto Salon',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          home: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (a, b) => a.status != b.status,
            builder: (context, state) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: switch (state.status) {
                AuthStatus.onboarding => const OnboardingPage(),
                AuthStatus.signedOut => const LoginPage(),
                AuthStatus.signedIn => const MainShell(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
