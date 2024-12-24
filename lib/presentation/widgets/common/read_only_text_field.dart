import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';

class ReadOnlyTextField extends HookWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final bool isObscure;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const ReadOnlyTextField({
    super.key,
    this.controller,
    this.hint,
    this.inputType,
    this.validator,
    this.isObscure = false,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);

    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      obscureText: isObscure && !isPasswordVisible.value,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: true,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: DemozColors.lightRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 1,
            color: DemozColors.lightRed,
          ),
        ),
        suffixIcon: isObscure
            ? IconButton(
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: DemozColors.grey,
                ),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              )
            : null,
      ),
    );
  }
}
