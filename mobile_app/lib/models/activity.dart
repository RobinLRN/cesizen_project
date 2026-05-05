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
    var list = json['categories'] as List? ?? [];
    List<ActivityCategory> categoriesList = list
        .map((i) => ActivityCategory.fromJson(i))
        .toList();
    String dateString = json['activity_date']?.toString() ?? "";
    DateTime parsedDate = DateTime.tryParse(dateString) ?? DateTime.now();

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
