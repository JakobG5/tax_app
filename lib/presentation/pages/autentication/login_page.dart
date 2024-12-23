import 'package:flutter/material.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/image_path_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/presentation/widgets/auth/social_btn.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Image(
                      image: AssetImage(
                        DemozImagePath.demozImage,
                      ),
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      DemozTex.welcome,
                      style: DemozTH.header4,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'to ',
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
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.emailA),
                    const SizedBox(height: 18),
                    const CustomTextField(hint: DemozTex.pass),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: button(
                        'Log in',
                        () {},
                        false,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Center(
                      child: Text(
                        DemozTex.orContinue,
                        style: DemozTH.body2Regular
                            .copyWith(color: DemozColors.grey),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(width: double.infinity, child: socialBtn()),
                    const Spacer(),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: DemozTex.signUpla,
                              style: DemozTH.body2Regular,
                            ),
                            TextSpan(
                              text: DemozTex.signup,
                              style: DemozTH.body2Regular.copyWith(
                                color: DemozColors.primaryBlue,
                              ),
                              // recognizer: (){},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
