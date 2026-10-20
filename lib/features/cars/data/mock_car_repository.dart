import '../domain/car_repository.dart';
import '../domain/entities.dart';

/// In-memory car list with sample data. No backend is used.
class MockCarRepository implements CarRepository {
  static const _cars = <Car>[
    Car(
      id: 'c1',
      brand: 'Chevrolet',
      model: 'Onix',
      year: 2023,
      price: 14500,
      mileageKm: 12000,
      fuel: 'Petrol',
      transmission: 'Automatic',
      colorValue: 0xFFB0B7C3,
    ),
    Car(
      id: 'c2',
      brand: 'Chevrolet',
      model: 'Tracker',
      year: 2022,
      price: 19800,
      mileageKm: 30500,
      fuel: 'Petrol',
      transmission: 'Automatic',
      colorValue: 0xFF1F2A44,
    ),
    Car(
      id: 'c3',
      brand: 'Kia',
      model: 'K5',
      year: 2021,
      price: 24500,
      mileageKm: 48000,
      fuel: 'Petrol',
      transmission: 'Automatic',
      colorValue: 0xFF8D1D2C,
    ),
    Car(
      id: 'c4',
      brand: 'Hyundai',
      model: 'Sonata',
      year: 2020,
      price: 21000,
      mileageKm: 62000,
      fuel: 'Gas / Petrol',
      transmission: 'Automatic',
      colorValue: 0xFF2B2D42,
    ),
    Car(
      id: 'c5',
      brand: 'BYD',
      model: 'Song Plus',
      year: 2024,
      price: 31000,
      mileageKm: 5000,
      fuel: 'Hybrid',
      transmission: 'Automatic',
      colorValue: 0xFF2A9D8F,
    ),
    Car(
      id: 'c6',
      brand: 'Kia',
      model: 'Sportage',
      year: 2019,
      price: 22500,
      mileageKm: 81000,
      fuel: 'Diesel',
      transmission: 'Manual',
      colorValue: 0xFF6C757D,
    ),
  ];

  final List<TestDriveRequest> _requests = [];

  @override
  Future<List<Car>> getCars({
    String? brand,
    SortOrder sort = SortOrder.priceAsc,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final cars = _cars.where((c) => brand == null || c.brand == brand).toList();
    cars.sort(switch (sort) {
      SortOrder.priceAsc => (a, b) => a.price.compareTo(b.price),
      SortOrder.priceDesc => (a, b) => b.price.compareTo(a.price),
      SortOrder.yearDesc => (a, b) => b.year.compareTo(a.year),
    });
    return cars;
  }

  @override
  Future<List<String>> getBrands() async =>
      (_cars.map((c) => c.brand).toSet().toList()..sort());

  @override
  Future<void> requestTestDrive(TestDriveRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _requests.add(request);
  }

  @override
  Future<List<TestDriveRequest>> getTestDrives() async =>
      List.unmodifiable(_requests);
}
