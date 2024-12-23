import 'package:flutter/material.dart';
// import 'package:tax_app/core/route/main_route.dart';
import 'package:tax_app/presentation/pages/autentication/sign_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
    );
  }
}
