import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:wetopian_auth/features/auth/controllers/signup_controller.dart';
import 'package:wetopian_auth/features/auth/models/user_registration_command_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignUpController _signUpController = GetIt.I<SignUpController>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = false;
  bool _obscureConfirmPassword = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSignUpPressed() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    final user = UserRegistrationCommand(
      userName: userNameController.text.trim(),
      password: passwordController.text,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );

    await _signUpController.registerUser(user);

    if (_signUpController.successMessage.isNotEmpty) {
      Get.snackbar('Success', _signUpController.successMessage.value);

      Get.toNamed(
        '/verify-contact',
        arguments: {
          'userName': userNameController.text.trim(),
        },
      );
    } else if (_signUpController.errorMessage.isNotEmpty) {
      Get.snackbar('Error', _signUpController.errorMessage.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 80,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text('Get Started!',
                              style: TextStyle(fontSize: 30)),
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.g_mobiledata_rounded, size: 40),
                                SizedBox(width: 8),
                                Text(
                                  'Log in with Google',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Text('First Name',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 5),
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
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person_outline_rounded),
                              labelText: 'First Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('Last Name', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 5),
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
                            controller: lastNameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person_outline_rounded),
                              labelText: 'Last Name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('User Name', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 5),
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
                            controller: userNameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.mail_outlined),
                              labelText: 'Email or Phone',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('Password', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 5),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.key_rounded),
                                    labelText: 'Password',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text('Confirm Password',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 5),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.key_rounded),
                                    labelText: 'Confirm Password',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.remove_red_eye_outlined
                                      : Icons.visibility_off,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(
                            () => TextButton(
                              onPressed: _signUpController.isLoading.value
                                  ? null
                                  : _onSignUpPressed,
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.greenAccent.shade400,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _signUpController.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(fontSize: 12),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed('/login'),
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.greenAccent.shade400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'By signing up, you agree to our Terms, Data Policy and Cookie Policy...',
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.toNamed('/policies'),
                    icon: const Icon(Icons.info_outlined),
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
