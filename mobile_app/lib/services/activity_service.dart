import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'auth_service.dart';

class ActivityService {
  Future<List<dynamic>> fetchActivities() async {
    final token = await AuthService().getToken();
    final url = Uri.parse('${Config.apiBaseUrl}/activities');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
    return [];
  }
}
