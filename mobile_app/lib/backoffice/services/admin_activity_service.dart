import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_activity_model.dart';
import '../models/admin_category_model.dart';
import '../../config.dart';

class AdminActivityService {
  final String baseUrl = "http://localhost:3000/api/activities";

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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(activity.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur lors de la création : ${response.body}');
    }
  }

  Future<void> updateActivity(int id, AdminActivity activity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(activity.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la modification');
    }
  }

  Future<void> toggleStatus(int id, bool newStatus) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/status'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"est_active": newStatus}),
    );
    if (response.statusCode != 200) {
      throw Exception('Erreur lors du changement de statut');
    }
  }

  Future<List<AdminCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse("http://localhost:3000/api/categories")); 
    
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
      headers: {"Content-Type": "application/json"},
    );
    // 200 (OK) ou 204 (No Content) sont les codes habituels pour une suppression réussie
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression');
    }
  }
}