import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:tax_app/presentation/blocs/employee_list_bloc.dart';
import 'package:tax_app/presentation/blocs/addEmployeeBloc.dart';
import 'package:tax_app/core/route/main_route.dart';
import 'package:tax_app/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:tax_app/core/di/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>()..add(CheckAuthStatus()),
        ),
        BlocProvider<EmployeeAddBloc>(
          create: (context) => sl<EmployeeAddBloc>(),
        ),
        BlocProvider<EmployeeListBloc>(
          create: (context) => sl<EmployeeListBloc>(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const MainRoute();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}
