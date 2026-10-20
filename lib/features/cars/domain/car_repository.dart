import 'entities.dart';

abstract class CarRepository {
  Future<List<Car>> getCars({CarFilter filter = const CarFilter()});
  Future<Car?> getCar(String id);
  Future<List<String>> getBrands();

  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> ids);

  Future<List<TestDriveRequest>> getTestDrives();
  Future<void> saveTestDrives(List<TestDriveRequest> requests);
}
