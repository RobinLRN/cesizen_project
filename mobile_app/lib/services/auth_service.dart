import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class AuthService {
  final FlutterSecureStorage _storage; // ← plus de "final storage = const..."
  final http.Client _client;

  // ← les deux sont maintenant injectables
  AuthService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('${Config.apiBaseUrl}/auth/login');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'jwt_token', value: data['token']);
        await _storage.write(
          key: 'userId',
          value: data['user']['id'].toString(),
        );
        await _storage.write(key: 'pseudo', value: data['user']['pseudo']);
        return true;
      }
    } catch (e) {}
    return false;
  }

  Future<String?> getPseudo() async => await _storage.read(key: 'pseudo');
  Future<String?> getToken() async => await _storage.read(key: 'jwt_token');

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'pseudo');
  }

  Future<String?> register(String pseudo, String email, String password) async {
    final url = Uri.parse('${Config.apiBaseUrl}/auth/register');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pseudo': pseudo,
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) return null;
      return 'Erreur ${response.statusCode} : ${response.body}';
    } catch (e) {
      return 'Erreur de connexion : $e';
    }
  }
}
