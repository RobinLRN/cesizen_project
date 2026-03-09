class Activity {
  final int idActivity;
  final String title;
  final String content;
  final String activityType;
  final DateTime activityDate;
  final String? activityUrl;
  final int idUtilisateur;
  final String? imageUrl; 
  final String? shortDescription; 

  Activity({
    required this.idActivity,
    required this.title,
    required this.content,
    required this.activityType,
    required this.activityDate,
    this.activityUrl,
    required this.idUtilisateur,
    this.imageUrl,
    this.shortDescription,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['id_activity'],
      title: json['title'],
      content: json['content'],
      activityType: json['activity_type'],
      activityDate: DateTime.parse(json['activity_date']),
      activityUrl: json['activity_url'],
      idUtilisateur: json['id_utilisateur'],
      imageUrl: json['image_url'],
      shortDescription: json['short_description'], 
    );
  }
}