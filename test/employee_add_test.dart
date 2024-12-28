import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/addEmployeeBloc.dart';

class MockUserLocalStorage extends Mock implements UserLocalStorage {}

void main() {
  late EmployeeAddBloc employeeAddBloc;
  late MockUserLocalStorage mockUserStorage;

  setUp(() {
    mockUserStorage = MockUserLocalStorage();
    employeeAddBloc = EmployeeAddBloc(userLocalStorage: mockUserStorage);
  });

  tearDown(() {
    employeeAddBloc.close();
  });

  group('EmployeeAddBloc', () {
    final mockEmployeeData = {
      'name': 'John Doe',
      'salary': 5000,
      'position': 'Developer'
    };

    blocTest<EmployeeAddBloc, EmployeeAddState>(
      'emits [EmployeeAddLoading, EmployeeAddSuccess] when AddEmployee is successful',
      build: () {
        when(() => mockUserStorage.saveEmployeeData(any()))
            .thenAnswer((_) async {});
        return employeeAddBloc;
      },
      act: (bloc) => bloc.add(AddEmployee(mockEmployeeData)),
      expect: () => [
        isA<EmployeeAddLoading>(),
        isA<EmployeeAddSuccess>(),
      ],
    );

    blocTest<EmployeeAddBloc, EmployeeAddState>(
      'emits [EmployeeAddLoading, EmployeeAddError] when AddEmployee fails',
      build: () {
        when(() => mockUserStorage.saveEmployeeData(any()))
            .thenThrow(Exception('Failed to save employee'));
        return employeeAddBloc;
      },
      act: (bloc) => bloc.add(AddEmployee(mockEmployeeData)),
      expect: () => [
        isA<EmployeeAddLoading>(),
        isA<EmployeeAddError>(),
      ],
    );
  });
} 
