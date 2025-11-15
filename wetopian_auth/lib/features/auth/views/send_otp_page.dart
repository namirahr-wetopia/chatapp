import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wetopian_auth/features/auth/controllers/request_reset_password_controller.dart';
import 'package:wetopian_auth/features/auth/models/request_reset_password_command_model.dart';

class RequestResetPasswordPage extends StatefulWidget {
  const RequestResetPasswordPage({super.key});

  @override
  State<RequestResetPasswordPage> createState() =>
      _RequestResetPasswordPageState();
}

class _RequestResetPasswordPageState extends State<RequestResetPasswordPage> {
  final TextEditingController userNameController = TextEditingController();
  final RequestResetController _ctrl = GetIt.I<RequestResetController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final userName = userNameController.text.trim();

    if (userName.isEmpty) {
      Get.snackbar('Error', 'Please enter email or phone');
      return;
    }

    final res = await _ctrl.requestResetFromForm(userName);

    if (res != null && res.isSucceeded) {
      Get.snackbar('Success', res.message ?? 'OTP sent successfully');

      Get.toNamed(
        '/reset-password',
        arguments: {
          'userName': userName,
          'token': res.token,
        },
      );
    } else {
      Get.snackbar('Error', _ctrl.errorMessage.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: Icon(
                          Icons.lock_reset_outlined,
                          color: Colors.greenAccent.shade400,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email or phone',
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: userNameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.mail_outline),
                            labelText: 'Enter your email or phone',
                            labelStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: _onContinuePressed,
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.greenAccent.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Obx(
                            () => _ctrl.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Continue',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
