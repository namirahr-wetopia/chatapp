import 'package:get/get.dart';
import 'package:wetopian_auth/features/auth/views/home_page.dart';
import 'package:wetopian_auth/features/auth/views/login_page.dart';
import 'package:wetopian_auth/features/auth/views/reset_password_page.dart';
import 'package:wetopian_auth/features/auth/views/send_otp_page.dart';
import 'package:wetopian_auth/features/auth/views/signup_page.dart';
import 'package:wetopian_auth/features/auth/views/policies_page.dart';
import 'package:wetopian_auth/features/auth/views/send_otp_page.dart';
import 'package:wetopian_auth/features/auth/models/policies_map.dart';
import 'package:wetopian_auth/features/auth/views/verify_contact_page.dart';
import 'package:wetopian_auth/features/splash/views/splash_screen.dart';

final routes = [
  GetPage(name: '/', page: () => const SplashScreen()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/signup', page: () => SignupPage()),
  GetPage(name:'/policies', page:() => PoliciesPage(policies: PoliciesMap().policies)),
  GetPage(name:'/forget-password', page:() => RequestResetPasswordPage()),
  GetPage(name:'/reset-password', page:() => ResetPasswordPage()),
  GetPage(name: '/verify-contact',page: () => VerifyContactPage()),
  GetPage(name: '/home',page: () => HomePage())
];