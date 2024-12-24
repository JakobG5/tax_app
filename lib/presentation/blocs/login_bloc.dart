import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/route/main_route.dart';
import '../../data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/pages/componyProfile/create_compony_data.dart'; // Import the company profile creation page
import 'package:tax_app/core/di/injection_container.dart'; // Import the injection container

// Events
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context; // Add BuildContext

  LoginSubmitted({
    required this.email,
    required this.password,
    required this.context,
  });
}

// States
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

  LoginBloc({required this.userStorage}) : super(LoginInitial()) {
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
        final companyData = await userStorage.getCompanyData(event.email);
        print('Company data for ${event.email}: $companyData');
        if (companyData.isEmpty) {
          // Navigate to company profile creation page
          emit(LoginSuccess());
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(builder: (context) => const ComponyProfile()),
          );
        } else {
          emit(LoginSuccess());
          // await userStorage.put('isSignedIn', true); // Set the isSignedIn flag
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(builder: (context) => const MainRoute()),
          );
        }
      } else {
        emit(LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      print('Login error: $e');
      emit(LoginFailure(e.toString()));
    }
  }
}
