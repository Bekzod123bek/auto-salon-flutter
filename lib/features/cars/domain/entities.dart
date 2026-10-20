import 'package:equatable/equatable.dart';

enum SortOrder { priceAsc, priceDesc, yearDesc }

extension SortOrderLabel on SortOrder {
  String get label => switch (this) {
        SortOrder.priceAsc => 'Price: low to high',
        SortOrder.priceDesc => 'Price: high to low',
        SortOrder.yearDesc => 'Newest first',
      };
}

class Car extends Equatable {
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.mileageKm,
    required this.fuel,
    required this.transmission,
    required this.colorValue,
  });

  final String id;
  final String brand;
  final String model;
  final int year;
  final int price;
  final int mileageKm;
  final String fuel;
  final String transmission;
  final int colorValue;

  String get title => '$brand $model';

  @override
  List<Object?> get props => [id];
}

class TestDriveRequest extends Equatable {
  const TestDriveRequest({
    required this.car,
    required this.name,
    required this.phone,
    required this.date,
  });

  final Car car;
  final String name;
  final String phone;
  final DateTime date;

  @override
  List<Object?> get props => [car, name, phone, date];
}
