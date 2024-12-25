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
import 'package:tax_app/presentation/blocs/login_bloc.dart';
import 'package:tax_app/presentation/pages/autentication/sign_page.dart';
import 'package:tax_app/presentation/widgets/auth/social_btn.dart';
import 'package:tax_app/presentation/widgets/common/btrn.dart';
import 'package:tax_app/presentation/widgets/common/text_field.dart';
import 'package:tax_app/core/di/injection_container.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();

    return BlocProvider(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              print('Login is loading...');
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }

              if (state is LoginSuccess) {
                print('Login successful!');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login successful!')),
                );
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MainRoute()));
              } else if (state is LoginFailure) {
                print('Login failed: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            }
          },
          child: SingleChildScrollView(
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
                    child: Form(
                      key: formKey,
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
                            'Welcome Back',
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
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return button(
                                  'Login',
                                  () {
                                    if (formKey.currentState!.validate()) {
                                      print(
                                          'Form is valid, submitting login...');
                                      context.read<LoginBloc>().add(
                                            LoginSubmitted(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              context: context,
                                            ),
                                          );
                                    } else {
                                      print('Form is not valid');
                                    }
                                  },
                                  state is LoginLoading,
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
                                    text: "Don't have an account? ",
                                    style: DemozTH.body2Regular,
                                  ),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: DemozTH.body2Regular.copyWith(
                                      color: DemozColors.primaryBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage(),
                                          ),
                                        );
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
