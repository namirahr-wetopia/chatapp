import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kUserJson = 'user_json';
  static const _kTokenSavedAt = 'token_saved_at'; // optional timestamp

  Future<void> writeAccessToken(String token) => _storage.write(key: _kAccessToken, value: token);
  Future<void> writeRefreshToken(String token) => _storage.write(key: _kRefreshToken, value: token);
  Future<void> writeUserJson(String json) => _storage.write(key: _kUserJson, value: json);
  Future<void> writeTokenSavedAt(String iso) => _storage.write(key: _kTokenSavedAt, value: iso);

  Future<String?> readAccessToken() => _storage.read(key: _kAccessToken);
  Future<String?> readRefreshToken() => _storage.read(key: _kRefreshToken);
  Future<String?> readUserJson() => _storage.read(key: _kUserJson);
  Future<String?> readTokenSavedAt() => _storage.read(key: _kTokenSavedAt);

  Future<void> deleteAll() => _storage.deleteAll();
}
