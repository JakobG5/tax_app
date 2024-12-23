import 'package:hive/hive.dart';

abstract class UserLocalStorage {
  Future<void> saveUserCredentials(String email, String password);
  Future<Map<String, dynamic>?> getUserCredentials();
}

class HiveUserStorage implements UserLocalStorage {
  final Box _userBox;
  static const String _credentialsKey = 'user_credentials';

  HiveUserStorage(this._userBox);

  @override
  Future<void> saveUserCredentials(String email, String password) async {
    await _userBox.put(_credentialsKey, {
      'email': email,
      'password': password,
    });
  }

  @override
  Future<Map<String, dynamic>?> getUserCredentials() async {
    return _userBox.get(_credentialsKey);
  }
}