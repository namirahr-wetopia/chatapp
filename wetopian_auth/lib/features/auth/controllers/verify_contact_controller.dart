import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:wetopian_auth/features/auth/models/verify_contact_command_model,dart';
import 'package:wetopian_auth/features/auth/models/verify_contact_response_model.dart';

@injectable
class VerifyContactController extends GetxController {
  final http.Client _httpClient;

  VerifyContactController(this._httpClient);

  final isLoading = false.obs;
  final successMessage = ''.obs;
  final errorMessage = ''.obs;

  static const String _endpoint =
      'https://api.wediscount.org/api/v1/VerifyContact';
  static const String _resendEndpoint =
      'https://api.wediscount.org/api/v1/ResendOTPForConfirmingContact';

  Future<VerifyContactResponse?> verifyContact(
      VerifyContactCommand command) async {
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
        final result = VerifyContactResponse.fromJson(body);

        if (result.hasSucceeded) {
          successMessage.value =
              result.message ?? 'Contact verified successfully';
        } else {
          errorMessage.value = result.message ?? 'Verification failed';
        }
        return result;
      } else {
        try {
          final body = jsonDecode(resp.body);
          errorMessage.value = body['message']?.toString() ??
              'Verification failed (status ${resp.statusCode})';
        } catch (_) {
          errorMessage.value =
              'Verification failed (status ${resp.statusCode})';
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

  Future<VerifyContactResponse?> resendOTP(String userName) async {
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
        final result = VerifyContactResponse.fromJson(body);

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

  Future<VerifyContactResponse?> verifyContactFromForm(
      String userName, String otp) async {
    final cmd = VerifyContactCommand(
      userName: userName.trim(),
      otp: otp.trim(),
    );
    return await verifyContact(cmd);
  }
}
