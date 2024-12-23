import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';

Widget button(String title, VoidCallback? onPressed, bool isActive) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 135,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive ? DemozColors.primaryBlue : DemozColors.btn1,
      ),
      child: Center(
        child: Text(
          title,
          style: DemozTH.body1Regular.copyWith(
              color: isActive ? DemozColors.white : DemozColors.black),
        ),
      ),
    ),
  );
}
