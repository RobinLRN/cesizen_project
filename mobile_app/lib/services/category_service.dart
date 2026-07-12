import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/activity_category.dart';

class CategoryService {
  String get baseUrl => '${Config.apiBaseUrl}/categories';

  Future<List<ActivityCategory>> getCategories() async {
    final url = Uri.parse(baseUrl);

    try{
      final response = await http.get(url);

      if(response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => ActivityCategory.fromJson(item)).toList();
      } else {
        print('Erreur serveur pour les catégories: ${response.statusCode}');
        return[];
      }
    } catch(e, stacktrace){
      print('Erreur de connexion pour les catégories : $e');
      print(stacktrace);
      return[];
    }
  }
}