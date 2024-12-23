import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';

class CompanyProfile extends StatelessWidget {
  const CompanyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      DemozTex.companyName,
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
              const SizedBox(height: 40),
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: DemozColors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 16,
                      child: Container(
                        height: 31,
                        width: 31,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: DemozColors.orange,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: DemozColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  DemozTex.companyName,
                  style: DemozTH.pop.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  DemozTex.hM,
                  style: DemozTH.pop.copyWith(
                    color: DemozColors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(DemozTex.companyEmail),
              const SizedBox(
                height: 6,
              ),
              const CustomTextField(),
              const SizedBox(height: 12),
              const Text(DemozTex.phoneNumber),
              const SizedBox(
                height: 6,
              ),
              const CustomTextField(),
              const SizedBox(height: 12),
              const Text(DemozTex.comAdd),
              const SizedBox(
                height: 6,
              ),
              const CustomTextField(),
              const SizedBox(height: 12),
              const Text(DemozTex.noOfEmp),
              const SizedBox(
                height: 6,
              ),
              const CustomTextField(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
