import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tax_app/core/di/injection_container.dart' as di;
import 'package:tax_app/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.initializeDependencies();
  runApp(const MyApp(),);
}
