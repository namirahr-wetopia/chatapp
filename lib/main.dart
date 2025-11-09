import 'package:chatapp/auth/controller/auth_controller.dart';
import 'package:chatapp/core/firebase/firebase_initializer.dart';
import 'package:chatapp/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'core/di/di.dart';
import 'controller/app_controller.dart';
import 'auth/view/login_page.dart';
import 'home/view/home_page.dart';
import 'package:get/get.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final firebaseInitializer = FirebaseInitializer();
    await firebaseInitializer.init(); 
    configureDependencies(); 
    final appController = getIt<AppController>();
    await appController.init();
    final authController = getIt<AuthController>();
    await authController.init();
    runApp(MyApp());
  } catch (e, st) {
    print('DI Error: $e');
    print(st);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appController = getIt<AppController>();

    return Obx(() {
      if (!appController.initialized.value) {
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      return MaterialApp(
        title: 'Modular Firebase App',
        home: HomePage()
      );
    });
  }
}