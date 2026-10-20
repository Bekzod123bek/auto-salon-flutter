import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/car_repository.dart';
import '../../domain/entities.dart';

class CarsState extends Equatable {
  const CarsState({
    this.all = const [],
    this.cars = const [],
    this.featured = const [],
    this.brands = const [],
    this.filter = const CarFilter(),
    this.loading = true,
  });

  /// Every car, unfiltered.
  final List<Car> all;
  final List<Car> cars;
  final List<Car> featured;
  final List<String> brands;
  final CarFilter filter;
  final bool loading;

  CarsState copyWith({
    List<Car>? all,
    List<Car>? cars,
    List<Car>? featured,
    List<String>? brands,
    CarFilter? filter,
    bool? loading,
  }) =>
      CarsState(
        all: all ?? this.all,
        cars: cars ?? this.cars,
        featured: featured ?? this.featured,
        brands: brands ?? this.brands,
        filter: filter ?? this.filter,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [all, cars, featured, brands, filter, loading];
}

class CarsCubit extends Cubit<CarsState> {
  CarsCubit(this._repository) : super(const CarsState());

  final CarRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final brands = await _repository.getBrands();
    final all = await _repository.getCars();
    emit(state.copyWith(
      brands: brands,
      all: all,
      featured: all.where((c) => c.featured).toList(),
    ));
    await _refresh();
  }

  Future<void> search(String query) =>
      applyFilter(state.filter.copyWith(query: query));

  Future<void> selectBrand(String? brand) =>
      applyFilter(state.filter.copyWith(brand: () => brand));

  Future<void> setSort(SortOrder sort) =>
      applyFilter(state.filter.copyWith(sort: sort));

  Future<void> applyFilter(CarFilter filter) async {
    emit(state.copyWith(filter: filter));
    await _refresh();
  }

  Future<void> _refresh() async {
    emit(state.copyWith(loading: true));
    final filter = state.filter;
    final cars = await _repository.getCars(filter: filter);
    // Ignore results of an outdated request.
    if (filter != state.filter) return;
    emit(state.copyWith(cars: cars, loading: false));
  }
}
