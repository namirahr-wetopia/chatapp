import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../core/firebase/firebase_initializer.dart';
import 'package:get/get.dart';

@singleton
class AppController{
  final FirebaseInitializer _firebaseInitializer;
  RxBool initialized = false.obs;

  AppController(this._firebaseInitializer);

  Future<void> init() async {
    await _firebaseInitializer.init();
    initialized.value = true;
  }
  
}
