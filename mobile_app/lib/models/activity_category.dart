class ActivityCategory {
  final int idCategory;
  final String title;
  final String? iconName;
  final String? colorCode;

  ActivityCategory({
    required this.idCategory,
    required this.title,
    this.iconName,
    this.colorCode,
  });

  factory ActivityCategory.fromJson(Map<String, dynamic> json) {
    return ActivityCategory(
      idCategory: json['id_category'],
      title: json['title'],
      iconName: json['icon_name'],
      colorCode: json['color_code'],
    );
  }
}