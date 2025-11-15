import 'package:meta/meta.dart';
import 'dart:convert';

UserRegistrationCommand userRegistrationCommandFromJson(String str) => UserRegistrationCommand.fromJson(json.decode(str));

String userRegistrationCommandToJson(UserRegistrationCommand data) => json.encode(data.toJson());

class UserRegistrationCommand {
    String userName;
    String password;
    String firstName;
    String lastName;

    UserRegistrationCommand({
        required this.userName,
        required this.password,
        required this.firstName,
        required this.lastName,
    });

    factory UserRegistrationCommand.fromJson(Map<String, dynamic> json) => UserRegistrationCommand(
        userName: json["userName"],
        password: json["password"],
        firstName: json["firstName"],
        lastName: json["lastName"],
    );

    Map<String, dynamic> toJson() => {
        "userName": userName,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
    };
}
