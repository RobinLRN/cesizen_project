import 'package:flutter/material.dart';
import '../services/admin_user_service.dart';
import '../models/user_model.dart'; // Ajustez le chemin si nécessaire
import '../../ui/theme.dart'; // Import de votre thème

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AdminUserService _userService = AdminUserService();
  late Future<List<AdminUser>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _userService.fetchUsers();
  }

  void _refresh() => setState(() { _usersFuture = _userService.fetchUsers(); });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Même fond que les activités
      appBar: AppBar(
        title: Text("Gestion des Utilisateurs", style: AppTextStyles.titleStyleH2.copyWith(color: AppColors.tropicalTeal)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: AppColors.tropicalTeal), onPressed: _refresh),
        ],
      ),
      body: FutureBuilder<List<AdminUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: AppColors.darkCyan));
          if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Aucun utilisateur trouvé."));

          final users = snapshot.data!;
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Permet de scroller si l'écran est petit
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                    headingTextStyle: AppTextStyles.textStyleBig.copyWith(color: AppColors.darkCyan),
                    dataTextStyle: AppTextStyles.textStyleRegular,
                    columns: const [
                      DataColumn(label: Text('Pseudo')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Rôle')),
                      DataColumn(label: Text('Actif')),
                    ],
                    rows: users.map<DataRow>((user) => DataRow(
                      cells: [
                        DataCell(Text(user.pseudo, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(user.email)),
                        DataCell(
                          // Dropdown pour changer le rôle directement
                          DropdownButton<int>(
                            value: user.idRole,
                            underline: Container(), // Enlève la ligne moche sous le dropdown
                            items: const [
                              DropdownMenuItem(value: 1, child: Text("Admin")), 
                              DropdownMenuItem(value: 2, child: Text("User"))
                            ],
                            onChanged: (val) async {
                              if (val != null && val != user.idRole) {
                                try {
                                  await _userService.updateRole(user.id, val);
                                  _refresh();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Rôle mis à jour'), backgroundColor: Colors.green),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              }
                            },
                          )
                        ),
                        DataCell(
                          // Switch pour activer/désactiver
                          Switch(
                            value: user.estActif,
                            activeColor: AppColors.darkCyan,
                            onChanged: (val) async {
                              try {
                                await _userService.toggleStatus(user.id, val);
                                _refresh();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(val ? 'Utilisateur activé' : 'Utilisateur désactivé'), backgroundColor: Colors.green),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                                  );
                                }
                              }
                            },
                          )
                        ),
                      ]
                    )).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}