import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/question.dart';

class DiagnosticService {
  final String baseUrl = "http://10.0.2.2:3000/api/diagnostic";
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
