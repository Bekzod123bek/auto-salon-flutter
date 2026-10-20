import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/car_repository.dart';
import '../../domain/entities.dart';

/// Test drive requests made on this device, newest first.
class TestDriveCubit extends Cubit<List<TestDriveRequest>> {
  TestDriveCubit(this._repository) : super(const []);

  final CarRepository _repository;

  Future<void> load() async => emit(await _repository.getTestDrives());

  Future<void> request({
    required Car car,
    required String name,
    required String phone,
    required DateTime date,
  }) async {
    final request = TestDriveRequest(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      carId: car.id,
      carTitle: car.title,
      name: name,
      phone: phone,
      date: date,
    );
    final updated = [request, ...state];
    emit(updated);
    await _repository.saveTestDrives(updated);
  }

  Future<void> cancel(String id) async {
    final updated = state.where((r) => r.id != id).toList();
    emit(updated);
    await _repository.saveTestDrives(updated);
  }
}
