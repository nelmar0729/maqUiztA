// auth_service.dart
import 'package:jwt_decode/jwt_decode.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '../usecases/is_enrolled.dart';

class AuthService {
  final LocalAuthDataSource localAuth;
  final Isenrolled isenrolled;

  AuthService(this.localAuth, this.isenrolled);

  Future<AuthResult> checkAuthStatus() async {
    final userId = await localAuth.getUserId();
    final token = await localAuth.getToken();
    final enrolled = await isenrolled(userId ?? "");

    if (token != null && token.isNotEmpty && !Jwt.isExpired(token)) {
      if (enrolled.success) {
        return AuthResult(status: AuthStatus.enrolled);
      } else {
        return AuthResult(status: AuthStatus.notProfiled);
      }
    } else {
      return AuthResult(status: AuthStatus.notLoggedIn);
    }
  }
}

enum AuthStatus { enrolled, notProfiled, notLoggedIn }

class AuthResult {
  final AuthStatus status;
  AuthResult({required this.status});
}
