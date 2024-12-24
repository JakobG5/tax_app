import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/widgets/common/read_only_text_field.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:tax_app/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart'; // Import the custom button widget
import 'package:tax_app/presentation/blocs/company/company_bloc.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:image_picker/image_picker.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                final email = state.email;
                return BlocProvider(
                  create: (context) =>
                      CompanyBloc(userStorage: sl<UserLocalStorage>())
                        ..add(FetchCompanyData(email)),
                  child: BlocBuilder<CompanyBloc, CompanyState>(
                    builder: (context, state) {
                      if (state is CompanyLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CompanyLoaded) {
                        final companyData = state.companyData;
                        final nameController =
                            TextEditingController(text: companyData['name']);
                        final addressController =
                            TextEditingController(text: companyData['address']);
                        final phoneController =
                            TextEditingController(text: companyData['phone']);
                        final employeesController = TextEditingController(
                            text: companyData['employees']);
                        final imageUrl = companyData['imageUrl'];

                        return ListView(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    DemozTex.companyName,
                                    style: DemozTH.header4,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.settings,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    // Handle image selection
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: DemozColors.grey,
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl)
                                      : null,
                                  child: imageUrl == null
                                      ? const Icon(
                                          Icons.camera_alt,
                                          color: DemozColors.white,
                                          size: 40,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                companyData['name'],
                                style: DemozTH.pop.copyWith(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                DemozTex.hM,
                                style: DemozTH.pop.copyWith(
                                  color: DemozColors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(DemozTex.companyEmail),
                            const SizedBox(height: 6),
                            ReadOnlyTextField(
                              controller: TextEditingController(text: email),
                            ),
                            const SizedBox(height: 12),
                            const Text(DemozTex.phoneNumber),
                            const SizedBox(height: 6),
                            ReadOnlyTextField(
                              controller: phoneController,
                            ),
                            const SizedBox(height: 12),
                            const Text(DemozTex.comAdd),
                            const SizedBox(height: 6),
                            ReadOnlyTextField(
                              controller: addressController,
                            ),
                            const SizedBox(height: 12),
                            const Text(DemozTex.noOfEmp),
                            const SizedBox(height: 6),
                            ReadOnlyTextField(
                              controller: employeesController,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: button(
                                'Logout',
                                () {
                                  context.read<AuthBloc>().add(SignOut());
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OnboardingScreen(),
                                    ),
                                  );
                                },
                                true, // Set isActive to true
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else if (state is CompanyError) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
