import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/di/injection_container.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/presentation/pages/componyProfile/create_compony_data.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/read_only_text_field.dart';
import 'dart:io';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  String? _selectedImagePath;

  // Persistent TextEditingControllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _employeesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _employeesController.dispose();
    super.dispose();
  }

  Future<void> _loadCompanyData() async {
    final email = await context.read<AuthBloc>().userStorage.getCurrentEmail();
    print('Current Email: $email'); // Debug

    if (email != null) {
      final companyData = await sl<UserLocalStorage>().getAllCompanyData();
      print('Fetched Company Data: $companyData'); // Debug

      // Find the company data where createdBy matches the email
      final company = companyData.firstWhere(
        (company) => company['createdBy'] == email,
      );

      if (company != null) {
        setState(() {
          _nameController.text = company['companyName'] ?? 'No data saved';
          _emailController.text = company['email'] ?? 'No data saved';
          _phoneController.text = company['phone'] ?? 'No data saved';
          _addressController.text = company['address'] ?? 'No data saved';
          _employeesController.text = company['employees'] ?? 'No data saved';
          _selectedImagePath = company['image'];
        });
      } else {
        print('No company data found for the current user.');
        // Optionally, show an empty state or a message that the company profile is not available
      }
    } else {
      print('No email found in AuthBloc.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(SignOut());
    context.read<AuthBloc>().userStorage.saveCurrentEmail('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      DemozTex.companyProfile,
                      style: DemozTH.header4,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateCompanyProfile(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: DemozColors.grey,
                        backgroundImage: _selectedImagePath != null
                            ? FileImage(File(_selectedImagePath!))
                            : null,
                        child: _selectedImagePath == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: DemozColors.white,
                                size: 40,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: InkWell(
                          onTap: _pickImage,
                          child: Container(
                            height: 31,
                            width: 31,
                            decoration: const BoxDecoration(
                              color: DemozColors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: DemozColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  DemozTex.companyName,
                  style: DemozTH.header4,
                ),
              ),
              Center(
                child: Text(
                  _nameController.text,
                  style: DemozTH.body1Regular,
                ),
              ),
              const SizedBox(height: 20),
              const Text(DemozTex.emailA),
              ReadOnlyTextField(controller: _emailController),
              const SizedBox(height: 12),
              const Text(DemozTex.phoneNumber),
              ReadOnlyTextField(controller: _phoneController),
              const SizedBox(height: 12),
              const Text(DemozTex.comAdd),
              ReadOnlyTextField(controller: _addressController),
              const SizedBox(height: 12),
              const Text(DemozTex.noOfEmp),
              ReadOnlyTextField(controller: _employeesController),
              const SizedBox(height: 20),
              button('Log out', () => _logout(context), true),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
