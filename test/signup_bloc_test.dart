import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:tax_app/presentation/blocs/sign_up_bloc.dart';

class MockUserLocalStorage extends Mock implements UserLocalStorage {}
class MockAuthBloc extends Mock implements AuthBloc {}
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late SignUpBloc signUpBloc;
  late MockUserLocalStorage mockUserStorage;
  late MockAuthBloc mockAuthBloc;
  late MockBuildContext mockContext;

  setUp(() {
    mockUserStorage = MockUserLocalStorage();
    mockAuthBloc = MockAuthBloc();
    mockContext = MockBuildContext();
    signUpBloc = SignUpBloc(
      userStorage: mockUserStorage,
      authBloc: mockAuthBloc,
    );
  });

  tearDown(() {
    signUpBloc.close();
  });

  group('SignUpBloc', () {
    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpSuccess] when SignUpSubmitted is successful',
      build: () {
        when(() => mockUserStorage.isEmailTaken(any()))
            .thenAnswer((_) async => false);
        when(() => mockUserStorage.saveUserCredentials(any(), any()))
            .thenAnswer((_) async {});
        when(() => mockUserStorage.setIsSignedIn(any()))
            .thenAnswer((_) async {});
        when(() => mockUserStorage.saveCurrentEmail(any()))
            .thenAnswer((_) async {});
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        email: 'test@example.com',
        password: 'password123',
        context: mockContext,
      )),
      expect: () => [
        SignUpLoading(),
        SignUpSuccess(),
      ],
    );

    blocTest<SignUpBloc, SignUpState>(
      'emits [SignUpLoading, SignUpFailure] when email is already taken',
      build: () {
        when(() => mockUserStorage.isEmailTaken(any()))
            .thenAnswer((_) async => true);
        return signUpBloc;
      },
      act: (bloc) => bloc.add(SignUpSubmitted(
        email: 'test@example.com',
        password: 'password123',
        context: mockContext,
      )),
      expect: () => [
        SignUpLoading(),
        SignUpFailure('Email is already taken'),
      ],
    );
  });
} 