import 'package:meta/meta.dart';
import 'dart:convert';

LoginCommand loginCommandFromJson(String str) => LoginCommand.fromJson(json.decode(str));

String loginCommandToJson(LoginCommand data) => json.encode(data.toJson());

class LoginCommand {
    String userName;
    String password;

    LoginCommand({
        required this.userName,
        required this.password,
    });

    factory LoginCommand.fromJson(Map<String, dynamic> json) => LoginCommand(
        userName: json["userName"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
    };
}
