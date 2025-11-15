import 'dart:convert';

class RequestResetPasswordResponse {
  final bool isSucceeded;
  final String? token;
  final String? message;
  final DateTime? expire;

  RequestResetPasswordResponse({
    required this.isSucceeded,
    this.token,
    this.message,
    this.expire,
  });

  factory RequestResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    final expireStr = json['expire'] as String?;
    DateTime? expireDt;
    if (expireStr != null && expireStr.isNotEmpty) {
      try {
        expireDt = DateTime.parse(expireStr);
      } catch (_) {
        expireDt = null;
      }
    }
    return RequestResetPasswordResponse(
      isSucceeded: (json['isSucceeded'] == true),
      token: json['token']?.toString(),
      message: json['message']?.toString(),
      expire: expireDt,
    );
  }

  Map<String, dynamic> toJson() => {
        'isSucceeded': isSucceeded,
        'token': token,
        'message': message,
        'expire': expire?.toIso8601String(),
      };

  @override
  String toString() => jsonEncode(toJson());
}
