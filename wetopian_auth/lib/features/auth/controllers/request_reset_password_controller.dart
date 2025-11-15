import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:wetopian_auth/features/auth/models/request_reset_password_command_model.dart';
import 'package:wetopian_auth/features/auth/models/request_reset_password_response_model.dart';
import 'package:wetopian_auth/utils/validation.dart';

@injectable
class RequestResetController extends GetxController {
  final http.Client _httpClient;

  RequestResetController(this._httpClient);

  final isLoading = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  static const String _endpoint =
      'https://api.wediscount.org/api/v1/RequestResetPassword';

  List<String> validateUserName(String userName) {
    final errors = <String>[];
    final trimmed = userName.trim();
    if (trimmed.isEmpty) {
      errors.add('Please enter your email or phone.');
      return errors;
    }

    final type = detectUsernameType(trimmed);
    if (type == UsernameType.invalid) {
      errors.add('Enter a valid email address or phone number.');
    }
    return errors;
  }

  Future<RequestResetPasswordResponse?> requestReset(
    RequestResetPasswordCommand command,
  ) async {
    final v = validateUserName(command.userName);
    if (v.isNotEmpty) {
      errorMessage.value = v.join('\n');
      return null;
    }

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final uri = Uri.parse(_endpoint).replace(
        queryParameters: {'userName': command.userName},
      );

      final resp = await _httpClient.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      print('RequestReset response: ${resp.statusCode} ${resp.body}');

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final result = RequestResetPasswordResponse.fromJson(body);

        if (result.isSucceeded) {
          successMessage.value = result.message ?? 'Reset request succeeded';
          return result;
        } else {
          errorMessage.value =
              result.message ?? 'Reset request failed (no reason provided)';
          return result;
        }
      } else {
        try {
          final body = jsonDecode(resp.body);
          final message = (body is Map && body['message'] != null)
              ? body['message'].toString()
              : 'Reset request failed (status ${resp.statusCode})';
          errorMessage.value = message;
        } catch (_) {
          errorMessage.value =
              'Reset request failed (status ${resp.statusCode})';
        }
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RequestResetPasswordResponse?> requestResetFromForm(
    String userName,
  ) async {
    final cmd = RequestResetPasswordCommand(userName: userName.trim());
    return await requestReset(cmd);
  }
}
