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
    try {
      final email = await context.read<AuthBloc>().userStorage.getCurrentEmail();
      print('Current Email: $email'); // Debug

      if (email != null) {
        final companyData = await sl<UserLocalStorage>().getAllCompanyData();
        print('Fetched Company Data: $companyData'); // Debug

        // Find the company data where createdBy matches the email
        final companyMatch = companyData.where(
          (company) => company['createdBy'] == email,
        ).toList();

        if (companyMatch.isNotEmpty) {
          final company = companyMatch.first;
          setState(() {
            _nameController.text = company['componyName'] ?? 'No data saved';
            _emailController.text = company['createdBy'] ?? 'No data saved';
            _phoneController.text = company['phoneNumber'] ?? 'No data saved';
            _addressController.text = company['addressOfCompony'] ?? 'No data saved';
            _employeesController.text = company['numberOfEmployees'] ?? 'No data saved';
            _selectedImagePath = company['image'];
          });
        } else {
          setState(() {
            _nameController.text = 'No data saved';
            _emailController.text = 'No data saved';
            _phoneController.text = 'No data saved';
            _addressController.text = 'No data saved';
            _employeesController.text = 'No data saved';
          });
          print('No company data found for the current user.');
        }
      } else {
        print('No email found in AuthBloc.');
        // Show a snackbar or handle the error appropriately
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in again')),
        );
      }
    } catch (e) {
      print('Error loading company data: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading company data: $e')),
      );
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