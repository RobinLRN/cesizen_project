import 'activity_category.dart';

class Activity {
  final int idActivity;
  final String title;
  final String content;
  final String? coverImgLink; 
  final DateTime activityDate;
  final String? activityUrl;
  final int idUtilisateur;
  final String? imageUrl; 
  final String? shortDescription; 
  final List<ActivityCategory> categories; 

  Activity({
    required this.idActivity,
    required this.title,
    required this.content,
    this.coverImgLink,
    required this.activityDate,
    this.activityUrl,
    required this.idUtilisateur,
    this.imageUrl,
    this.shortDescription,
    required this.categories,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    // On extrait la liste brute, ou on met une liste vide par défaut si elle n'existe pas
    var list = json['categories'] as List? ?? [];
    // On traduit chaque élément de la liste avec le modèle Category
    List<ActivityCategory> categoriesList = list.map((i) => ActivityCategory.fromJson(i)).toList();

    return Activity(
      idActivity: json['id_activity'],
      title: json['title'],
      content: json['content'],
      coverImgLink: json['cover_img_link'],
      activityDate: DateTime.parse(json['activity_date']),
      activityUrl: json['activity_url'],
      idUtilisateur: json['id_utilisateur'],
      imageUrl: json['image_url'], 
      shortDescription: json['short_description'], 
      categories: categoriesList,
    );
  }
}