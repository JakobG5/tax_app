import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';

Widget taxNotification() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    width: double.infinity,
    height: 138,
    decoration: BoxDecoration(
      color: DemozColors.borderColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DemozTex.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      'Aug 28, 2024 - Sep 5,2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 68,
                height: 28,
                decoration: BoxDecoration(
                  color: DemozColors.lightBac,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text(
                  DemozTex.payNow,
                  style: TextStyle(
                    color: DemozColors.lightRed,
                    fontSize: 12,
                  ),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DemozTex.incomeTax,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '4000 etb',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DemozTex.pensionTax,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '5000 etb',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text('August Tax on due'),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
