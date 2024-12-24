import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../entities/failure.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
} 