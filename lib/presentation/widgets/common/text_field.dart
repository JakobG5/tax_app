import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final bool? isObscure;
  const CustomTextField({
    super.key,
    this.controller,
    this.hint,
    this.inputType,
    this.validator,
    this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        filled: true,
        fillColor: DemozColors.white,
        labelText: hint,
        labelStyle: DemozTH.labelRegular.copyWith(color: DemozColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: DemozColors.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: DemozColors.primaryBlue,
          ),
        ),
      ),
    );
  }
}
