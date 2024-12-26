import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/blocs/addEmployeeBloc.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';
import 'package:tax_app/core/utils/validation.dart';

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
  final List<String> genderOptions = ['Male', 'Female'];
  String selectedGender = 'Male'; // Default value

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
      try {
        final currentEmail =
            await context.read<UserLocalStorage>().getCurrentEmail();
        if (currentEmail == null) {
          throw 'User not logged in';
        }

        print('Validating form data...'); // Debug print

        // Validate and convert numeric values
        final grossSalary = double.tryParse(_grossSalaryController.text);
        if (grossSalary == null) {
          throw 'Invalid gross salary format';
        }

        final taxableEarning = double.tryParse(_taxableEarningController.text);
        if (taxableEarning == null) {
          throw 'Invalid taxable earning format';
        }

        if (taxableEarning > grossSalary) {
          throw 'Taxable earning cannot be greater than gross salary';
        }

        print('All validations passed, preparing data...'); // Debug print

        final employeeData = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'employeeName': _employeeNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'tinNumber': _tinNumberController.text.trim(),
          'grossSalary': grossSalary,
          'taxableEarning': taxableEarning,
          'startingDateOfSalary': _startingDateOfSalaryController.text,
          'gender': selectedGender,
          'createdBy': currentEmail,
          'createdAt': DateTime.now().toIso8601String(),
        };

        print('Employee data prepared: $employeeData'); // Debug print
        context.read<EmployeeAddBloc>().addEmployee(employeeData);
      } catch (e) {
        print('Error in form submission: $e'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('Form validation failed'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
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
    return BlocListener<EmployeeAddBloc, EmployeeAddState>(
      listener: (context, state) {
        if (state is EmployeeAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee added successfully')),
          );
          Navigator.pop(context);
        } else if (state is EmployeeAddError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                          validator: Validation.validateName,
                        ),
                        const SizedBox(height: 18),
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          hint: DemozTex.emailA,
                          validator: Validation.validateEmail,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        // Phone Number
                        CustomTextField(
                          controller: _phoneController,
                          hint: DemozTex.phoneNumber,
                          validator: Validation.validatePhone,
                          inputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 18),
                        // TIN Number
                        CustomTextField(
                          controller: _tinNumberController,
                          hint: 'TIN Number',
                          validator: (value) =>
                              Validation.validateRequired(value, 'TIN Number'),
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 18),
                        // Gross Salary
                        CustomTextField(
                          controller: _grossSalaryController,
                          hint: 'Gross Salary',
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Gross salary is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Gross salary must be greater than 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        // Taxable Earning
                        CustomTextField(
                          controller: _taxableEarningController,
                          hint: 'Taxable Earning',
                          inputType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Taxable earning is required';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            final taxableEarning = double.parse(value);
                            final grossSalary =
                                double.tryParse(_grossSalaryController.text) ??
                                    0;
                            if (taxableEarning > grossSalary) {
                              return 'Taxable earning cannot be greater than gross salary';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Starting Date of Salary
                        GestureDetector(
                          onTap: () => _selectStartingDate(context),
                          child: AbsorbPointer(
                            child: CustomTextField(
                              controller: _startingDateOfSalaryController,
                              hint: 'Starting Date of Salary',
                              validator: (value) => Validation.validateRequired(
                                  value, 'Starting date'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: genderOptions.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select gender' : null,
                        ),
                        const SizedBox(height: 18),
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
      ),
    );
  }
}
