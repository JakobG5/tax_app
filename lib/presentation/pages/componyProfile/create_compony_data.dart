import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';

class ComponyProfile extends StatelessWidget {
  const ComponyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: DemozHelper.getHeight(context),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: DemozColors.white,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.navigate_before_sharp,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: DemozTex.register,
                            style: DemozTH.header4,
                          ),
                          TextSpan(
                            text: DemozTex.demozPay,
                            style: DemozTH.header4
                                .copyWith(color: DemozColors.primaryBlue),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DemozTex.registerUr,
                      style: DemozTH.body2Regular
                          .copyWith(color: DemozColors.grey),
                    ),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comName),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comAdd),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.phoneNumber),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comTN),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comNofE),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comBank),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.comBAcc),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: button(DemozTex.submit, () {}, false),
                    ),
                    const SizedBox(height: 18),
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
