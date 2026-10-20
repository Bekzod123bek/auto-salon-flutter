import 'package:equatable/equatable.dart';

enum SortOrder { recommended, priceAsc, priceDesc, yearDesc, mileageAsc }

extension SortOrderLabel on SortOrder {
  String get label => switch (this) {
        SortOrder.recommended => 'Recommended',
        SortOrder.priceAsc => 'Price: low to high',
        SortOrder.priceDesc => 'Price: high to low',
        SortOrder.yearDesc => 'Newest first',
        SortOrder.mileageAsc => 'Lowest mileage',
      };
}

enum FuelType { petrol, diesel, hybrid, electric, gas }

enum Transmission { automatic, manual }

enum BodyType { sedan, suv, hatchback, coupe, crossover }

enum DriveType { fwd, rwd, awd }

extension FuelTypeLabel on FuelType {
  String get label => switch (this) {
        FuelType.petrol => 'Petrol',
        FuelType.diesel => 'Diesel',
        FuelType.hybrid => 'Hybrid',
        FuelType.electric => 'Electric',
        FuelType.gas => 'Gas / Petrol',
      };
}

extension TransmissionLabel on Transmission {
  String get label => switch (this) {
        Transmission.automatic => 'Automatic',
        Transmission.manual => 'Manual',
      };
}

extension BodyTypeLabel on BodyType {
  String get label => switch (this) {
        BodyType.sedan => 'Sedan',
        BodyType.suv => 'SUV',
        BodyType.hatchback => 'Hatchback',
        BodyType.coupe => 'Coupe',
        BodyType.crossover => 'Crossover',
      };
}

extension DriveTypeLabel on DriveType {
  String get label => switch (this) {
        DriveType.fwd => 'FWD',
        DriveType.rwd => 'RWD',
        DriveType.awd => 'AWD',
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
    required this.body,
    required this.drive,
    required this.engine,
    required this.powerHp,
    required this.acceleration,
    required this.rating,
    required this.description,
    required this.features,
    required this.images,
    this.featured = false,
  });

  final String id;
  final String brand;
  final String model;
  final int year;
  final int price;
  final int mileageKm;
  final FuelType fuel;
  final Transmission transmission;
  final BodyType body;
  final DriveType drive;
  final String engine;
  final int powerHp;

  /// 0-100 km/h in seconds.
  final double acceleration;
  final double rating;
  final String description;
  final List<String> features;
  final List<String> images;
  final bool featured;

  String get title => '$brand $model';

  @override
  List<Object?> get props => [id];
}

/// Filters chosen in the filter sheet. `null` means "any".
class CarFilter extends Equatable {
  const CarFilter({
    this.query = '',
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.minYear,
    this.maxYear,
    this.maxMileage,
    this.fuels = const {},
    this.transmissions = const {},
    this.bodies = const {},
    this.sort = SortOrder.recommended,
  });

  final String query;
  final String? brand;
  final int? minPrice;
  final int? maxPrice;
  final int? minYear;
  final int? maxYear;
  final int? maxMileage;
  final Set<FuelType> fuels;
  final Set<Transmission> transmissions;
  final Set<BodyType> bodies;
  final SortOrder sort;

  /// Number of advanced filters in use (search, brand and sort not counted).
  int get activeCount => [
        minPrice != null || maxPrice != null,
        minYear != null || maxYear != null,
        maxMileage != null,
        fuels.isNotEmpty,
        transmissions.isNotEmpty,
        bodies.isNotEmpty,
      ].where((e) => e).length;

  bool matches(Car car) {
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty && !car.title.toLowerCase().contains(q)) return false;
    if (brand != null && car.brand != brand) return false;
    if (minPrice != null && car.price < minPrice!) return false;
    if (maxPrice != null && car.price > maxPrice!) return false;
    if (minYear != null && car.year < minYear!) return false;
    if (maxYear != null && car.year > maxYear!) return false;
    if (maxMileage != null && car.mileageKm > maxMileage!) return false;
    if (fuels.isNotEmpty && !fuels.contains(car.fuel)) return false;
    if (transmissions.isNotEmpty && !transmissions.contains(car.transmission)) {
      return false;
    }
    if (bodies.isNotEmpty && !bodies.contains(car.body)) return false;
    return true;
  }

  CarFilter copyWith({
    String? query,
    String? Function()? brand,
    int? Function()? minPrice,
    int? Function()? maxPrice,
    int? Function()? minYear,
    int? Function()? maxYear,
    int? Function()? maxMileage,
    Set<FuelType>? fuels,
    Set<Transmission>? transmissions,
    Set<BodyType>? bodies,
    SortOrder? sort,
  }) =>
      CarFilter(
        query: query ?? this.query,
        brand: brand != null ? brand() : this.brand,
        minPrice: minPrice != null ? minPrice() : this.minPrice,
        maxPrice: maxPrice != null ? maxPrice() : this.maxPrice,
        minYear: minYear != null ? minYear() : this.minYear,
        maxYear: maxYear != null ? maxYear() : this.maxYear,
        maxMileage: maxMileage != null ? maxMileage() : this.maxMileage,
        fuels: fuels ?? this.fuels,
        transmissions: transmissions ?? this.transmissions,
        bodies: bodies ?? this.bodies,
        sort: sort ?? this.sort,
      );

  /// Keeps search, brand and sort, clears the advanced filters.
  CarFilter clearAdvanced() =>
      CarFilter(query: query, brand: brand, sort: sort);

  @override
  List<Object?> get props => [
        query,
        brand,
        minPrice,
        maxPrice,
        minYear,
        maxYear,
        maxMileage,
        fuels,
        transmissions,
        bodies,
        sort,
      ];
}

class TestDriveRequest extends Equatable {
  const TestDriveRequest({
    required this.id,
    required this.carId,
    required this.carTitle,
    required this.name,
    required this.phone,
    required this.date,
  });

  final String id;
  final String carId;
  final String carTitle;
  final String name;
  final String phone;
  final DateTime date;

  Map<String, Object> toJson() => {
        'id': id,
        'carId': carId,
        'carTitle': carTitle,
        'name': name,
        'phone': phone,
        'date': date.toIso8601String(),
      };

  factory TestDriveRequest.fromJson(Map<String, dynamic> json) =>
      TestDriveRequest(
        id: json['id'] as String,
        carId: json['carId'] as String,
        carTitle: json['carTitle'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        date: DateTime.parse(json['date'] as String),
      );

  @override
  List<Object?> get props => [id, carId, carTitle, name, phone, date];
}
