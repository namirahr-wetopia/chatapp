import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wetopian_auth/core/di/di.dart';
import 'package:wetopian_auth/features/auth/controllers/login_controller.dart';
import 'package:wetopian_auth/features/auth/views/login_page.dart';
import 'package:wetopian_auth/core/routes/routes.dart';
import 'package:wetopian_auth/features/splash/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final loginController = GetIt.I<LoginController>();
  await loginController.tryRestoreSession();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const SplashScreen(),
      getPages: routes,
    );
  }
}
