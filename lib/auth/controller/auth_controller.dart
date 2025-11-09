import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import '../model/user.dart' hide User;
import '../services/auth_service.dart';
import '../../core/firebase/firebase_initializer.dart';

@singleton
class AuthController{
  final AuthService _authService;
  final FirebaseInitializer firebaseInitializer;

  RxBool isLoggedIn = false.obs;
  AuthController(this._authService, this.firebaseInitializer);

  Future<void> init() async{
   await firebaseInitializer.init();
   await _authService.configureProviders();
   _authService.userChanges().listen((user){
    isLoggedIn.value = user != null;
   });
  }

  User? currentUser(){
     return _authService.currentUser();
   }

  Future<void> signOut() async {
    await _authService.signOut();
    isLoggedIn.value = false;
  }

}
