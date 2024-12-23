import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/image_path_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';

Widget socialBtn() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      width: 135,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: DemozColors.borderColor,
        ),
        color: DemozColors.white,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(DemozImagePath.google),
          ),
          SizedBox(width: 8),
          Text(DemozTex.google),
        ],
      ),
    ),
  );
}
