import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';

// Events
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginSubmitted({
    required this.email,
    required this.password,
    required this.context,
  });
}

// Login States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserLocalStorage userStorage;
  final AuthBloc authBloc;

  LoginBloc({required this.userStorage, required this.authBloc})
      : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      print('Attempting to log in with email: ${event.email}');
      emit(LoginLoading());

      final users = await userStorage.getAllUsers();
      final userExists = users.any((user) =>
          user['email'] == event.email && user['password'] == event.password);

      if (userExists) {
        // Update isSignedIn in local storage
        await userStorage.setIsSignedIn(true);

        // Save the current email
        await userStorage.saveCurrentEmail(event.email);

        // Call CheckAuthStatus in AuthBloc
        authBloc.add(CheckAuthStatus());
        emit(LoginSuccess());
      } else {
        emit(LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      print('Login error: $e');
      emit(LoginFailure(e.toString()));
    }
  }
}
