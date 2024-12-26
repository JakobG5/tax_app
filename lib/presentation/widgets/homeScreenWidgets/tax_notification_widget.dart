import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/presentation/blocs/home/home_bloc.dart';

Widget taxNotification(HomeLoaded state) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      DemozTex.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${_formatDate(state.nextPaymentStartDate)} - ${_formatDate(state.nextPaymentEndDate)}',
                      style: const TextStyle(
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
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DemozTex.incomeTax,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${state.upcomingIncomeTax.toStringAsFixed(2)} etb',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DemozTex.pensionTax,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      '${state.upcomingPensionTax.toStringAsFixed(2)} etb',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF101317),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Upcoming Tax Payment'),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

String _formatDate(DateTime date) {
  return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}
