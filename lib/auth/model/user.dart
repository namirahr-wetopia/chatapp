import 'package:firebase_auth/firebase_auth.dart';

class User{
  final String uid;
  final String? email;

  User({required this.uid, this.email});

  factory User.fromFirebase(User user){
    return User(uid: user.uid, email: user.email);
  }
}