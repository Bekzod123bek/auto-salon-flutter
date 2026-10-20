import 'package:auto_salon/core/storage/local_storage.dart';
import 'package:auto_salon/core/theme/theme_cubit.dart';
import 'package:auto_salon/core/utils/loan_calculator.dart';
import 'package:auto_salon/core/widgets/car_image.dart';
import 'package:auto_salon/features/auth/data/auth_repository.dart';
import 'package:auto_salon/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_salon/features/cars/data/mock_car_repository.dart';
import 'package:auto_salon/features/cars/domain/entities.dart';
import 'package:auto_salon/features/cars/presentation/cubit/cars_cubit.dart';
import 'package:auto_salon/features/cars/presentation/cubit/compare_cubit.dart';
import 'package:auto_salon/features/cars/presentation/cubit/favorites_cubit.dart';
import 'package:auto_salon/features/cars/presentation/cubit/test_drive_cubit.dart';
import 'package:auto_salon/injection.dart';
import 'package:auto_salon/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LocalStorage> _storage([Map<String, Object> values = const {}]) async {
  SharedPreferences.setMockInitialValues(values);
  return LocalStorage(await SharedPreferences.getInstance());
}

void main() {
  setUpAll(() => CarImage.useCache = false);

  group('MockCarRepository', () {
    late MockCarRepository repo;

    setUp(() async => repo = MockCarRepository(await _storage(), delay: Duration.zero));

    test('has 12 cars with photos', () async {
      final cars = await repo.getCars();
      expect(cars, hasLength(12));
      expect(cars.every((c) => c.images.isNotEmpty), isTrue);
    });

    test('filters by brand, fuel, price and year', () async {
      final bmw = await repo.getCars(filter: const CarFilter(brand: 'BMW'));
      expect(bmw, isNotEmpty);
      expect(bmw.every((c) => c.brand == 'BMW'), isTrue);

      final hybrids =
          await repo.getCars(filter: const CarFilter(fuels: {FuelType.hybrid}));
      expect(hybrids.every((c) => c.fuel == FuelType.hybrid), isTrue);

      final cheapNew = await repo.getCars(
          filter: const CarFilter(maxPrice: 45000, minYear: 2022));
      expect(cheapNew, isNotEmpty);
      expect(cheapNew,
          everyElement(predicate<Car>((c) => c.price <= 45000 && c.year >= 2022)));
    });

    test('search matches brand and model', () async {
      final result = await repo.getCars(filter: const CarFilter(query: 'camry'));
      expect(result.single.title, 'Toyota Camry');
    });

    test('sorts by price', () async {
      final asc =
          await repo.getCars(filter: const CarFilter(sort: SortOrder.priceAsc));
      for (var i = 1; i < asc.length; i++) {
        expect(asc[i].price, greaterThanOrEqualTo(asc[i - 1].price));
      }
    });
  });

  group('CarFilter', () {
    test('activeCount ignores search, brand and sort', () {
      const filter = CarFilter(
        query: 'bmw',
        brand: 'BMW',
        sort: SortOrder.priceDesc,
        maxPrice: 20000,
        transmissions: {Transmission.manual},
      );
      expect(filter.activeCount, 2);
      expect(filter.clearAdvanced().activeCount, 0);
      expect(filter.clearAdvanced().brand, 'BMW');
    });
  });

  group('LoanCalculator', () {
    test('zero interest splits the principal evenly', () {
      expect(
        LoanCalculator.monthlyPayment(
            principal: 12000, months: 12, annualRatePercent: 0),
        1000,
      );
    });

    test('annuity payment matches the standard formula', () {
      final payment = LoanCalculator.monthlyPayment(
          principal: 10000, months: 12, annualRatePercent: 12);
      expect(payment, closeTo(888.49, 0.01));
    });

    test('no loan means no payment', () {
      expect(
        LoanCalculator.monthlyPayment(
            principal: 0, months: 24, annualRatePercent: 20),
        0,
      );
    });
  });

  group('Cubits', () {
    test('CarsCubit applies brand and sort', () async {
      final cubit =
          CarsCubit(MockCarRepository(await _storage(), delay: Duration.zero));
      await cubit.load();
      expect(cubit.state.all, hasLength(12));
      expect(cubit.state.featured, isNotEmpty);

      await cubit.selectBrand('Toyota');
      expect(cubit.state.cars.every((c) => c.brand == 'Toyota'), isTrue);

      await cubit.selectBrand(null);
      await cubit.setSort(SortOrder.yearDesc);
      expect(cubit.state.cars.first.year, 2024);
    });

    test('FavoritesCubit persists favorites', () async {
      final storage = await _storage();
      final repo = MockCarRepository(storage, delay: Duration.zero);
      final car = MockCarRepository.cars.first;

      final cubit = FavoritesCubit(repo);
      await cubit.toggle(car);
      expect(cubit.state, {car.id});
      expect(storage.favorites, [car.id]);

      final reloaded = FavoritesCubit(repo);
      await reloaded.load();
      expect(reloaded.state, {car.id});

      await reloaded.toggle(car);
      expect(reloaded.state, isEmpty);
    });

    test('CompareCubit holds at most three cars', () {
      final cubit = CompareCubit();
      final cars = MockCarRepository.cars;
      expect(cubit.toggle(cars[0]), CompareResult.added);
      expect(cubit.toggle(cars[1]), CompareResult.added);
      expect(cubit.toggle(cars[2]), CompareResult.added);
      expect(cubit.toggle(cars[3]), CompareResult.full);
      expect(cubit.toggle(cars[0]), CompareResult.removed);
      expect(cubit.state, hasLength(2));
    });

    test('TestDriveCubit saves and cancels requests', () async {
      final repo = MockCarRepository(await _storage(), delay: Duration.zero);
      final cubit = TestDriveCubit(repo);
      await cubit.request(
        car: MockCarRepository.cars.first,
        name: 'Bekzod',
        phone: '+998901234567',
        date: DateTime(2030, 5, 1, 11),
      );
      expect((await repo.getTestDrives()).single.name, 'Bekzod');

      await cubit.cancel(cubit.state.single.id);
      expect(await repo.getTestDrives(), isEmpty);
    });

    test('ThemeCubit is dark by default and remembers the choice', () async {
      final storage = await _storage();
      final cubit = ThemeCubit(storage);
      expect(cubit.state, ThemeMode.dark);
      await cubit.setDark(false);
      expect(ThemeCubit(storage).state, ThemeMode.light);
    });

    test('AuthCubit goes onboarding -> signed out -> signed in', () async {
      final storage = await _storage();
      final cubit = AuthCubit(AuthRepository(storage, delay: Duration.zero));
      expect(cubit.state.status, AuthStatus.onboarding);

      await cubit.finishOnboarding();
      expect(cubit.state.status, AuthStatus.signedOut);

      await cubit.signIn('bekzod@example.com');
      expect(cubit.state.status, AuthStatus.signedIn);
      expect(cubit.state.user, 'bekzod');

      await cubit.signOut();
      expect(AuthCubit(AuthRepository(storage)).state.status,
          AuthStatus.signedOut);
    });
  });

  group('App', () {
    testWidgets('onboarding, sign in and home list', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await setupDependencies(fast: true);
      await tester.pumpWidget(const AutoSalonApp());
      await tester.pumpAndSettle();

      expect(find.text('Find your next car'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a valid email'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'bekzod@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), 'secret123');
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(find.text('Find your dream car'), findsOneWidget);
      expect(find.text('Featured'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('All cars'), 200,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('All cars'), findsOneWidget);
    });

    testWidgets('signed-in user lands on home and can open a car',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'onboarding_seen': true,
        'logged_in_user': 'bekzod',
      });
      await setupDependencies(fast: true);
      await tester.pumpWidget(const AutoSalonApp());
      await tester.pumpAndSettle();

      final firstCar = find.text('Mercedes-AMG GT').last;
      await tester.ensureVisible(firstCar);
      await tester.pumpAndSettle();
      await tester.tap(firstCar);
      await tester.pumpAndSettle();

      expect(find.text('Specifications'), findsOneWidget);
      expect(find.text('Book a test drive'), findsOneWidget);
    });
  });
}
