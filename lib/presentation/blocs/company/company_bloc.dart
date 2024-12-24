import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

// Events
abstract class CompanyEvent {}

class SubmitCompanyData extends CompanyEvent {
  final Map<String, dynamic> companyData;

  SubmitCompanyData(this.companyData);
}

class FetchCompanyData extends CompanyEvent {
  final String email;

  FetchCompanyData(this.email);
}

// States
abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanySubmitting extends CompanyState {}

class CompanySubmitted extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final Map<String, dynamic> companyData;

  CompanyLoaded(this.companyData);
}

class CompanyError extends CompanyState {
  final String message;

  CompanyError(this.message);
}

// Bloc
class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final UserLocalStorage userStorage;

  CompanyBloc({required this.userStorage}) : super(CompanyInitial()) {
    on<SubmitCompanyData>((event, emit) async {
      emit(CompanySubmitting());
      try {
        await userStorage.saveCompanyData(event.companyData);
        emit(CompanySubmitted());
      } catch (e) {
        emit(CompanyError(e.toString()));
      }
    });

    on<FetchCompanyData>((event, emit) async {
      emit(CompanyLoading());
      try {
        final companyData = await userStorage.getCompanyData(event.email);
        if (companyData.isNotEmpty) {
          emit(CompanyLoaded(companyData.first));
        } else {
          emit(CompanyError('No company data found'));
        }
      } catch (e) {
        emit(CompanyError(e.toString()));
      }
    });
  }
}
