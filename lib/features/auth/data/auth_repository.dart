import '../../../core/storage/local_storage.dart';

/// Mock authentication: no server, any valid form signs in. Only the display
/// name is kept on the device, passwords are never stored.
class AuthRepository {
  AuthRepository(this._storage, {this.delay = const Duration(milliseconds: 700)});

  final LocalStorage _storage;
  final Duration delay;

  bool get onboardingSeen => _storage.onboardingSeen;
  Future<void> completeOnboarding() => _storage.setOnboardingSeen();

  String? get currentUser => _storage.loggedInUser;

  Future<String> signIn({required String email}) async {
    await Future<void>.delayed(delay);
    final name = email.split('@').first;
    await _storage.setLoggedInUser(name);
    return name;
  }

  Future<String> register({required String name}) async {
    await Future<void>.delayed(delay);
    await _storage.setLoggedInUser(name);
    return name;
  }

  Future<void> signOut() => _storage.setLoggedInUser(null);
}
