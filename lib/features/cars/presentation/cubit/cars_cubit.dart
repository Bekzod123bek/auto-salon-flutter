import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/car_repository.dart';
import '../../domain/entities.dart';

class CarsState extends Equatable {
  const CarsState({
    this.cars = const [],
    this.brands = const [],
    this.brand,
    this.sort = SortOrder.priceAsc,
    this.favorites = const {},
    this.loading = true,
  });

  final List<Car> cars;
  final List<String> brands;
  final String? brand;
  final SortOrder sort;
  final Set<String> favorites;
  final bool loading;

  CarsState copyWith({
    List<Car>? cars,
    List<String>? brands,
    String? brand,
    bool clearBrand = false,
    SortOrder? sort,
    Set<String>? favorites,
    bool? loading,
  }) =>
      CarsState(
        cars: cars ?? this.cars,
        brands: brands ?? this.brands,
        brand: clearBrand ? null : (brand ?? this.brand),
        sort: sort ?? this.sort,
        favorites: favorites ?? this.favorites,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [cars, brands, brand, sort, favorites, loading];
}

class CarsCubit extends Cubit<CarsState> {
  CarsCubit(this._repository) : super(const CarsState());

  final CarRepository _repository;

  Future<void> load() async {
    final brands = await _repository.getBrands();
    emit(state.copyWith(brands: brands));
    await _refresh();
  }

  Future<void> selectBrand(String? brand) async {
    emit(state.copyWith(brand: brand, clearBrand: brand == null));
    await _refresh();
  }

  Future<void> setSort(SortOrder sort) async {
    emit(state.copyWith(sort: sort));
    await _refresh();
  }

  void toggleFavorite(Car car) {
    final favorites = {...state.favorites};
    if (!favorites.add(car.id)) favorites.remove(car.id);
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> _refresh() async {
    emit(state.copyWith(loading: true));
    final cars = await _repository.getCars(brand: state.brand, sort: state.sort);
    emit(state.copyWith(cars: cars, loading: false));
  }
}
