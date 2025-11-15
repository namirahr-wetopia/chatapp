class ResetPasswordResponse {
  final bool hasSucceeded;
  final String? message;
  final DateTime? expire;

  ResetPasswordResponse({
    required this.hasSucceeded,
    this.message,
    this.expire,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    final expireStr = json['expire'] as String?;
    DateTime? expireDt;
    if (expireStr != null && expireStr.isNotEmpty) {
      try {
        expireDt = DateTime.parse(expireStr);
      } catch (_) {
        expireDt = null;
      }
    }

    return ResetPasswordResponse(
      hasSucceeded: (json['hasSucceeded'] == true),
      message: json['message']?.toString(),
      expire: expireDt,
    );
  }
}
