import 'package:chatapp/auth/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/di/di.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/view/login_page.dart';

class HomePage extends StatelessWidget {
  final authController = getIt<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (authController.isLoggedIn.value) {
        final email = authController.currentUser()!.email ?? 'User';
        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome $email'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authController.signOut(),
              ),
            ],
          ),
          body: const Center(child: Text('Home content here')),
        );
      } else {
        return LoginPage();
      }
    });
  }
}
