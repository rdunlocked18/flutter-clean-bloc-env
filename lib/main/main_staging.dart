import 'package:flutter/material.dart';

import '../main.dart';
import 'app_env.dart';
import '../injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  mainCommon(AppEnvironment.STAGING);
}
