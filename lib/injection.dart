import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/storage/local_storage.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cars/data/mock_car_repository.dart';
import 'features/cars/domain/car_repository.dart';
import 'features/cars/presentation/cubit/cars_cubit.dart';
import 'features/cars/presentation/cubit/compare_cubit.dart';
import 'features/cars/presentation/cubit/favorites_cubit.dart';
import 'features/cars/presentation/cubit/test_drive_cubit.dart';

final sl = GetIt.instance;

/// [fast] removes artificial loading delays (used in tests).
Future<void> setupDependencies({bool fast = false}) async {
  await sl.reset();
  final prefs = await SharedPreferences.getInstance();
  final delay = fast ? Duration.zero : const Duration(milliseconds: 600);
  sl
    ..registerSingleton(LocalStorage(prefs))
    ..registerLazySingleton<CarRepository>(
        () => MockCarRepository(sl(), delay: delay))
    ..registerLazySingleton(() => AuthRepository(sl(), delay: delay))
    ..registerFactory(() => ThemeCubit(sl()))
    ..registerFactory(() => AuthCubit(sl()))
    ..registerFactory(() => CarsCubit(sl())..load())
    ..registerFactory(() => FavoritesCubit(sl())..load())
    ..registerFactory(() => TestDriveCubit(sl())..load())
    ..registerFactory(CompareCubit.new);
}
