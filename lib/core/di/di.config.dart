// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chatapp/auth/controller/auth_controller.dart' as _i581;
import 'package:chatapp/auth/services/auth_service.dart' as _i909;
import 'package:chatapp/controller/app_controller.dart' as _i441;
import 'package:chatapp/core/firebase/firebase_initializer.dart' as _i618;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i909.AuthService>(() => _i909.AuthService());
    gh.lazySingleton<_i618.FirebaseInitializer>(
      () => _i618.FirebaseInitializer(),
    );
    gh.singleton<_i581.AuthController>(
      () => _i581.AuthController(
        gh<_i909.AuthService>(),
        gh<_i618.FirebaseInitializer>(),
      ),
    );
    gh.singleton<_i441.AppController>(
      () => _i441.AppController(gh<_i618.FirebaseInitializer>()),
    );
    return this;
  }
}
