import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

class EmployeeAddBloc extends Cubit<EmployeeAddState> {
  final UserLocalStorage userLocalStorage;

  EmployeeAddBloc({required this.userLocalStorage}) : super(EmployeeAddInitial());

  Future<void> addEmployee(Map<String, dynamic> employeeData) async {
    try {
      emit(EmployeeAddLoading());
      await userLocalStorage.saveEmployeeData(employeeData); 
      emit(EmployeeAddSuccess());
    } catch (e) {
      emit(EmployeeAddError(message: e.toString()));
    }
  }
}

// EmployeeAddState class
abstract class EmployeeAddState {}

class EmployeeAddInitial extends EmployeeAddState {}

class EmployeeAddLoading extends EmployeeAddState {}

class EmployeeAddSuccess extends EmployeeAddState {}

class EmployeeAddError extends EmployeeAddState {
  final String message;
  EmployeeAddError({required this.message});
}