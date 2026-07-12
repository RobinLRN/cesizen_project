import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';
import '../models/question.dart';

class DiagnosticService {
  String get baseUrl => '${Config.apiBaseUrl}/diagnostic';
  final _storage = const FlutterSecureStorage();

  // Récupérer toutes les questions
  Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/questions'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Question.fromJson(item)).toList();
      } else {
        throw Exception("Échec du chargement des questions");
      }
    } catch (e) {
      print("Erreur DiagnosticService (fetch): $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchConfig() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/config'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      print('Erreur fetchConfig: $e');
      return [];
    }
  }

  Future<bool> updateConfig(int id, String titre, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/config/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'titre': titre, 'description': description}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur updateConfig: $e');
      return false;
    }
  }

  // Enregistrer le score final
  Future<bool> saveResult(int score) async {
    try {
      String? userIdStr = await _storage.read(key: 'userId');
      if (userIdStr == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/save'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_utilisateur': int.parse(userIdStr),
          'score': score,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Erreur DiagnosticService (save): $e");
      return false;
    }
  }
}
