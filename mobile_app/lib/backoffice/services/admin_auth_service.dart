import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config.dart';

class AdminAuthService {
  static const _key = 'admin_token';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.apiBaseUrl}/auth/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await const FlutterSecureStorage().write(key: _key, value: token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final token = await const FlutterSecureStorage().read(key: _key);
      return token != null;
    } catch (_) {
      return false;
    }
  }

  static Future<void> logout() async {
    await const FlutterSecureStorage().delete(key: _key);
  }
}