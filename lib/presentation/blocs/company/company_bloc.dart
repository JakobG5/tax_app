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
        // Explicitly cast the data to Map<String, dynamic>
        final companyData = Map<String, dynamic>.from(event.companyData);
        
        // Check if company already exists for the provided email
        final existingCompanies = await userStorage.getCompanyData(companyData['createdBy']);
        if (existingCompanies.isNotEmpty) {
          emit(CompanyError('Company profile already exists for this email.'));
          return;
        }

        // Ensure all required fields are present and are strings
        final requiredFields = [
          'componyName',
          'addressOfCompony',
          'phoneNumber',
          'createdBy',
        ];

        for (final field in requiredFields) {
          if (!companyData.containsKey(field) || companyData[field] == null) {
            emit(CompanyError('Missing required field: $field'));
            return;
          }
          // Ensure the value is a string
          companyData[field] = companyData[field].toString();
        }

        // Save new company data
        await userStorage.saveCompanyData(companyData);
        emit(CompanySubmitted());

      } catch (e) {
        print('Error submitting company data: $e');
        emit(CompanyError(e.toString()));
      }
    });

    // Fetch Company Data Event
    on<FetchCompanyData>((event, emit) async {
      emit(CompanyLoading());
      try {
        print('Fetching company data for email: ${event.email}'); // Debug log
        
        final companies = await userStorage.getAllCompanyData();
        print('Retrieved ${companies.length} total companies'); // Debug log
        
        final companyData = companies.where((company) {
          final createdBy = company['createdBy']?.toString();
          return createdBy == event.email;
        }).toList();
        
        print('Found ${companyData.length} matching companies'); // Debug log

        if (companyData.isNotEmpty) {
          final data = Map<String, dynamic>.from(companyData.first);
          print('Company data found: $data'); // Debug log
          emit(CompanyLoaded(data));
        } else {
          print('No company data found for email: ${event.email}'); // Debug log
          emit(CompanyError('No company data found.'));
        }
      } catch (e) {
        print('Error fetching company data: $e');
        emit(CompanyError(e.toString()));
      }
    });
  }
}