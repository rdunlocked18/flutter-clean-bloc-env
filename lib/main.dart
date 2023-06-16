import 'package:clean_architecture_tdd_course/main/app.dart';
import 'package:clean_architecture_tdd_course/main/app_env.dart';

import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  mainCommon(AppEnvironment.PROD);
}

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvInfo.initialize(environment);

  runApp(const MyApp());
}
