import 'dart:convert';

class RequestResetPasswordCommand {
  final String userName;

  RequestResetPasswordCommand({required this.userName});

  factory RequestResetPasswordCommand.fromJson(Map<String, dynamic> json) =>
      RequestResetPasswordCommand(userName: json['userName'] as String);

  Map<String, dynamic> toJson() => {'userName': userName};

  @override
  String toString() => jsonEncode(toJson());
}
