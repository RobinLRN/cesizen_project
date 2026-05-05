class AdminCategory {
  final int id;
  final String title;

  AdminCategory({required this.id, required this.title});

  factory AdminCategory.fromJson(Map<String, dynamic> json) {
    return AdminCategory(
      id: json['id_category'],
      title: json['title'] ?? json['nom_role'] ?? 'Sans nom',
    );
  }
}
