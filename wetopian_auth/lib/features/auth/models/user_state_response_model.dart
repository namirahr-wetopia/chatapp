class UserStateResponse {
  final bool userRegistered;
  final int state;

  UserStateResponse({
    required this.userRegistered,
    required this.state,
  });

  factory UserStateResponse.fromJson(Map<String, dynamic> json) {
    return UserStateResponse(
      userRegistered: json['userRegistered'] ?? false,
      state: json['state'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'userRegistered': userRegistered,
        'state': state,
      };
}