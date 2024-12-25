import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/domain/entities/user.dart';
import 'package:tax_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalStorage _localStorage;

  UserRepositoryImpl(this._localStorage);

  @override
  Future<void> signUp(User user) async {
    if (await _localStorage.isEmailTaken(user.email)) {
      throw Exception('Email is already registered');
    }
    await _localStorage.saveUserCredentials(user.email, user.password);
    await _localStorage.put('isSignedIn', true); // Set the isSignedIn flag
  }

  @override
  Future<User?> getUser() async {
    final userData = await _localStorage.getUserCredentials();
    if (userData != null) {
      return User(
        email: userData['email'],
        password: userData['password'],
      );
    }
    return null;
  }
}
