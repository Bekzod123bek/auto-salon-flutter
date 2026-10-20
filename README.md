# Auto Salon

A personal demo project: a mobile car dealership app built with Flutter.

Browse cars, filter by brand, sort by price or year, mark favorites and send a
test drive request from the car page.

> **Note:** this is a portfolio/demo project, not a production app. The car
> list comes from an in-memory mock repository, there is no backend.

## Stack

- Flutter / Dart
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart
  injection.dart
  features/cars/
    domain/        entities and repository contract
    data/          mock repository
    presentation/  cubit and pages
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

## Possible next steps

- Replace the mock repository with a REST API (`dio`)
- Car photos and a gallery
- Price range filter and search
