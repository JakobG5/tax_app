import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/presentation/blocs/home/home_bloc.dart';

Widget taxSummary() {
  return BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      double totalTax = 0;
      
      if (state is HomeLoaded) {
        totalTax = state.isUpcoming 
            ? (state.upcomingIncomeTax + state.upcomingPensionTax)
            : (state.incomeTaxPaid + state.pensionTaxPaid);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        height: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DemozColors.borderColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              DemozTex.taxSummary,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DemozColors.black,
              ),
            ),
            Text(
              '${totalTax.toStringAsFixed(2)} ETB',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    },
  );
}