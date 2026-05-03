import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteService {
  final String baseUrl = 'http://10.0.2.2:3000/api/favorite';

  //Vérifier si l'activité est en favoris
  Future<bool>  checkIsFavorite(int userId, int activityId) async {
    try {
      final url = Uri.parse('$baseUrl/check?id_utilisateur=$userId&id_activity=$activityId');
      final response = await http.get(url);

      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    }catch (e){
      print('erreur de vérification des favoris: $e');
      return false;
    }
  }
//Ajouter/retirer favoris
  Future<bool> toggleFavorite(int userId, int activityId) async {
    try{
      final url = Uri.parse('$baseUrl/toggle');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_utilisateur': userId,
          'id_activity': activityId,
        }),
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      }
      return false;
    }catch (e){
      print('erreur lors du chargement des favoris: $e');
      return false;
    }
  }
}