import 'package:dartz/dartz.dart';
import '../entities/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  });
} 