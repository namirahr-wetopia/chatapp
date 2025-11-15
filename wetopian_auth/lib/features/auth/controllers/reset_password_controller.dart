import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:wetopian_auth/features/auth/models/reset_password_command.dart';
import 'package:wetopian_auth/features/auth/models/reset_password_response_model.dart';

@injectable
class ResetPasswordController extends GetxController {
  final http.Client _httpClient;

  ResetPasswordController(this._httpClient);

  final isLoading = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  static const String _endpoint =
      'https://api.wediscount.org/api/v1/ResetPassword';
  static const String _resendEndpoint =
      'https://api.wediscount.org/api/v1/ResendOTPForPasswordResetRequest';

  Future<ResetPasswordResponse?> resetPassword(
    ResetPasswordCommand command,
  ) async {
    final String userName = command.userName;
    final String token = command.token;
    final String otp = command.otp;
    final String newPassword = command.newPassword;
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final uri = Uri.parse(_endpoint).replace(
        queryParameters: command.toQueryParameters(),
      );

      final resp = await _httpClient.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final result = ResetPasswordResponse.fromJson(body);

        if (result.hasSucceeded) {
          successMessage.value = result.message ?? 'Password reset succeeded';
        } else {
          errorMessage.value = result.message ?? 'Password reset failed';
        }
        return result;
      } else {
        try {
          final body = jsonDecode(resp.body);
          errorMessage.value = body['message']?.toString() ??
              'Reset failed (status ${resp.statusCode})';
        } catch (_) {
          errorMessage.value = 'Reset failed (status ${resp.statusCode})';
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

  Future<ResetPasswordResponse?> resendOTP(String userName) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final uri = Uri.parse(_resendEndpoint).replace(
        queryParameters: {'userName': userName},
      );

      final resp = await _httpClient.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final body = jsonDecode(resp.body) as Map<String, dynamic>;
        final result = ResetPasswordResponse.fromJson(body);

        if (result.hasSucceeded) {
          successMessage.value = result.message ?? 'OTP resent successfully';
        } else {
          errorMessage.value = result.message ?? 'Resend OTP failed';
        }
        return result;
      } else {
        try {
          final body = jsonDecode(resp.body);
          errorMessage.value = body['message']?.toString() ??
              'Resend OTP failed (status ${resp.statusCode})';
        } catch (_) {
          errorMessage.value = 'Resend OTP failed (status ${resp.statusCode})';
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
}
