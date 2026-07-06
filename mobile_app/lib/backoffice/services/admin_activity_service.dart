import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/admin_activity_model.dart';
import '../models/admin_category_model.dart';
import '../../config.dart';

class AdminActivityService {
  String get baseUrl => '${Config.apiBaseUrl}/activities';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'admin_token');
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<List<AdminActivity>> fetchActivities() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => AdminActivity.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des activités');
    }
  }

  Future<void> createActivity(AdminActivity activity) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _authHeaders(),
      body: jsonEncode(activity.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur lors de la création : ${response.body}');
    }
  }

  Future<void> updateActivity(int id, AdminActivity activity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: await _authHeaders(),
      body: jsonEncode(activity.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }

  Future<void> toggleStatus(int id, bool newStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/status'),
      headers: await _authHeaders(),
      body: jsonEncode({"est_active": newStatus}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors du changement de statut');
    }
  }

  Future<List<AdminCategory>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}/categories'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => AdminCategory.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des catégories');
    }
  }

  Future<void> deleteActivity(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression');
    }
  }
}
