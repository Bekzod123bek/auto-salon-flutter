import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';

enum AuthStatus { onboarding, signedOut, signedIn }

class AuthState extends Equatable {
  const AuthState({required this.status, this.user, this.busy = false});

  final AuthStatus status;
  final String? user;
  final bool busy;

  @override
  List<Object?> get props => [status, user, busy];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(_initial(_repository));

  final AuthRepository _repository;

  static AuthState _initial(AuthRepository repo) {
    if (!repo.onboardingSeen) {
      return const AuthState(status: AuthStatus.onboarding);
    }
    final user = repo.currentUser;
    return user == null
        ? const AuthState(status: AuthStatus.signedOut)
        : AuthState(status: AuthStatus.signedIn, user: user);
  }

  Future<void> finishOnboarding() async {
    await _repository.completeOnboarding();
    emit(const AuthState(status: AuthStatus.signedOut));
  }

  Future<void> signIn(String email) async {
    emit(AuthState(status: state.status, busy: true));
    final user = await _repository.signIn(email: email);
    emit(AuthState(status: AuthStatus.signedIn, user: user));
  }

  Future<void> register(String name) async {
    emit(AuthState(status: state.status, busy: true));
    final user = await _repository.register(name: name);
    emit(AuthState(status: AuthStatus.signedIn, user: user));
  }

  Future<void> signOut() async {
    await _repository.signOut();
    emit(const AuthState(status: AuthStatus.signedOut));
  }
}
