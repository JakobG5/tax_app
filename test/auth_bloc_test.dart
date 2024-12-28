import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';

class MockUserLocalStorage extends Mock implements UserLocalStorage {}

void main() {
  late AuthBloc authBloc;
  late MockUserLocalStorage mockUserStorage;

  setUp(() {
    mockUserStorage = MockUserLocalStorage();
    authBloc = AuthBloc(userStorage: mockUserStorage);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [Authenticated] when CheckAuthStatus is added and user is signed in',
      build: () {
        when(() => mockUserStorage.isSignedIn()).thenAnswer((_) async => true);
        when(() => mockUserStorage.getUserCredentials())
            .thenAnswer((_) async => {'email': 'test@example.com'});
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [Authenticated('test@example.com')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] when SignOut is added',
      build: () {
        when(() => mockUserStorage.signOut()).thenAnswer((_) async {});
        when(() => mockUserStorage.saveCurrentEmail(any()))
            .thenAnswer((_) async {});
        when(() => mockUserStorage.setIsSignedIn(any())).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(SignOut()),
      expect: () => [Unauthenticated()],
    );
  });
} 