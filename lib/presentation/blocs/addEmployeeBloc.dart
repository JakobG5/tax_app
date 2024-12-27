import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

/// Bloc for adding employees
class EmployeeAddBloc extends Bloc<EmployeeAddEvent, EmployeeAddState> {
  final UserLocalStorage userLocalStorage;

  EmployeeAddBloc({required this.userLocalStorage})
      : super(EmployeeAddInitial()) {
    // Registering the event handler
    on<AddEmployee>(_onAddEmployee);
  }

  /// Handles the AddEmployee event
  Future<void> _onAddEmployee(
      AddEmployee event, Emitter<EmployeeAddState> emit) async {
    try {
      emit(EmployeeAddLoading());
      await userLocalStorage.saveEmployeeData(event.employeeData);
      emit(EmployeeAddSuccess());
    } catch (e) {
      emit(EmployeeAddError(message: e.toString()));
    }
  }
}

/// States for the EmployeeAddBloc
abstract class EmployeeAddState {}

class EmployeeAddInitial extends EmployeeAddState {}

class EmployeeAddLoading extends EmployeeAddState {}

class EmployeeAddSuccess extends EmployeeAddState {}

class EmployeeAddError extends EmployeeAddState {
  final String message;
  EmployeeAddError({required this.message});
}

/// Events for the EmployeeAddBloc
abstract class EmployeeAddEvent {}

class AddEmployee extends EmployeeAddEvent {
  final Map<String, dynamic> employeeData;
  AddEmployee(this.employeeData);
}
