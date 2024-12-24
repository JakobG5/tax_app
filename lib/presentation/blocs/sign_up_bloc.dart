import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/route/main_route.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/pages/componyProfile/create_compony_data.dart'; // Import the company profile creation page
import 'package:tax_app/core/di/injection_container.dart'; // Import the injection container

// Events
abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;
  final BuildContext context; // Add BuildContext

  SignUpSubmitted({
    required this.email,
    required this.password,
    required this.context,
  });
}

// States
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserLocalStorage userStorage;

  SignUpBloc({required this.userStorage}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      print('Attempting to sign up with email: ${event.email}');
      emit(SignUpLoading());
      final isEmailTaken = await userStorage.isEmailTaken(event.email);
      if (isEmailTaken) {
        emit(SignUpFailure('Email is already taken'));
      } else {
        await userStorage.saveUserCredentials(event.email, event.password);
        final companyData = await userStorage.getCompanyData(event.email);
        print('Company data for ${event.email}: $companyData');
        if (companyData.isEmpty) {
          // Navigate to company profile creation page
          print('Navigating to company profile creation page');
          emit(SignUpSuccess());
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(builder: (context) => const ComponyProfile()),
          );
        } else {
          print('Navigating to main route');
          emit(SignUpSuccess());
          // await userStorage.put('isSignedIn', true); // Set the isSignedIn flag
          Navigator.pushReplacement(
            event.context,
            MaterialPageRoute(builder: (context) => const MainRoute()),
          );
        }
      }
    } catch (e) {
      print('Sign-up error: $e');
      emit(SignUpFailure(e.toString()));
    }
  }
}
