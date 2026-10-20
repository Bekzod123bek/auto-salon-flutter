import 'entities.dart';

abstract class CarRepository {
  Future<List<Car>> getCars({String? brand, SortOrder sort = SortOrder.priceAsc});
  Future<List<String>> getBrands();
  Future<void> requestTestDrive(TestDriveRequest request);
  Future<List<TestDriveRequest>> getTestDrives();
}
