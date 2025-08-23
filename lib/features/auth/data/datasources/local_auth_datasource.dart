import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LocalAuthDataSource {
  static const _tokenKey = 'jwt_token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    // Immediately read back for debug confirmation:
    prefs.getString(_tokenKey);
    
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<String?> getUserId() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    return payload['user_id']?.toString();
  }

  Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return null;
    Map<String, dynamic> payload = Jwt.parseJwt(token);
 
    return payload['role']?.toString();
  }
}
