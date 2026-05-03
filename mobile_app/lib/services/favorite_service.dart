import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteService {
  final String baseUrl = 'http://10.0.2.2:3000/api/favorite';
  final http.Client _client; // ← ajoute

  FavoriteService({http.Client? client})
    : _client = client ?? http.Client(); // ← ajoute

  Future<bool> checkIsFavorite(int userId, int activityId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/check?id_utilisateur=$userId&id_activity=$activityId',
      );
      final response = await _client.get(url); // ← _client.get
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleFavorite(int userId, int activityId) async {
    try {
      final url = Uri.parse('$baseUrl/toggle');
      final response = await _client.post(
        // ← _client.post
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_utilisateur': userId, 'id_activity': activityId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
