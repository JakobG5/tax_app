import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/presentation/blocs/addEmployeeBloc.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';

class EmployeeAdd extends StatefulWidget {
  const EmployeeAdd({super.key});

  @override
  _EmployeeAddState createState() => _EmployeeAddState();
}

class _EmployeeAddState extends State<EmployeeAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tinNumberController = TextEditingController();
  final TextEditingController _grossSalaryController = TextEditingController();
  final TextEditingController _taxableEarningController =
      TextEditingController();
  final TextEditingController _startingDateOfSalaryController =
      TextEditingController();

  @override
  void dispose() {
    _employeeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _tinNumberController.dispose();
    _grossSalaryController.dispose();
    _taxableEarningController.dispose();
    _startingDateOfSalaryController.dispose();
    super.dispose();
  }

  void _saveEmployee() async {
    if (_formKey.currentState?.validate() ?? false) {
      final employeeData = {
        'employeeName': _employeeNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'tinNumber': _tinNumberController.text,
        'grossSalary': _grossSalaryController.text,
        'taxableEarning': _taxableEarningController.text,
        'startingDateOfSalary': _startingDateOfSalaryController.text,
      };

      BlocProvider.of<EmployeeAddBloc>(context).addEmployee(employeeData);
    }
  }

  Future<void> _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _startingDateOfSalaryController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: DemozHelper.getHeight(context) + 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.navigate_before_sharp,
                              size: 30,
                            ),
                          ),
                          Text(
                            DemozTex.addEmp,
                            style: DemozTH.pop.copyWith(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Employee Name
                      CustomTextField(
                        controller: _employeeNameController,
                        hint: DemozTex.emName,
                      ),
                      const SizedBox(height: 18),
                      // Email
                      CustomTextField(
                        controller: _emailController,
                        hint: DemozTex.emailA,
                      ),
                      const SizedBox(height: 18),
                      // Phone Number
                      CustomTextField(
                        controller: _phoneController,
                        hint: DemozTex.phoneNumber,
                      ),
                      const SizedBox(height: 18),
                      // TIN Number
                      CustomTextField(
                        controller: _tinNumberController,
                        hint: 'TIN Number',
                      ),
                      const SizedBox(height: 18),
                      // Gross Salary
                      CustomTextField(
                        controller: _grossSalaryController,
                        hint: 'Gross Salary',
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 18),
                      // Taxable Earning
                      CustomTextField(
                        controller: _taxableEarningController,
                        hint: 'Taxable Earning',
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      // Starting Date of Salary
                      GestureDetector(
                        onTap: () => _selectStartingDate(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _startingDateOfSalaryController,
                            hint: 'Starting Date of Salary',
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: button(
                          DemozTex.addEmp,
                          _saveEmployee,
                          false,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
