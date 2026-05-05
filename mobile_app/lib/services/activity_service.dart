import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/activity.dart';

class ActivityService {
  Future<List<Activity>> getActivities() async {
    final url = Uri.parse('${Config.apiBaseUrl}/activities?active=true');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        List<Activity> activities = body
            .map((dynamic item) => Activity.fromJson(item))
            .toList();

        return activities;
      } else {
        print('Erreur récupération : ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
    return [];
  }
}
