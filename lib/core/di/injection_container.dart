import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:tax_app/data/datasources/local/user_local_storage.dart';
import 'package:tax_app/data/repositories/user_repository_impl.dart';
import 'package:tax_app/domain/repositories/user_repository.dart';
import 'package:tax_app/domain/usecases/sign_up_usecase.dart';
import 'package:tax_app/presentation/blocs/company/company_bloc.dart';
import 'package:tax_app/presentation/blocs/sign_up_bloc.dart';
import 'package:tax_app/presentation/blocs/login_bloc.dart';
import 'package:tax_app/presentation/blocs/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Hive
  final userBox = await Hive.openBox('user_box');

  // Data sources
  sl.registerLazySingleton<UserLocalStorage>(
    () => HiveUserStorage(userBox),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // Blocs
  sl.registerFactory(() => AuthBloc(userStorage: sl<UserLocalStorage>()));
  sl.registerFactory(() => SignUpBloc(
      userStorage: sl<UserLocalStorage>(), authBloc: sl<AuthBloc>()));
  sl.registerFactory(() =>
      LoginBloc(userStorage: sl<UserLocalStorage>(), authBloc: sl<AuthBloc>()));
  sl.registerFactory(() => CompanyBloc(userStorage: sl<UserLocalStorage>()));
}
