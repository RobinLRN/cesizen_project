import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class SupportService {
  final http.Client _client;
  final FlutterSecureStorage _storage;

  SupportService({http.Client? client, FlutterSecureStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? const FlutterSecureStorage();

  // Envoie un signalement au backend, qui le transforme en ticket (issue GitHub).
  // Retourne null en cas de succès, un message d'erreur sinon.
  Future<String?> submitTicket({
    required String category,
    required String subject,
    required String description,
    String? email,
  }) async {
    final url = Uri.parse('${Config.apiBaseUrl}/support');
    try {
      // On identifie l'auteur du signalement s'il est connecté.
      final reporter = await _storage.read(key: 'pseudo');

      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'category': category,
          'subject': subject,
          'description': description,
          'email': email,
          'reporter': reporter,
        }),
      );

      if (response.statusCode == 201) return null;

      // On tente de récupérer le message d'erreur renvoyé par le backend.
      try {
        final data = jsonDecode(response.body);
        return data['error'] ?? 'Erreur ${response.statusCode}';
      } catch (_) {
        return 'Erreur ${response.statusCode}';
      }
    } catch (e) {
      return 'Erreur de connexion : $e';
    }
  }
}
