import 'package:auto_salon/features/cars/data/mock_car_repository.dart';
import 'package:auto_salon/features/cars/domain/entities.dart';
import 'package:auto_salon/features/cars/presentation/cubit/cars_cubit.dart';
import 'package:auto_salon/injection.dart';
import 'package:auto_salon/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cars are sorted by price and filtered by brand', () async {
    final repo = MockCarRepository();

    final cheapFirst = await repo.getCars();
    expect(cheapFirst.first.price, lessThanOrEqualTo(cheapFirst.last.price));

    final kia = await repo.getCars(brand: 'Kia');
    expect(kia, isNotEmpty);
    expect(kia.every((c) => c.brand == 'Kia'), isTrue);

    final newest = await repo.getCars(sort: SortOrder.yearDesc);
    expect(newest.first.year, greaterThanOrEqualTo(newest.last.year));
  });

  test('favorites can be toggled', () async {
    final cubit = CarsCubit(MockCarRepository());
    await cubit.load();
    final car = cubit.state.cars.first;

    cubit.toggleFavorite(car);
    expect(cubit.state.favorites, contains(car.id));
    cubit.toggleFavorite(car);
    expect(cubit.state.favorites, isEmpty);
  });

  testWidgets('app shows the car list', (tester) async {
    await setupDependencies();
    await tester.pumpWidget(const AutoSalonApp());
    await tester.pumpAndSettle();
    expect(find.text('Chevrolet Onix'), findsOneWidget);
  });
}
