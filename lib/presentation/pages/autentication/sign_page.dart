import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/core/constants/color_constant.dart';
import 'package:tax_app/core/constants/image_path_constant.dart';
import 'package:tax_app/core/constants/text_constant.dart';
import 'package:tax_app/core/route/main_route.dart';
import 'package:tax_app/core/themes/text_theme.dart';
import 'package:tax_app/core/utils/helper.dart';
import 'package:tax_app/core/utils/validation.dart';
import 'package:tax_app/presentation/blocs/sign_up_bloc.dart';
import 'package:tax_app/presentation/widgets/auth/social_btn.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';
import 'package:tax_app/core/di/injection_container.dart';

class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();

    return BlocProvider(
      create: (context) => sl<SignUpBloc>(),
      child: Scaffold(
        body: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is SignUpSuccess) {
              Navigator.pop(context); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up successful!')),
              );
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainRoute()));
            } else if (state is SignUpFailure) {
              Navigator.pop(context); // Dismiss loading dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: DemozHelper.getHeight(context),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(color: DemozColors.white),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Image(
                            image: AssetImage(DemozImagePath.demozImage),
                            width: 70,
                            height: 70,
                          ),
                          const SizedBox(height: 18),
                          const Text(DemozTex.welcome, style: DemozTH.header4),
                          Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'to ',
                                  style: DemozTH.header4,
                                ),
                                TextSpan(
                                  text: DemozTex.demozPay,
                                  style: DemozTH.header4.copyWith(
                                    color: DemozColors.primaryBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            hint: DemozTex.emailA,
                            controller: emailController,
                            validator: Validation.validateEmail,
                            inputType: TextInputType.emailAddress,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocusNode);
                            },
                          ),
                          const SizedBox(height: 18),
                          CustomTextField(
                            hint: DemozTex.pass,
                            controller: passwordController,
                            validator: Validation.validatePassword,
                            isObscure: true,
                            focusNode: passwordFocusNode,
                          ),
                          const SizedBox(height: 26),
                          SizedBox(
                            width: double.infinity,
                            child: BlocBuilder<SignUpBloc, SignUpState>(
                              builder: (context, state) {
                                return button(
                                  'Sign up',
                                  () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<SignUpBloc>().add(
                                            SignUpSubmitted(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              context: context,
                                            ),
                                          );
                                    }
                                  },
                                  state is SignUpLoading,
                                );
                              },
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
                                    text: DemozTex.loginrequest,
                                    style: DemozTH.body2Regular,
                                  ),
                                  TextSpan(
                                    text: DemozTex.login,
                                    style: DemozTH.body2Regular.copyWith(
                                      color: DemozColors.primaryBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
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
          ),
        ),
      ),
    );
  }
}
