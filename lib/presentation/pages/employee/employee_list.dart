import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/blocs/addEmployeeBloc.dart';
import 'package:tax_app/presentation/pages/employee/add_employee.dart';
import 'package:tax_app/presentation/blocs/employee_list_bloc.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeeListBloc>()..loadEmployees(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DemozTex.emp,
                          style: DemozTH.header4.copyWith(fontSize: 24),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.file_upload_outlined),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(DemozTex.uploadCSV),
                            ),
                          ],
                        )
                      ],
                    ),
                    addEmployee(context),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<EmployeeListBloc, EmployeeListState>(
                    builder: (context, state) {
                      if (state is EmployeeListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is EmployeeListLoaded) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Phone')),
                                DataColumn(label: Text('TIN')),
                                DataColumn(label: Text('Gross Salary')),
                                DataColumn(label: Text('Taxable Earning')),
                                DataColumn(label: Text('Start Date')),
                                DataColumn(label: Text('Gender')),
                              ],
                              rows: state.employees.map((employee) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                        Text(employee['employeeName'] ?? '')),
                                    DataCell(Text(employee['email'] ?? '')),
                                    DataCell(
                                        Text(employee['phoneNumber'] ?? '')),
                                    DataCell(Text(employee['tinNumber'] ?? '')),
                                    DataCell(Text(
                                        employee['grossSalary']?.toString() ??
                                            '')),
                                    DataCell(Text(employee['taxableEarning']
                                            ?.toString() ??
                                        '')),
                                    DataCell(Text(
                                        employee['startingDateOfSalary'] ??
                                            '')),
                                    DataCell(Text(employee['gender'] ?? '')),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      } else if (state is EmployeeListError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const Center(child: Text('No employees found'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget addEmployee(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<EmployeeAddBloc>(
            create: (_) => sl<EmployeeAddBloc>(),
            child: const EmployeeAdd(),
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DemozColors.lightGreen,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: DemozColors.white,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: DemozColors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            DemozTex.addEmployee,
            style: DemozTH.body2Regular
                .copyWith(color: DemozColors.white, fontSize: 16),
          )
        ],
      ),
    ),
  );
}
