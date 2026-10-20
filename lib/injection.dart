import 'package:get_it/get_it.dart';

import 'features/cars/data/mock_car_repository.dart';
import 'features/cars/domain/car_repository.dart';
import 'features/cars/presentation/cubit/cars_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await sl.reset();
  sl
    ..registerLazySingleton<CarRepository>(MockCarRepository.new)
    ..registerFactory(() => CarsCubit(sl())..load());
}
