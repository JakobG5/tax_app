import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

class EmployeeListBloc extends Cubit<EmployeeListState> {
  final UserLocalStorage userLocalStorage;

  EmployeeListBloc({required this.userLocalStorage}) : super(EmployeeListInitial());

  Future<void> loadEmployees() async {
    try {
      emit(EmployeeListLoading());
      print('Loading employees from storage...'); // Debug print

      final employees = await userLocalStorage.getAllEmployeeData();
      print('Loaded ${employees.length} employees'); // Debug print
      print('Employee data: $employees'); // Debug print

      emit(EmployeeListLoaded(employees));
    } catch (e) {
      print('Error loading employees: $e'); // Debug print
      emit(EmployeeListError(message: e.toString()));
    }
  }
}

// States
abstract class EmployeeListState {}

class EmployeeListInitial extends EmployeeListState {}

class EmployeeListLoading extends EmployeeListState {}

class EmployeeListLoaded extends EmployeeListState {
  final List<Map<String, dynamic>> employees;
  EmployeeListLoaded(this.employees);
}

class EmployeeListError extends EmployeeListState {
  final String message;
  EmployeeListError({required this.message});
}