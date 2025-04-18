import 'package:health_med_app/main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> estaLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<String?> obterIdUsuario() async {
    final token = await obterToken();
    if (token == null || token.isEmpty) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['customId']?.toString();
  }
}
