import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../config.dart';

class AdminUserService {
  String get baseUrl => '${Config.apiBaseUrl}/users';

  Future<List<AdminUser>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => AdminUser.fromJson(data)).toList();
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

  Future<void> toggleStatus(int id, bool newStatus) async {
    await http.patch(
      Uri.parse('$baseUrl/$id/status'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"est_actif": newStatus}),
    );
  }

  Future<void> updateRole(int id, int idRole) async {
    await http.put(
      Uri.parse('$baseUrl/$id/role'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id_role": idRole}),
    );
  }
}