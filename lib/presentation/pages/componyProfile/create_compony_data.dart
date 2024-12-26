import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/core/route/main_route.dart';
import 'package:tax_app/presentation/blocs/company/company_bloc.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';
import 'package:tax_app/core/utils/validation.dart';

class CreateCompanyProfile extends HookWidget {
  const CreateCompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final phoneController = useTextEditingController();
    final tinController = useTextEditingController();
    final employeesController = useTextEditingController();
    final bankController = useTextEditingController();
    final accountController = useTextEditingController();
    final email = useState<String?>(null);

    // Fetch the email from local storage
    useEffect(() {
      Future.microtask(() async {
        final fetchedEmail = await sl<UserLocalStorage>().getCurrentEmail();
        if (fetchedEmail == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No email found. Please log in again.')),
          );
        }
        email.value = fetchedEmail;
      });
      return null;
    }, []);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: BlocProvider(
              create: (context) =>
                  CompanyBloc(userStorage: sl<UserLocalStorage>()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.navigate_before_sharp, size: 30),
                  ),
                  const SizedBox(height: 18),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: DemozTex.register, style: DemozTH.header4),
                        TextSpan(
                          text: DemozTex.demozPay,
                          style: DemozTH.header4
                              .copyWith(color: DemozColors.primaryBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Company Name',
                          controller: nameController,
                          validator: Validation.validateName,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Address of Company',
                          controller: addressController,
                          validator: (value) => Validation.validateRequired(
                              value, 'Address of Company'),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Phone Number',
                          controller: phoneController,
                          validator: Validation.validatePhone,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'TIN Number',
                          controller: tinController,
                          validator: (value) =>
                              Validation.validateRequired(value, 'TIN Number'),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Number of Employees',
                          controller: employeesController,
                          validator: (value) => Validation.validateRequired(
                              value, 'Number of Employees'),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Company Bank',
                          controller: bankController,
                          validator: (value) => Validation.validateRequired(
                              value, 'Company Bank'),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hint: 'Bank Account Number',
                          controller: accountController,
                          validator: (value) => Validation.validateRequired(
                              value, 'Bank Account Number'),
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<CompanyBloc, CompanyState>(
                          listener: (context, state) {
                            if (state is CompanySubmitted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Company profile created successfully.')),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainRoute()),
                              );
                            } else if (state is CompanyError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
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
                              child: button(
                                DemozTex.submit,
                                () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<CompanyBloc>().add(
                                          SubmitCompanyData({
                                            'componyName':
                                                nameController.text.trim(),
                                            'addressOfCompony':
                                                addressController.text.trim(),
                                            'phoneNumber':
                                                phoneController.text.trim(),
                                            'tinNumber':
                                                tinController.text.trim(),
                                            'numberOfEmployees':
                                                employeesController.text.trim(),
                                            'componyBank':
                                                bankController.text.trim(),
                                            'bankAccountNumber':
                                                accountController.text.trim(),
                                            'createdBy': email.value,
                                          }),
                                        );
                                  }
                                },
                                true,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}