import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:wetopian_auth/features/auth/models/user_registration_command_model.dart';
import 'package:wetopian_auth/utils/validation.dart';

@injectable
class SignUpController extends GetxController {
  final http.Client _httpClient;

  final isLoading = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  SignUpController(this._httpClient);

  static const String _checkUserStateUrl =
      'https://api.wediscount.org/api/v1/CheckUserState';

  Future<bool> checkUserExists(String userName) async {
    try {
      final uri = Uri.parse(_checkUserStateUrl).replace(
        queryParameters: {'username': userName.trim()},
      );

      final resp = await _httpClient.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final userRegistered = body['userRegistered'] ?? false;
        return userRegistered;
      }
      return false;
    } catch (e) {
      print('CheckUserState error: $e');
      return false;
    }
  }

  List<String> validateRegistration(UserRegistrationCommand user) {
    final utype = detectUsernameType(user.userName);
    if (utype == UsernameType.invalid) {
      return ['Username must be a valid email or phone number'];
    }

    if (!isNameValid(user.firstName)) {
      return ['First name must not be empty and should contain only letters'];
    }

    if (!isNameValid(user.lastName)) {
      return ['Last name must not be empty and should contain only letters'];
    }

    final pwdErrors = passwordValidationErrors(user.password);
    if (pwdErrors.isNotEmpty) {
      return [pwdErrors.first];
    }

    return [];
  }

  Future<void> registerUser(UserRegistrationCommand user) async {
    const String baseUrl = 'https://api.wediscount.org/api/v1/Register';

    final userExists = await checkUserExists(user.userName);
    if (userExists) {
      errorMessage.value =
          'This account already exists. Please log in instead.';
      return;
    }

    final validationErrors = validateRegistration(user);
    if (validationErrors.isNotEmpty) {
      errorMessage.value = validationErrors.first;
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final resp = await _httpClient.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = jsonDecode(resp.body);
        successMessage.value =
            body['message']?.toString() ?? 'Registration successful';
      } else {
        try {
          final body = jsonDecode(resp.body);
          final message = body['message']?.toString();
          errorMessage.value =
              message ?? 'Registration failed (status ${resp.statusCode})';
        } catch (_) {
          errorMessage.value =
              'Registration failed (status ${resp.statusCode})';
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
