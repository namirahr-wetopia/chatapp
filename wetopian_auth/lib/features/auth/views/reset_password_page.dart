import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wetopian_auth/features/auth/controllers/reset_password_controller.dart';
import 'package:wetopian_auth/features/auth/models/reset_password_command.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final ResetPasswordController _ctrl = GetIt.I<ResetPasswordController>();

  late Timer _timer;
  int _countdown = 300; // 5 minutes
  bool _canResend = false;

  late String _userName;
  late String _token;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;
    _userName = arguments['userName'] ?? '';
    _token = arguments['token'] ?? '';

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _countdown = 300; // Reset to 5 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Future<void> _onResetPressed() async {
    final otp = otpController.text.trim();
    final newPwd = newPasswordController.text;
    final confirm = confirmNewPasswordController.text;

    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    if (newPwd.isEmpty) {
      Get.snackbar('Error', 'Please enter new password');
      return;
    }

    if (newPwd != confirm) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    final command = ResetPasswordCommand(
      userName: _userName,
      token: _token,
      otp: otp,
      newPassword: newPwd,
    );

    final res = await _ctrl.resetPassword(command);

    if (res != null) {
      if (res.hasSucceeded) {
        Get.snackbar('Success',
            res.message ?? 'Password reset successful. Please login again.');
        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', res.message ?? 'Reset failed');
      }
    } else {
      Get.snackbar('Error', _ctrl.errorMessage.value);
    }
  }

  Future<void> _onResendPressed() async {
    if (!_canResend) return;

    final res = await _ctrl.resendOTP(_userName);

    if (res != null && res.hasSucceeded) {
      _startTimer();
      Get.snackbar('Success', res.message ?? 'OTP resent successfully');
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
                        padding: const EdgeInsets.all(20),
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
                      const Text('OTP', style: TextStyle(fontSize: 20)),
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
                          controller: otpController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.punch_clock_outlined),
                            labelText: 'Enter OTP',
                            labelStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Didn't get the verification code?",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          _canResend
                              ? TextButton(
                                  onPressed: _onResendPressed,
                                  child: Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.greenAccent.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Resend in ${_formatTime(_countdown)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('New Password',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: newPasswordController,
                                obscureText: _obscureNew,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.key_rounded),
                                  labelText: 'Enter new password',
                                  labelStyle: TextStyle(fontSize: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureNew = !_obscureNew;
                                });
                              },
                              icon: Icon(
                                _obscureNew
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Confirm Password',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: confirmNewPasswordController,
                                obscureText: _obscureConfirm,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.key_rounded),
                                  labelText: 'Confirm new password',
                                  labelStyle: TextStyle(fontSize: 20),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureConfirm = !_obscureConfirm;
                                });
                              },
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _onResetPressed,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
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
                                'Reset password',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
