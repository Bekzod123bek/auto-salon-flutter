import 'dart:convert';

import '../../../core/storage/local_storage.dart';
import '../domain/car_repository.dart';
import '../domain/entities.dart';

/// Sample car list kept in memory. No backend is used; favorites and test
/// drive requests are stored on the device through [LocalStorage].
///
/// Photos are illustrative Unsplash images and are not guaranteed to show the
/// exact listed model.
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
      brand: 'Chevrolet',
      model: 'Onix LTZ',
      year: 2024,
      price: 15200,
      mileageKm: 8000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '1.2 Turbo',
      powerHp: 132,
      acceleration: 10.1,
      rating: 4.5,
      featured: true,
      description:
          'Compact city sedan with a turbo engine, low fuel use and a modern '
          'infotainment system. One owner, full service history.',
      features: ['Apple CarPlay', 'Rear camera', 'Cruise control', 'Climate control'],
      images: _photos([
        '1494976388531-d1058494cdd8',
        '1503376780353-7e6692767b70',
        '1492144534655-ae79c964c9d7',
        '1502877338535-766e1452684a',
      ]),
    ),
    Car(
      id: 'c2',
      brand: 'Chevrolet',
      model: 'Tracker Premier',
      year: 2023,
      price: 21400,
      mileageKm: 21000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.crossover,
      drive: DriveType.fwd,
      engine: '1.2 Turbo',
      powerHp: 132,
      acceleration: 10.9,
      rating: 4.4,
      description:
          'Practical crossover with high seating position, large boot and '
          'a full set of driver assistance features.',
      features: ['Lane assist', 'Keyless entry', 'Rear camera', 'Heated seats'],
      images: _photos([
        '1511919884226-fd3cad34687c',
        '1542362567-b07e54358753',
        '1549317661-bd32c8ce0db2',
        '1552519507-da3b142c6e3d',
      ]),
    ),
    Car(
      id: 'c3',
      brand: 'Kia',
      model: 'K5 GT-Line',
      year: 2023,
      price: 27900,
      mileageKm: 19500,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '2.5 GDI',
      powerHp: 194,
      acceleration: 8.6,
      rating: 4.7,
      featured: true,
      description:
          'Sporty midsize sedan with a sharp design, panoramic roof and '
          'a premium sound system.',
      features: ['Panoramic roof', 'Bose audio', 'Adaptive cruise', 'Wireless charging'],
      images: _photos([
        '1525609004556-c46c7d6cf023',
        '1533473359331-0135ef1b58bf',
        '1544636331-e26879cd4d9b',
        '1555215695-3004980ad54e',
      ]),
    ),
    Car(
      id: 'c4',
      brand: 'Kia',
      model: 'Sportage',
      year: 2021,
      price: 23800,
      mileageKm: 54000,
      fuel: FuelType.diesel,
      transmission: Transmission.automatic,
      body: BodyType.suv,
      drive: DriveType.awd,
      engine: '2.0 CRDi',
      powerHp: 185,
      acceleration: 9.5,
      rating: 4.5,
      description:
          'All-wheel drive SUV with an economical diesel engine. Ideal for '
          'family trips and mountain roads.',
      features: ['AWD', 'Leather seats', 'Navigation', 'Parking sensors'],
      images: _photos([
        '1580273916550-e323be2ae537',
        '1583121274602-3e2820c69888',
        '1617814076367-b759c7d7e738',
        '1606664515524-ed2f786a0bd6',
      ]),
    ),
    Car(
      id: 'c5',
      brand: 'Hyundai',
      model: 'Sonata',
      year: 2020,
      price: 19900,
      mileageKm: 68000,
      fuel: FuelType.gas,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '2.0 MPi',
      powerHp: 150,
      acceleration: 10.7,
      rating: 4.3,
      description:
          'Comfortable business sedan with factory gas equipment, which keeps '
          'running costs very low.',
      features: ['Gas equipment', 'Ventilated seats', 'Rear camera', 'LED lights'],
      images: _photos([
        '1617531653332-bd46c24f2068',
        '1619767886558-efdc259cde1a',
        '1609521263047-f8f205293f24',
        '1606016159991-dfe4f2746ad5',
      ]),
    ),
    Car(
      id: 'c6',
      brand: 'Hyundai',
      model: 'Tucson',
      year: 2022,
      price: 26500,
      mileageKm: 32000,
      fuel: FuelType.hybrid,
      transmission: Transmission.automatic,
      body: BodyType.suv,
      drive: DriveType.awd,
      engine: '1.6 T-GDi Hybrid',
      powerHp: 230,
      acceleration: 8.0,
      rating: 4.6,
      featured: true,
      description:
          'Hybrid SUV with strong acceleration and low consumption in the city. '
          'Digital cockpit and a large touchscreen.',
      features: ['Hybrid', 'Digital cockpit', '360° camera', 'Blind spot monitor'],
      images: _photos([
        '1618843479313-40f8afb4b4d8',
        '1621007947382-bb3c3994e3fb',
        '1600712242805-5f78671b24da',
        '1563720223185-11003d516935',
      ]),
    ),
    Car(
      id: 'c7',
      brand: 'BYD',
      model: 'Song Plus DM-i',
      year: 2024,
      price: 31500,
      mileageKm: 3000,
      fuel: FuelType.hybrid,
      transmission: Transmission.automatic,
      body: BodyType.crossover,
      drive: DriveType.fwd,
      engine: '1.5 Plug-in Hybrid',
      powerHp: 218,
      acceleration: 7.9,
      rating: 4.6,
      description:
          'Plug-in hybrid crossover that can drive short distances on '
          'electricity only. Rotating central screen.',
      features: ['Plug-in hybrid', 'Rotating screen', 'Heated seats', 'Adaptive cruise'],
      images: _photos([
        '1568844293986-8d0400bd4745',
        '1541899481282-d53bffe3c35d',
        '1590362891991-f776e747a588',
        '1489824904134-891ab64532f1',
      ]),
    ),
    Car(
      id: 'c8',
      brand: 'BYD',
      model: 'Han EV',
      year: 2023,
      price: 36800,
      mileageKm: 12000,
      fuel: FuelType.electric,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.awd,
      engine: 'Dual motor EV',
      powerHp: 517,
      acceleration: 3.9,
      rating: 4.8,
      featured: true,
      description:
          'Fully electric flagship sedan with a long range and very quick '
          'acceleration. Fast charging supported.',
      features: ['Fast charging', 'Head-up display', 'Massage seats', 'Dynaudio audio'],
      images: _photos([
        '1514316454349-750a7fd3da3a',
        '1550355291-bbee04a92027',
        '1546614042-7df3c24c9e5d',
        '1553440569-bcc63803a83d',
      ]),
    ),
    Car(
      id: 'c9',
      brand: 'Toyota',
      model: 'Camry 75',
      year: 2021,
      price: 29900,
      mileageKm: 41000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '2.5 Dynamic Force',
      powerHp: 200,
      acceleration: 8.7,
      rating: 4.7,
      description:
          'Reliable executive sedan known for low maintenance costs and '
          'a quiet, comfortable ride.',
      features: ['JBL audio', 'Leather seats', 'Adaptive cruise', 'Rear sunshade'],
      images: _photos([
        '1580414057403-c5f451f30e1c',
        '1605559424843-9e4c228bf1c2',
        '1616422285623-13ff0162193c',
        '1612825173281-9a193378527e',
      ]),
    ),
    Car(
      id: 'c10',
      brand: 'Toyota',
      model: 'RAV4',
      year: 2020,
      price: 27200,
      mileageKm: 59000,
      fuel: FuelType.petrol,
      transmission: Transmission.automatic,
      body: BodyType.suv,
      drive: DriveType.awd,
      engine: '2.0 Valvematic',
      powerHp: 149,
      acceleration: 10.2,
      rating: 4.5,
      description:
          'Popular all-wheel drive SUV with a roomy interior and good '
          'ground clearance.',
      features: ['AWD', 'Rear camera', 'Lane assist', 'Power tailgate'],
      images: _photos([
        '1626668893632-6f3a4466d22f',
        '1619405399517-d7fce0f13302',
        '1603584173870-7f23fdae1b7a',
        '1617469767053-d3b523a0b982',
      ]),
    ),
    Car(
      id: 'c11',
      brand: 'Chevrolet',
      model: 'Cobalt',
      year: 2022,
      price: 11800,
      mileageKm: 36000,
      fuel: FuelType.petrol,
      transmission: Transmission.manual,
      body: BodyType.sedan,
      drive: DriveType.fwd,
      engine: '1.5 MPi',
      powerHp: 106,
      acceleration: 11.7,
      rating: 4.1,
      description:
          'Affordable and easy to maintain sedan with a big boot. A sensible '
          'first car.',
      features: ['Air conditioning', 'Bluetooth', 'Power windows'],
      images: _photos([
        '1620891549027-942fdc95d3f5',
        '1606611013016-969c19ba27bb',
        '1617788138017-80ad40651399',
        '1631295868223-63265b40d9e4',
      ]),
    ),
    Car(
      id: 'c12',
      brand: 'Kia',
      model: 'Picanto',
      year: 2019,
      price: 9800,
      mileageKm: 72000,
      fuel: FuelType.petrol,
      transmission: Transmission.manual,
      body: BodyType.hatchback,
      drive: DriveType.fwd,
      engine: '1.0 MPi',
      powerHp: 67,
      acceleration: 14.3,
      rating: 4.0,
      description:
          'Small hatchback that is easy to park and very cheap to run. '
          'Great for daily city driving.',
      features: ['Bluetooth', 'Air conditioning', 'Parking sensors'],
      images: _photos([
        '1571068316344-75bc76f77890',
        '1504215680853-026ed2a45def',
        '1517524008697-84bbe3c3fd98',
        '1485291571150-772bcfc10da5',
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
