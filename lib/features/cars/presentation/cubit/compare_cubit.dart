import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';

enum CompareResult { added, removed, full }

/// Up to [maxCars] cars selected for side by side comparison.
class CompareCubit extends Cubit<List<Car>> {
  CompareCubit() : super(const []);

  static const maxCars = 3;

  bool contains(Car car) => state.contains(car);

  CompareResult toggle(Car car) {
    if (state.contains(car)) {
      emit([...state]..remove(car));
      return CompareResult.removed;
    }
    if (state.length >= maxCars) return CompareResult.full;
    emit([...state, car]);
    return CompareResult.added;
  }

  void clear() => emit(const []);
}
