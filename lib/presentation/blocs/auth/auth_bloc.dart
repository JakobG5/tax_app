import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

// Events
abstract class AuthEvent {}

abstract class AuthState {}

class CheckAuthStatus extends AuthEvent {}

class SignOut extends AuthEvent {}

// States

class Authenticated extends AuthState {
  final String email;

  Authenticated(this.email);
}

class Unauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLocalStorage userStorage;

  AuthBloc({required this.userStorage}) : super(Unauthenticated()) {
    on<CheckAuthStatus>((event, emit) async {
      final isSignedIn =
          await userStorage.isSignedIn(); // Check the actual status
      if (isSignedIn) {
        final credentials = await userStorage.getUserCredentials();
        emit(Authenticated(credentials!['email']));
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignOut>((event, emit) async {
      await userStorage.signOut();
      emit(Unauthenticated());
    });
  }
}
