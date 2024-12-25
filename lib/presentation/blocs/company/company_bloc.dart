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
    // Submit Company Data Event
    on<SubmitCompanyData>((event, emit) async {
      emit(CompanySubmitting());
      try {
        // Check if company already exists for the provided email
        final existingCompanies = await userStorage.getCompanyData(event.companyData['createdBy']);
        if (existingCompanies.isNotEmpty) {
          emit(CompanyError('Company profile already exists for this email.'));
          return;
        }

        // Save new company data
        await userStorage.saveCompanyData(event.companyData);
        emit(CompanySubmitted());

        // Fetch all saved companies and print them
        final allCompanies = await userStorage.getAllCompanyData();
        print("All saved companies:");
        for (var company in allCompanies) {
          print(company);
        }
      } catch (e) {
        emit(CompanyError(e.toString()));
      }
    });

    // Fetch Company Data Event
    on<FetchCompanyData>((event, emit) async {
      emit(CompanyLoading());
      try {
        final companyData = await userStorage.getCompanyData(event.email);
        if (companyData.isNotEmpty) {
          emit(CompanyLoaded(companyData.first));
        } else {
          emit(CompanyError('No company data found.'));
        }
      } catch (e) {
        emit(CompanyError(e.toString()));
      }
    });
  }
}
