import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/car_repository.dart';
import '../../domain/entities.dart';

/// Ids of favorite cars, stored on the device.
class FavoritesCubit extends Cubit<Set<String>> {
  FavoritesCubit(this._repository) : super(const {});

  final CarRepository _repository;

  Future<void> load() async => emit(await _repository.getFavoriteIds());

  bool isFavorite(Car car) => state.contains(car.id);

  Future<void> toggle(Car car) async {
    final ids = {...state};
    if (!ids.add(car.id)) ids.remove(car.id);
    emit(ids);
    await _repository.saveFavoriteIds(ids);
  }
}
