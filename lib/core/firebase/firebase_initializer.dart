import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseInitializer {
  Future<void>init()async{
    await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform
    );
  }
}