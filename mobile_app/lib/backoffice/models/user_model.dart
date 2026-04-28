class AdminUser {
  final int id;
  final String pseudo;
  final String email;
  int idRole;
  bool estActif;

  AdminUser({
    required this.id,
    required this.pseudo,
    required this.email,
    required this.idRole,
    required this.estActif,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id_utilisateur'],
      pseudo: json['pseudo'],
      email: json['email'],
      idRole: json['id_role'],
      estActif: json['est_actif'] ?? true,
    );
  }
}