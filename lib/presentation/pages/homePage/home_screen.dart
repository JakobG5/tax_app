import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/dataCard_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/genderGraph_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/taxSummary_widget.dart';
import 'package:tax_app/presentation/widgets/homeScreenWidgets/tax_notification_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      DemozTex.home,
                      style: DemozTH.header4,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 234,
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 113,
                  ),
                  children: [
                    dataCard(DemozColors.primaryBlue, DemozTex.noOfEmp, 0),
                    dataCard(DemozColors.lightGreen, DemozTex.noOfEmp, 0),
                    dataCard(DemozColors.primaryBlue, DemozTex.noOfEmp, 0),
                    dataCard(DemozColors.lightRed, DemozTex.noOfEmp, 0),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  button(DemozTex.upcoming, () {}, true),
                  button(DemozTex.past, () {}, false),
                ],
              ),
              const SizedBox(height: 20),
              taxNotification(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: genderGraph()),
                  const SizedBox(width: 8),
                  Expanded(child: taxSummary())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
