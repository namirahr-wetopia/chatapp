import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:wetopian_auth/core/secure_storage/secure_storage_service.dart';
import 'package:wetopian_auth/features/auth/models/login_command_model.dart';
import 'package:wetopian_auth/utils/validation.dart';

@injectable
class LoginController extends GetxController {
  final http.Client _httpClient;
  final SecureStorageService _secureStorage;

  LoginController(this._httpClient, this._secureStorage);

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final successMessage = ''.obs;
  final isAuthenticated = false.obs;

  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(minutes: 15);

  static const String _loginUrl = 'https://api.wediscount.org/api/v1/Login';
  static const String _silentLoginUrl =
      'https://api.wediscount.org/api/v1/SilentLogin';



static const String _checkUserStateUrl = 'https://api.wediscount.org/api/v1/CheckUserState';


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

Future<bool> loginFromForm({
  required String userName,
  required String password,
  void Function()? onSuccess,
}) async {

  errorMessage.value = '';
  successMessage.value = '';

  final userExists = await checkUserExists(userName);
  
  if (!userExists) {
    errorMessage.value = 'This account does not exist. Please sign up first.';
    return false;
  }

  final model = LoginCommand(userName: userName.trim(), password: password);
  final ok = await login(model);
  if (ok) {
    if (onSuccess != null) onSuccess();
  }
  return ok;
}


Future<bool> login(LoginCommand model) async {
  final validationErrors = validateCredentials(model);
  if (validationErrors.isNotEmpty) {
    errorMessage.value = validationErrors.first;
    return false;
  }

  isLoading.value = true;
  errorMessage.value = '';
  successMessage.value = '';

  try {
    final resp = await _httpClient.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      print('Login response body: ${resp.body}');
      final body = jsonDecode(resp.body) as Map<String, dynamic>;

      final accessToken = body['accessToken']?.toString();
      final refreshToken = body['refreshToken']?.toString();
      final userJson = jsonEncode(body['user']);

      if (accessToken != null && refreshToken != null) {
        await _secureStorage.writeAccessToken(accessToken);
        await _secureStorage.writeRefreshToken(refreshToken);
        await _secureStorage.writeUserJson(userJson);
        await _secureStorage.writeTokenSavedAt(
          DateTime.now().toIso8601String(),
        );

        isAuthenticated.value = true;
        successMessage.value = body['message']?.toString() ?? 'Login successful';

        _startPeriodicSilentRefresh();

        return true;
      } else {
        errorMessage.value = body['message']?.toString() ?? 'Login failed - missing tokens';
        return false;
      }
    } else {

      try {
        final body = jsonDecode(resp.body);
        final message = body['message']?.toString();
        errorMessage.value = message ?? 'Login failed (status ${resp.statusCode})';
      } catch (_) {
        errorMessage.value = 'Login failed (status ${resp.statusCode})';
      }
      return false;
    }
  } catch (e) {
    errorMessage.value = 'Network error: $e';
    return false;
  } finally {
    isLoading.value = false;
  }
}

  List<String> validateCredentials(LoginCommand model) {
    final errors = <String>[];
    final utype = detectUsernameType(model.userName);
    if (utype == UsernameType.invalid) {
      errors.add('Please enter a valid email or phone number.');
    }
    if (model.password.trim().isEmpty) {
      errors.add('Password must not be empty.');
    }
    return errors;
  }

  
  Future<bool> performSilentLogin() async {
    final rtoken = await _secureStorage.readRefreshToken();
    if (rtoken == null || rtoken.isEmpty) {
      _handleSilentFailure('No refresh token found');
      return false;
    }

    try {
      final resp = await _httpClient.post(
        Uri.parse(_silentLoginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': rtoken}),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final newAccess = body['accessToken']?.toString();
        final newRefresh = body['refreshToken']?.toString();
        final userJson = jsonEncode(body['user']);

        if (newAccess != null && newRefresh != null) {
          await _secureStorage.writeAccessToken(newAccess);
          await _secureStorage.writeRefreshToken(newRefresh);
          await _secureStorage.writeUserJson(userJson);
          await _secureStorage.writeTokenSavedAt(
            DateTime.now().toIso8601String(),
          );
          isAuthenticated.value = true;
          return true;
        } else {
          _handleSilentFailure('Silent login response missing tokens');
          return false;
        }
      } else {
        _handleSilentFailure('Silent login failed (status ${resp.statusCode})');
        return false;
      }
    } catch (e) {
      _handleSilentFailure('Silent login network error: $e');
      return false;
    }
  }

  Future<void> logout({bool clearServer = true}) async {
    isLoading.value = true;

    try {

      _stopPeriodicSilentRefresh();


      await _secureStorage.deleteAll();

      isAuthenticated.value = false;
      successMessage.value = '';
      errorMessage.value = '';

      Get.offAllNamed('/login');


      Get.snackbar('Logged Out', 'You have successfully logged out');
    } catch (e) {

      await _secureStorage.deleteAll();
      isAuthenticated.value = false;
      Get.offAllNamed('/login');

      Get.snackbar('Logged Out', 'You have been logged out');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutFromUI() async {
    await logout();
  }

  Future<void> _handleSilentFailure(String reason) async {

    _stopPeriodicSilentRefresh();
    await logout(clearServer: false);
    errorMessage.value = 'Session ended: $reason';
  }


void _startPeriodicSilentRefresh() {
  _refreshTimer?.cancel();
  _refreshTimer = Timer.periodic(_refreshInterval, (_) async {
    await performSilentLogin();
  });
}

  void _stopPeriodicSilentRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }


  Future<bool> tryRestoreSession() async {
    final rtoken = await _secureStorage.readRefreshToken();
    final atoken = await _secureStorage.readAccessToken();

    if (rtoken != null && rtoken.isNotEmpty) {
      
      final ok = await performSilentLogin();
      if (ok) {
        _startPeriodicSilentRefresh();
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  @override
  void onClose() {
    _stopPeriodicSilentRefresh();
    super.onClose();
  }
}
