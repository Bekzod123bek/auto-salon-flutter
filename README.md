# Auto Salon

A personal demo project: a car dealership app for Android and iOS built with
Flutter.

> **Note:** this is a portfolio/demo project, not a production app. All cars,
> prices and specs are sample data from an in-memory repository, there is no
> backend and sign-in is simulated (no account is created, passwords are not
> stored). Photos are illustrative and may not show the exact listed model.

## Features

- **Onboarding** (3 slides, shown on first launch only)
- **Sign in / register** screen with form validation (mock)
- **Home**: featured cars carousel, brand row, search, sort
  (recommended, price, year, mileage)
- **Advanced filters** in a bottom sheet: price range, year range, max
  mileage, fuel, transmission, body type
- **Car details**: Hero animation, photo gallery with page indicator, specs
  grid (engine, power, 0–100, fuel, gearbox, drive...), features list
- **Loan calculator**: down payment, interest rate and term → monthly payment
- **Compare** up to 3 cars side by side, best values highlighted
- **Test drive booking** with date and time pickers and a validated form
- **Favorites** and **test drive requests** saved on the device
- **Profile**: requests list, dark / light mode switch, log out
- Shimmer loading, empty states, snackbars, dark theme by default

## Stack

- Flutter / Dart, Material 3
- `flutter_bloc` (Cubit) for state management
- `get_it` for dependency injection
- `shared_preferences` for local storage
- `cached_network_image` + `shimmer` for photos and loading states
- Clean Architecture split: `domain`, `data`, `presentation`

## Structure

```
lib/
  main.dart                app, theme, auth routing
  injection.dart           get_it setup
  core/                    theme, storage, formatters, loan calculator, shared widgets
  features/
    auth/                  onboarding, login, AuthCubit (mock)
    cars/
      domain/              entities, filters, repository contract
      data/                mock repository (sample cars, local storage)
      presentation/        cubits, pages, widgets
    shell/                 bottom navigation
```

## Run

```bash
flutter pub get
flutter run
flutter test
```

The app needs an internet connection to load photos.

## Credits

Photos: [Unsplash](https://unsplash.com) (Unsplash License).
