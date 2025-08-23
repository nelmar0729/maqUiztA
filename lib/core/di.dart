import 'package:get_it/get_it.dart';

// --- Import all dependencies you want to inject ---
// Data sources
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';

// Repository
import '/features/auth/data/repositories/auth_repository_impl.dart';

// Use cases
import '../features/auth/domain/usecases/is_enrolled.dart';

// Services
import '/features/auth/domain/services/auth_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register Data Sources
  locator.registerLazySingleton<LocalAuthDataSource>(
    () => LocalAuthDataSource(),
  );
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // 2. Register Repository
  locator.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(locator<AuthRemoteDataSource>()),
  );

  // 3. Register Use Cases
  locator.registerLazySingleton<Isenrolled>(
    () => Isenrolled(locator<AuthRepositoryImpl>()),
  );

  // 4. Register Services
  locator.registerLazySingleton<AuthService>(
    () => AuthService(locator<LocalAuthDataSource>(), locator<Isenrolled>()),
  );
}
