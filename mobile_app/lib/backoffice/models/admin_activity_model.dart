class AdminActivity {
  final int? id;
  final String title;
  final String content;
  final String shortDescription;
  final String activityUrl;
  final String imageUrl;
  final int idCategory;
  final int idUtilisateur;
  final bool estActive;

  AdminActivity({
    this.id,
    required this.title,
    required this.content,
    required this.shortDescription,
    required this.activityUrl,
    required this.imageUrl,
    required this.idCategory,
    required this.idUtilisateur,
    this.estActive = true,
  });

  factory AdminActivity.fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] as List? ?? [];
    final firstCategory = categories.isNotEmpty ? categories[0] : null;
    return AdminActivity(
      id: json['id_activity'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      shortDescription: json['short_description'] ?? '',
      activityUrl: json['activity_url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      idCategory: firstCategory?['id_category'] ?? 1,
      idUtilisateur: json['id_utilisateur'] ?? 1,
      estActive: json['est_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'short_description': shortDescription,
      'activity_url': activityUrl,
      'image_url': imageUrl,
      'id_category': idCategory,
      'id_utilisateur': idUtilisateur,
      // On n'envoie pas l'ID ni le statut lors de la création
    };
  }
}
