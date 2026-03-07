class Activity {
  final int idActivity;
  final String title;
  final String content;
  final String activityType;
  final String coverImgLink;
  final DateTime activityDate;
  final String? ActivityUrl;
  final int idUtilisateur;

  Activity({
    required this.idActivity,
    required this.title,
    required this.content,
    required this.activityType,
    required this.activityDate,
    this.ActivityUrl,
    required this.idUtilisateur,
    required this.coverImgLink,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['id_activity'],
      title: json['title'],
      content: json['content'],
      activityType: json['activity_type'],
      activityDate: DateTime.parse(json['activity_date']),
      ActivityUrl: json['activity_url'],
      idUtilisateur: json['id_utilisateur'],
      coverImgLink: json['cover_img_link'],
    );
  }
}
