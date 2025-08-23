import 'package:auto_route/auto_route.dart';
import 'app_router.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthGuard extends AutoRouteGuard {
  final LocalAuthDataSource localAuth;

  AuthGuard(this.localAuth);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isLoggedIn = await checkIsLoggedIn();
    if (isLoggedIn) {
      resolver.next(true);
    } else {
      router.replace(const LoginRoute());
    }
  }

  Future<bool> checkIsLoggedIn() async {
    final token = await localAuth.getToken();
    return token != null && token.isNotEmpty && !Jwt.isExpired(token);
  }
}
