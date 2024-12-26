import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class ToggleTimeFilter extends HomeEvent {
  final bool isUpcoming;

  const ToggleTimeFilter(this.isUpcoming);

  @override
  List<Object> get props => [isUpcoming];
}

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final int employeeCount;
  final double incomeTaxPaid;
  final double pensionTaxPaid;
  final int maleCount;
  final int femaleCount;
  final bool isUpcoming;
  final DateTime nextPaymentStartDate;
  final DateTime nextPaymentEndDate;
  final double upcomingIncomeTax;
  final double upcomingPensionTax;

  const HomeLoaded({
    required this.employeeCount,
    required this.incomeTaxPaid,
    required this.pensionTaxPaid,
    required this.maleCount,
    required this.femaleCount,
    required this.isUpcoming,
    required this.nextPaymentStartDate,
    required this.nextPaymentEndDate,
    required this.upcomingIncomeTax,
    required this.upcomingPensionTax,
  });

  HomeLoaded copyWith({
    int? employeeCount,
    double? incomeTaxPaid,
    double? pensionTaxPaid,
    int? maleCount,
    int? femaleCount,
    bool? isUpcoming,
    DateTime? nextPaymentStartDate,
    DateTime? nextPaymentEndDate,
    double? upcomingIncomeTax,
    double? upcomingPensionTax,
  }) {
    return HomeLoaded(
      employeeCount: employeeCount ?? this.employeeCount,
      incomeTaxPaid: incomeTaxPaid ?? this.incomeTaxPaid,
      pensionTaxPaid: pensionTaxPaid ?? this.pensionTaxPaid,
      maleCount: maleCount ?? this.maleCount,
      femaleCount: femaleCount ?? this.femaleCount,
      isUpcoming: isUpcoming ?? this.isUpcoming,
      nextPaymentStartDate: nextPaymentStartDate ?? this.nextPaymentStartDate,
      nextPaymentEndDate: nextPaymentEndDate ?? this.nextPaymentEndDate,
      upcomingIncomeTax: upcomingIncomeTax ?? this.upcomingIncomeTax,
      upcomingPensionTax: upcomingPensionTax ?? this.upcomingPensionTax,
    );
  }

  @override
  List<Object> get props => [
        employeeCount,
        incomeTaxPaid,
        pensionTaxPaid,
        maleCount,
        femaleCount,
        isUpcoming,
        nextPaymentStartDate,
        nextPaymentEndDate,
        upcomingIncomeTax,
        upcomingPensionTax,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserLocalStorage userLocalStorage;

  HomeBloc({required this.userLocalStorage}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<ToggleTimeFilter>(_onToggleTimeFilter);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final currentEmail = await userLocalStorage.getCurrentEmail();
      if (currentEmail == null) {
        emit(const HomeError('User not found'));
        return;
      }

      final employees = await userLocalStorage.getAllEmployeeData();
      final userEmployees =
          employees.where((emp) => emp['createdBy'] == currentEmail).toList();

      // Calculate totals
      int totalEmployees = userEmployees.length;
      double totalIncomeTax = 0;
      double totalPensionTax = 0;
      int maleCount = 0;
      int femaleCount = 0;

      // Calculate upcoming tax amounts
      for (var employee in userEmployees) {
        final grossSalary = (employee['grossSalary'] ?? 0).toDouble();
        final taxableEarning = (employee['taxableEarning'] ?? 0).toDouble();

        // Calculate income tax (this is a simplified example)
        final incomeTax = taxableEarning * 0.15; // 15% tax rate
        final pensionTax = grossSalary * 0.07; // 7% pension rate

        totalIncomeTax += incomeTax;
        totalPensionTax += pensionTax;

        if (employee['gender'] == 'Male') maleCount++;
        if (employee['gender'] == 'Female') femaleCount++;
      }

      // Calculate next payment period
      final now = DateTime.now();
      final nextMonth = DateTime(now.year, now.month + 1);
      final startDate = DateTime(nextMonth.year, nextMonth.month, 28);
      final endDate = DateTime(nextMonth.year, nextMonth.month, 5);

      emit(HomeLoaded(
        employeeCount: totalEmployees,
        incomeTaxPaid: totalIncomeTax,
        pensionTaxPaid: totalPensionTax,
        maleCount: maleCount,
        femaleCount: femaleCount,
        isUpcoming: true,
        nextPaymentStartDate: startDate,
        nextPaymentEndDate: endDate,
        upcomingIncomeTax: totalIncomeTax,
        upcomingPensionTax: totalPensionTax,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onToggleTimeFilter(ToggleTimeFilter event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(isUpcoming: event.isUpcoming));
    }
  }
}
