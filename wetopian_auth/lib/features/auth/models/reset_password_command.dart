class ResetPasswordCommand {
  final String userName;
  final String token;
  final String otp;
  final String newPassword;

  ResetPasswordCommand({
    required this.userName,
    required this.token,
    required this.otp,
    required this.newPassword,
  });

  factory ResetPasswordCommand.fromJson(Map<String, dynamic> json) {
    return ResetPasswordCommand(
      userName: json['UserName'] ?? '',
      token: json['Token'] ?? '',
      otp: json['OTP'] ?? '',
      newPassword: json['NewPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserName': userName,
      'Token': token,
      'OTP': otp,
      'NewPassword': newPassword,
    };
  }

  /// This is what we actually need for GET/POST query parameters
  Map<String, dynamic> toQueryParameters() {
    return {
      'UserName': userName,
      'Token': token,
      'OTP': otp,
      'NewPassword': newPassword,
    };
  }
}
