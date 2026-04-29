import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('${Config.apiBaseUrl}/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      //print('Code de retour : ${response.statusCode}');
      //print('Message du serveur : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // On sauvegarde le token dans le stockage sécurisé
        await storage.write(key: 'jwt_token', value: data['token']);
        //On sauvegarde l'ID utilisateur
        await storage.write(key: 'userId', value: data['user']['id'].toString());
        //On sauvegarde le pseudo de l'utilisateur
        await storage.write(key: 'pseudo', value: data['user']['pseudo']);
        return true;
      }
    } catch (e) {
      //print('Error occurred while logging in: $e');
    }
    return false;
  }

// fonction pour récupérer le pseudo de l'utilisateur
  Future<String?> getPseudo() async {
  return await storage.read(key: 'pseudo');
}

  // Fonction pour récupérer le token JWT depuis le stockage sécurisé
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  // Deconnexion
  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    await storage.delete(key: 'userId');
    await storage.delete(key: 'pseudo'); 
  }

  Future<String?> register(String pseudo, String email, String password) async {
    final url = Uri.parse('${Config.apiBaseUrl}/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pseudo': pseudo,
          'email': email,
          'password': password,
        }),
      );

      // Si c'est un succès (200 ou 201), on renvoie null (tout va bien)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      }

      // En cas d'erreur API, on renvoie le statut et la réponse exacte de Node.js
      return 'Erreur ${response.statusCode} : ${response.body}';
    } catch (e) {
      // En cas de problème de connexion (serveur éteint, mauvaise URL...)
      return 'Erreur de connexion : $e';
    }
  }
}
