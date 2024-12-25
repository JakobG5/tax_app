import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';

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
  final AuthBloc authBloc;

  SignUpBloc({required this.userStorage, required this.authBloc})
      : super(SignUpInitial()) {
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
        await userStorage.setIsSignedIn(true); // Mark as signed in

        // Save the current email
        await userStorage.saveCurrentEmail(event.email);

        print('Sign up success with email: ${event.email}');
        emit(SignUpSuccess());

        // Trigger AuthBloc to rebuild
        authBloc.add(CheckAuthStatus());
      }
    } catch (e) {
      print('Sign-up error: $e');
      emit(SignUpFailure(e.toString()));
    }
  }
}
