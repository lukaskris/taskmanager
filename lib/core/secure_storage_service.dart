import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _singleton =
      SecureStorageService._internal();

  factory SecureStorageService() => _singleton;

  SecureStorageService._internal(); // private constructor
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _userKey = 'USER';

  Future<void> saveUser(String userId) async {
    await _storage.write(key: _userKey, value: userId);
  }

  Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
