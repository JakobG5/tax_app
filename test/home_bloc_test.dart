import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/home/home_bloc.dart';

class MockUserLocalStorage extends Mock implements UserLocalStorage {}

void main() {
  late HomeBloc homeBloc;
  late MockUserLocalStorage mockUserStorage;

  setUp(() {
    mockUserStorage = MockUserLocalStorage();
    homeBloc = HomeBloc(userLocalStorage: mockUserStorage);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
    final mockEmployees = [
      {
        'createdBy': 'test@example.com',
        'grossSalary': 5000.0,
        'taxableEarning': 4000.0,
        'gender': 'Male'
      }
    ];

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] when LoadHomeData is added successfully',
      build: () {
        when(() => mockUserStorage.getCurrentEmail())
            .thenAnswer((_) async => 'test@example.com');
        when(() => mockUserStorage.getAllEmployeeData())
            .thenAnswer((_) async => mockEmployees);
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadHomeData()),
      expect: () => [
        HomeLoading(),
        isA<HomeLoaded>(),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when getCurrentEmail returns null',
      build: () {
        when(() => mockUserStorage.getCurrentEmail())
            .thenAnswer((_) async => null);
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadHomeData()),
      expect: () => [
        HomeLoading(),
        const HomeError('User not found'),
      ],
    );
  });
} 