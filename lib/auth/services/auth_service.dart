import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {

  Stream<User?> userChanges(){
   return FirebaseAuth.instance.userChanges();
  }

  Future<void> configureProviders() async{
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);
  }

  User? currentUser(){
    FirebaseAuth.instance.currentUser!;
  }

  Future<void> signOut() async{
    FirebaseAuth.instance.signOut();
  }
}
