import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

final GetIt sl = GetIt.instance;

// Call this before running the app
@InjectableInit()
Future<void> configureDependencies() async => sl.init();
