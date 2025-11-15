// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:wetopian_auth/core/network/network_module.dart' as _i623;
import 'package:wetopian_auth/core/secure_storage/secure_storage_service.dart'
    as _i501;
import 'package:wetopian_auth/features/auth/controllers/login_controller.dart'
    as _i766;
import 'package:wetopian_auth/features/auth/controllers/request_reset_password_controller.dart'
    as _i244;
import 'package:wetopian_auth/features/auth/controllers/reset_password_controller.dart'
    as _i282;
import 'package:wetopian_auth/features/auth/controllers/signup_controller.dart'
    as _i640;
import 'package:wetopian_auth/features/auth/controllers/verify_contact_controller.dart'
    as _i126;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i519.Client>(() => networkModule.createHttpClient());
    gh.lazySingleton<_i501.SecureStorageService>(
        () => _i501.SecureStorageService());
    gh.factory<_i766.LoginController>(() => _i766.LoginController(
          gh<_i519.Client>(),
          gh<_i501.SecureStorageService>(),
        ));
    gh.factory<_i244.RequestResetController>(
        () => _i244.RequestResetController(gh<_i519.Client>()));
    gh.factory<_i282.ResetPasswordController>(
        () => _i282.ResetPasswordController(gh<_i519.Client>()));
    gh.factory<_i640.SignUpController>(
        () => _i640.SignUpController(gh<_i519.Client>()));
    gh.factory<_i126.VerifyContactController>(
        () => _i126.VerifyContactController(gh<_i519.Client>()));
    return this;
  }
}

class _$NetworkModule extends _i623.NetworkModule {}
