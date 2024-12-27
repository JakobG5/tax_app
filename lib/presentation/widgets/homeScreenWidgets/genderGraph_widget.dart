import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tax_app/core/constants/color_constant.dart';

class GenderGraphWidget extends StatelessWidget {
  final int maleCount;
  final int femaleCount;

  const GenderGraphWidget({
    super.key,
    required this.maleCount,
    required this.femaleCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: DemozColors.borderColor,
      ),
      child: maleCount == 0 && femaleCount == 0
          ? const Center(
              child: Text(
                'No employees',
                style: TextStyle(
                  color: DemozColors.grey,
                  fontSize: 16,
                ),
              ),
            )
          : PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: maleCount.toDouble(),
                    color: DemozColors.primaryBlue,
                    title: 'M',
                  ),
                  PieChartSectionData(
                    value: femaleCount.toDouble(),
                    color: DemozColors.lightRed,
                    title: 'F',
                  ),
                ],
              ),
            ),
    );
  }
}

