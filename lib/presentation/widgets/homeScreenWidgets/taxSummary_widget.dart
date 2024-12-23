import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';

Widget taxSummary() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    height: 128,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: DemozColors.borderColor,
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DemozTex.taxSummary,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: DemozColors.black),
        ),
        Text(
          '9,346.85 ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
