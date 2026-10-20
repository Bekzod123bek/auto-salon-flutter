import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/cars/presentation/cubit/cars_cubit.dart';
import 'features/cars/presentation/pages/cars_page.dart';
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
    return BlocProvider(
      create: (_) => sl<CarsCubit>(),
      child: MaterialApp(
        title: 'Auto Salon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1F2A44),
          useMaterial3: true,
        ),
        home: const CarsPage(),
      ),
    );
  }
}
