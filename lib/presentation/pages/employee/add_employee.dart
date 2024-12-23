import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';

class EmployeeAdd extends StatelessWidget {
  const EmployeeAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DemozColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: DemozHelper.getHeight(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.navigate_before_sharp,
                            size: 30,
                          ),
                        ),
                        Text(
                          DemozTex.addEmp,
                          style: DemozTH.pop.copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: DemozTex.addN,
                            style: DemozTH.header4,
                          ),
                          TextSpan(
                            text: DemozTex.emp,
                            style: DemozTH.header4
                                .copyWith(color: DemozColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      DemozTex.hereyouaddyour,
                      style: DemozTH.body1Regular.copyWith(
                        color: DemozColors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CustomTextField(hint: DemozTex.emName),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.emailA),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.phoneNumber),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comTN),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.grossSalary),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.taxableEarning),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.startingDate),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        salaryType(DemozTex.perMonth, () {}),
                        const SizedBox(width: 12),
                        salaryType(DemozTex.perContract, () {}),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: button(
                        DemozTex.addEmp,
                        () {},
                        false,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget salaryType(String title, Function()? onPressed) {
  return InkWell(
    onTap: () {},
    child: Container(
      height: 36,
      width: 124,
      decoration: BoxDecoration(
        color: const Color(0XFF3085FE).withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          DemozTex.perMonth,
          style: DemozTH.body2Regular.copyWith(color: DemozColors.white),
        ),
      ),
    ),
  );
}
