import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] so features don't depend on keys.
class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingSeen = 'onboarding_seen';
  static const _loggedInUser = 'logged_in_user';
  static const _darkMode = 'dark_mode';
  static const _favorites = 'favorite_car_ids';
  static const _testDrives = 'test_drive_requests';

  bool get onboardingSeen => _prefs.getBool(_onboardingSeen) ?? false;
  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingSeen, true);

  String? get loggedInUser => _prefs.getString(_loggedInUser);
  Future<void> setLoggedInUser(String? name) => name == null
      ? _prefs.remove(_loggedInUser)
      : _prefs.setString(_loggedInUser, name);

  bool? get darkMode => _prefs.getBool(_darkMode);
  Future<void> setDarkMode(bool value) => _prefs.setBool(_darkMode, value);

  List<String> get favorites => _prefs.getStringList(_favorites) ?? const [];
  Future<void> setFavorites(List<String> ids) =>
      _prefs.setStringList(_favorites, ids);

  String? get testDrivesJson => _prefs.getString(_testDrives);
  Future<void> setTestDrivesJson(String json) =>
      _prefs.setString(_testDrives, json);
}
