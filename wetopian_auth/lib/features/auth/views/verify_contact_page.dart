import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wetopian_auth/features/auth/controllers/verify_contact_controller.dart';

class VerifyContactPage extends StatefulWidget {
  const VerifyContactPage({super.key});

  @override
  State<VerifyContactPage> createState() => _VerifyContactPageState();
}

class _VerifyContactPageState extends State<VerifyContactPage> {
  final TextEditingController otpController = TextEditingController();
  final VerifyContactController _ctrl = GetIt.I<VerifyContactController>();

  late Timer _timer;
  int _countdown = 300; // 5 minutes
  bool _canResend = false;

  late String _userName;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;
    _userName = arguments['userName'] ?? '';

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
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

  Future<void> _onConfirmPressed() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    final res = await _ctrl.verifyContactFromForm(_userName, otp);

    if (res != null) {
      if (res.hasSucceeded) {
        Get.snackbar('Success', res.message ?? 'Contact verified successfully');

        Get.offAllNamed('/login');
      } else {
        Get.snackbar('Error', res.message ?? 'Verification failed');
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
                          Icons.verified_user_outlined,
                          color: Colors.greenAccent.shade400,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Verify Contact',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verification Code',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: otpController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.sms_outlined),
                            labelText: 'Enter verification code',
                            labelStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Didn't receive the code?",
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
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: _onConfirmPressed,
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
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Verify Contact',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
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
