import 'package:dartz/dartz.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/failure.dart';
import '../datasources/local/user_local_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserLocalStorage localStorage;

  AuthRepositoryImpl(this.localStorage);

  @override
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final users = await localStorage.getAllUsers();
      final userExists = users.any(
          (user) => user['email'] == email && user['password'] == password);

      if (userExists) {
        return const Right(null);
      } else {
        return const Left(Failure('Invalid email or password'));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
