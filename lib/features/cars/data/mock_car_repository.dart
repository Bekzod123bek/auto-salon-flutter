import 'dart:convert';

import '../../../core/storage/local_storage.dart';
import '../domain/car_repository.dart';
import '../domain/entities.dart';

/// Sample car list kept in memory. No backend is used; favorites and test
/// drive requests are stored on the device through [LocalStorage].
///
/// Photos are Unsplash images of the listed models; colours and trim may differ
/// from the car described.
class MockCarRepository implements CarRepository {
  MockCarRepository(this._storage, {this.delay = const Duration(milliseconds: 600)});

  final LocalStorage _storage;
  final Duration delay;

  static List<String> _photos(List<String> ids) => [
        for (final id in ids) 'https://images.unsplash.com/photo-$id?w=900&q=80',
      ];

  static final cars = <Car>[
    Car(
      id: 'c1',
      brand: 'Toyota',
      model: 'Camry',
      year: 2022,
      price: 27500,
      mileageKm: 34000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '2.5 Dynamic Force',
      powerHp: 203,
      acceleration: 8.4,
      rating: 4.6,
      description:
          'Comfortable business sedan with a reliable 2.5 engine, quiet cabin '
          'and low running costs. One owner, full service history.',
      features: ['Apple CarPlay', 'Rear camera', 'Adaptive cruise', 'Climate control'],
      images: _photos(['1621007947382-bb3c3994e3fb']),
    ),
    Car(
      id: 'c2',
      brand: 'Toyota',
      model: 'RAV4 Hybrid',
      year: 2023,
      price: 33900,
      mileageKm: 15000,
      fuel: FuelType.hybrid,
      transmission: Transmission.automatic,
      body: BodyType.crossover,
      drive: DriveType.awd,
      engine: '2.5 Hybrid',
      powerHp: 219,
      acceleration: 7.8,
      rating: 4.7,
      description:
          'Family crossover with an efficient hybrid system, all-wheel drive '
          'and a large boot.',
      features: ['Lane assist', 'Keyless entry', '360° camera', 'Heated seats'],
      images: _photos(['1617469767053-d3b523a0b982']),
    ),
    Car(
      id: 'c3',
      brand: 'Ford',
      model: 'Mustang GT',
      year: 2021,
      price: 38500,
      mileageKm: 22000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.coupe,
      drive: DriveType.rwd,
      engine: '5.0 V8',
      powerHp: 450,
      acceleration: 4.3,
      rating: 4.7,
      description:
          'Classic American muscle coupe with a naturally aspirated V8 and '
          'a 10-speed automatic gearbox.',
      features: ['Launch control', 'Digital cockpit', 'Performance exhaust', 'LED lights'],
      images: _photos(['1494976388531-d1058494cdd8']),
    ),
    Car(
      id: 'c4',
      brand: 'Chevrolet',
      model: 'Camaro',
      year: 2020,
      price: 36900,
      mileageKm: 28000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.coupe,
      drive: DriveType.rwd,
      engine: '6.2 V8',
      powerHp: 455,
      acceleration: 4.0,
      rating: 4.6,
      description:
          'Sporty coupe with a big V8, sharp handling and an aggressive look.',
      features: ['Head-up display', 'Brembo brakes', 'Bose audio', 'Rear camera'],
      images: _photos([
        '1492144534655-ae79c964c9d7',
        '1552519507-da3b142c6e3d',
      ]),
    ),
    Car(
      id: 'c5',
      brand: 'BMW',
      model: 'M4 Competition',
      year: 2022,
      price: 74500,
      mileageKm: 9000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.coupe,
      drive: DriveType.rwd,
      engine: '3.0 Twin-Turbo I6',
      powerHp: 503,
      acceleration: 3.9,
      rating: 4.8,
      featured: true,
      description:
          'High-performance coupe with a twin-turbo straight six, carbon roof '
          'and M sport seats. Photos show the model in different colours.',
      features: ['M sport seats', 'Carbon roof', 'Harman Kardon', 'Laser lights'],
      images: _photos([
        '1580273916550-e323be2ae537',
        '1617531653332-bd46c24f2068',
        '1568844293986-8d0400bd4745',
      ]),
    ),
    Car(
      id: 'c6',
      brand: 'BMW',
      model: '5 Series',
      year: 2021,
      price: 46900,
      mileageKm: 31000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.awd,
      engine: '3.0 Turbo I6',
      powerHp: 335,
      acceleration: 4.8,
      rating: 4.6,
      description:
          'Executive sedan with xDrive all-wheel drive, a refined cabin and '
          'plenty of driver assistance features.',
      features: ['xDrive', 'Parking assistant', 'Ambient lighting', 'Heated seats'],
      images: _photos([
        '1546614042-7df3c24c9e5d',
        '1555215695-3004980ad54e',
      ]),
    ),
    Car(
      id: 'c7',
      brand: 'Land Rover',
      model: 'Range Rover',
      year: 2021,
      price: 89000,
      mileageKm: 26000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.suv,
      drive: DriveType.awd,
      engine: '3.0 MHEV I6',
      powerHp: 395,
      acceleration: 5.9,
      rating: 4.7,
      description:
          'Luxury full-size SUV with air suspension, a premium leather '
          'interior and real off-road ability.',
      features: ['Air suspension', 'Panoramic roof', 'Meridian audio', 'Terrain Response'],
      images: _photos(['1563720223185-11003d516935']),
    ),
    Car(
      id: 'c8',
      brand: 'Mercedes-AMG',
      model: 'GT',
      year: 2021,
      price: 118000,
      mileageKm: 7000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.coupe,
      drive: DriveType.rwd,
      engine: '4.0 V8 Biturbo',
      powerHp: 523,
      acceleration: 3.7,
      rating: 4.9,
      featured: true,
      description:
          'Front-mid-engine sports car with a hand-built AMG V8. Photos show '
          'the model in different colours and versions.',
      features: ['AMG Performance seats', 'Burmester audio', 'Ceramic brakes', 'Track pace'],
      images: _photos([
        '1617814076367-b759c7d7e738',
        '1618843479313-40f8afb4b4d8',
        '1553440569-bcc63803a83d',
        '1605559424843-9e4c228bf1c2',
      ]),
    ),
    Car(
      id: 'c9',
      brand: 'Audi',
      model: 'RS 7 Sportback',
      year: 2022,
      price: 112000,
      mileageKm: 11000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.awd,
      engine: '4.0 TFSI V8',
      powerHp: 591,
      acceleration: 3.6,
      rating: 4.8,
      description:
          'Five-door sports sedan with quattro all-wheel drive and a twin-turbo '
          'V8. Fast and practical every day.',
      features: ['quattro', 'Matrix LED', 'Bang & Olufsen', 'Virtual cockpit'],
      images: _photos(['1616422285623-13ff0162193c']),
    ),
    Car(
      id: 'c10',
      brand: 'Tesla',
      model: 'Model 3',
      year: 2024,
      price: 42500,
      mileageKm: 3000,
      fuel: FuelType.electric,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.awd,
      engine: 'Dual motor',
      powerHp: 394,
      acceleration: 4.4,
      rating: 4.7,
      description:
          'Electric sedan with a long range, over-the-air updates and a '
          'minimalist cabin with a 15" screen.',
      features: ['Autopilot', 'Glass roof', 'Heat pump', 'Supercharging'],
      images: _photos(['1606016159991-dfe4f2746ad5']),
    ),
    Car(
      id: 'c11',
      brand: 'Tesla',
      model: 'Model S',
      year: 2022,
      price: 79900,
      mileageKm: 18000,
      fuel: FuelType.electric,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.awd,
      engine: 'Dual motor',
      powerHp: 670,
      acceleration: 3.1,
      rating: 4.8,
      featured: true,
      description:
          'Flagship electric liftback with very quick acceleration and a range '
          'of more than 600 km.',
      features: ['Autopilot', 'Yoke steering', 'Premium audio', 'Supercharging'],
      images: _photos(['1620891549027-942fdc95d3f5']),
    ),
    Car(
      id: 'c12',
      brand: 'Lamborghini',
      model: 'Huracán EVO',
      year: 2021,
      price: 239000,
      mileageKm: 5000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.coupe,
      drive: DriveType.awd,
      engine: '5.2 V10',
      powerHp: 631,
      acceleration: 2.9,
      rating: 4.8,
      featured: true,
      description:
          'Mid-engine supercar with a naturally aspirated V10. Photos show the '
          'model in different colours and versions.',
      features: ['Lifting system', 'Carbon ceramic brakes', 'Sport exhaust', 'Alcantara'],
      images: _photos([
        '1511919884226-fd3cad34687c',
        '1580414057403-c5f451f30e1c',
        '1612825173281-9a193378527e',
      ]),
    ),
  ];

  @override
  Future<List<Car>> getCars({CarFilter filter = const CarFilter()}) async {
    await Future<void>.delayed(delay);
    final result = cars.where(filter.matches).toList();
    switch (filter.sort) {
      case SortOrder.recommended:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOrder.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortOrder.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortOrder.yearDesc:
        result.sort((a, b) => b.year.compareTo(a.year));
      case SortOrder.mileageAsc:
        result.sort((a, b) => a.mileageKm.compareTo(b.mileageKm));
    }
    return result;
  }

  @override
  Future<Car?> getCar(String id) async {
    for (final car in cars) {
      if (car.id == id) return car;
    }
    return null;
  }

  @override
  Future<List<String>> getBrands() async =>
      cars.map((c) => c.brand).toSet().toList()..sort();

  @override
  Future<Set<String>> getFavoriteIds() async => _storage.favorites.toSet();

  @override
  Future<void> saveFavoriteIds(Set<String> ids) =>
      _storage.setFavorites(ids.toList());

  @override
  Future<List<TestDriveRequest>> getTestDrives() async {
    final raw = _storage.testDrivesJson;
    if (raw == null) return const [];
    final list = jsonDecode(raw) as List<dynamic>;
    return [
      for (final item in list)
        TestDriveRequest.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<void> saveTestDrives(List<TestDriveRequest> requests) =>
      _storage.setTestDrivesJson(
          jsonEncode([for (final r in requests) r.toJson()]));
}
