import 'package:flutter_test/flutter_test.dart';
import 'package:cesizen/models/activity.dart';

void main() {
  group('Activity Model - Tests de Non-Régression', () {
    
    test('Doit créer une Activity même si des champs optionnels sont null', () {
      // Préparation : Un faux JSON avec plein de "null" pour reproduire le bug
      final jsonPauvre = {
        'id_activity': 10,
        'title': 'Test de survie',
        'content': 'Contenu',
        'activity_date': null, 
        'cover_img_link': null,
        'categories': null, 
      };

      // On tente de convertir
      final activity = Activity.fromJson(jsonPauvre);

      // L'objet a été créé sans crasher 
      expect(activity.idActivity, 10);
      expect(activity.title, 'Test de survie');
      expect(activity.categories, isEmpty); 
      expect(activity.activityDate, isNotNull); 
    });

  });
}