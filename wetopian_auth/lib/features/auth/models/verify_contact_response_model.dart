class VerifyContactResponse {
  final bool hasSucceeded;
  final String? message;
  final DateTime? expire;

  VerifyContactResponse({
    required this.hasSucceeded,
    this.message,
    this.expire,
  });

  factory VerifyContactResponse.fromJson(Map<String, dynamic> json) {
    final expireStr = json['expire'] as String?;
    DateTime? expireDt;
    if (expireStr != null && expireStr.isNotEmpty) {
      try {
        expireDt = DateTime.parse(expireStr);
      } catch (_) {
        expireDt = null;
      }
    }
    return VerifyContactResponse(
      hasSucceeded: (json['hasSucceeded'] == true),
      message: json['message']?.toString(),
      expire: expireDt,
    );
  }

  Map<String, dynamic> toJson() => {
        'hasSucceeded': hasSucceeded,
        'message': message,
        'expire': expire?.toIso8601String(),
      };
}
