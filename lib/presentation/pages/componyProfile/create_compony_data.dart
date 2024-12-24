import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/core/route/main_route.dart'; // Import the main route
import 'package:tax_app/presentation/blocs/company/company_bloc.dart';

class ComponyProfile extends StatelessWidget {
  const ComponyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final tinController = TextEditingController();
    final employeesController = TextEditingController();
    final bankController = TextEditingController();
    final accountController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: DemozHelper.getHeight(context),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: DemozColors.white,
            ),
            child: SafeArea(
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    final email = state.email;
                    return BlocProvider(
                      create: (context) =>
                          CompanyBloc(userStorage: sl<UserLocalStorage>()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.navigate_before_sharp,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: DemozTex.register,
                                    style: DemozTH.header4,
                                  ),
                                  TextSpan(
                                    text: DemozTex.demozPay,
                                    style: DemozTH.header4.copyWith(
                                        color: DemozColors.primaryBlue),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DemozTex.registerUr,
                              style: DemozTH.body2Regular
                                  .copyWith(color: DemozColors.grey),
                            ),
                            const SizedBox(height: 18),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hint: DemozTex.comName,
                                    controller: nameController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.comAdd,
                                    controller: addressController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.phoneNumber,
                                    controller: phoneController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.comTN,
                                    controller: tinController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.comNofE,
                                    controller: employeesController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.comBank,
                                    controller: bankController,
                                  ),
                                  const SizedBox(height: 18),
                                  CustomTextField(
                                    hint: DemozTex.comBAcc,
                                    controller: accountController,
                                  ),
                                  const SizedBox(height: 18),
                                  BlocConsumer<CompanyBloc, CompanyState>(
                                    listener: (context, state) {
                                      if (state is CompanySubmitted) {
                                        print(
                                            'Company profile created successfully');
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainRoute()),
                                        );
                                      } else if (state is CompanyError) {
                                        print(
                                            'Company profile creation error: ${state.message}');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state.message)),
                                        );
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is CompanySubmitting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return SizedBox(
                                        width: double.infinity,
                                        child:
                                            button(DemozTex.submit, () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            final companyData = {
                                              'name': nameController.text,
                                              'address': addressController.text,
                                              'phone': phoneController.text,
                                              'tin': tinController.text,
                                              'employees':
                                                  employeesController.text,
                                              'bank': bankController.text,
                                              'account': accountController.text,
                                              'createdBy': email,
                                            };
                                            print(
                                                'Attempting to create company profile with data: $companyData');
                                            context.read<CompanyBloc>().add(
                                                SubmitCompanyData(companyData));
                                          }
                                        }, true),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
