import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

class EmployeeListBloc extends Cubit<EmployeeListState> {
  final UserLocalStorage userLocalStorage;

  EmployeeListBloc({required this.userLocalStorage}) : super(EmployeeListInitial());

  Future<void> loadEmployees() async {
    try {
      emit(EmployeeListLoading());
      
      // Get current user's email
      final currentEmail = await userLocalStorage.getCurrentEmail();
      if (currentEmail == null) {
        emit(EmployeeListError(message: 'User not logged in'));
        return;
      }

      // Get all employees and filter by creator
      final allEmployees = await userLocalStorage.getAllEmployeeData();
      final userEmployees = allEmployees.where((employee) => 
        employee['createdBy'] == currentEmail
      ).toList();

      emit(EmployeeListLoaded(userEmployees));
    } catch (e) {
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