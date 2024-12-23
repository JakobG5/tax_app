// ignore: file_names
import 'package:flutter/material.dart';
import 'package:tax_app/core/themes/text_theme.dart';

Widget dataCard(Color color, String titile, int data) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        width: 1,
        color: color,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          titile,
          style: DemozTH.body1Regular
              .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
        )),
        Text(
          '$data',
          style: DemozTH.body1Regular.copyWith(
              fontWeight: FontWeight.w500, fontSize: 20, color: color),
        ),
      ],
    ),
  );
}
