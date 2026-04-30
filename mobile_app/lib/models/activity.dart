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
    // 1. Sécurisation de la liste des catégories
    var list = json['categories'] as List? ?? [];
    List<ActivityCategory> categoriesList = list.map((i) => ActivityCategory.fromJson(i)).toList();

    // 2. Sécurisation absolue de la date (le coupable de ton crash précédent !)
    // On force la conversion en String. Si c'est null, ça devient ""
    String dateString = json['activity_date']?.toString() ?? ""; 
    // tryParse ne crashera pas si c'est vide, il renverra juste null, qu'on remplace par DateTime.now()
    DateTime parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();

    // 3. Sécurisation de tous les champs obligatoires avec "?? valeur_par_défaut"
    return Activity(
      idActivity: json['id_activity'] ?? 0,
      title: json['title'] ?? 'Sans titre',
      content: json['content'] ?? '',
      coverImgLink: json['cover_img_link'],
      activityDate: parsedDate,
      activityUrl: json['activity_url'],
      idUtilisateur: json['id_utilisateur'] ?? 0,
      imageUrl: json['image_url'], 
      shortDescription: json['short_description'], 
      categories: categoriesList,
    );
  }
}