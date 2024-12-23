import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUpUseCase {
  final UserRepository _repository;

  SignUpUseCase(this._repository);

  Future<void> execute(String email, String password) async {
    final user = User(email: email, password: password);
    await _repository.signUp(user);
  }
}