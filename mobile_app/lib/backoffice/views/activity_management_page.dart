import 'package:flutter/material.dart';
import '../services/admin_activity_service.dart';
import '../models/admin_activity_model.dart';
import '../models/admin_category_model.dart';
// N'oubliez pas de vérifier le chemin vers votre fichier de thème
import '../../ui/theme.dart'; 

class ActivityManagementPage extends StatefulWidget {
  const ActivityManagementPage({super.key});

  @override
  State<ActivityManagementPage> createState() => _ActivityManagementPageState();
}

class _ActivityManagementPageState extends State<ActivityManagementPage> {
  final AdminActivityService _activityService = AdminActivityService();
  
  late Future<List<AdminActivity>> _activitiesFuture;
  List<AdminCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Charge les catégories d'abord, puis rafraîchit la liste des activités
  Future<void> _loadInitialData() async {
    try {
      final cats = await _activityService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur catégories : $e'), backgroundColor: Colors.red),
        );
      }
    }
    _refresh();
  }

  void _refresh() => setState(() { _activitiesFuture = _activityService.fetchActivities(); });

  void _showActivityDialog({AdminActivity? activity}) {
    final isEditing = activity != null;
    final formKey = GlobalKey<FormState>();
    
    final titleCtrl = TextEditingController(text: isEditing ? activity.title : "");
    final descCtrl = TextEditingController(text: isEditing ? activity.shortDescription : "");
    final contentCtrl = TextEditingController(text: isEditing ? activity.content : "");
    final urlCtrl = TextEditingController(text: isEditing ? activity.activityUrl : "");
    final imgCtrl = TextEditingController(text: isEditing ? activity.imageUrl : "");
    
    // Détermine la catégorie sélectionnée par défaut
    int? selectedCat = isEditing 
        ? activity.idCategory 
        : (_categories.isNotEmpty ? _categories.first.id : null);
        
    int currentUserId = isEditing ? activity.idUtilisateur : 1; // ID admin par défaut

    showDialog(
      context: context,
      barrierDismissible: false, // Force l'utilisateur à cliquer sur Annuler ou Valider
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          isEditing ? "Modifier l'activité" : "Nouvelle activité",
          style: AppTextStyles.titleStyleH2.copyWith(color: AppColors.tropicalTeal),
        ),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleCtrl, 
                    decoration: const InputDecoration(labelText: "Titre *"),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est requis' : null,
                  ),
                  TextFormField(
                    controller: descCtrl, 
                    decoration: const InputDecoration(labelText: "Description courte *"),
                    validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est requis' : null,
                  ),
                  TextFormField(
                    controller: contentCtrl, 
                    decoration: const InputDecoration(labelText: "Contenu"), 
                    maxLines: 3
                  ),
                  TextFormField(
                    controller: urlCtrl, 
                    decoration: const InputDecoration(labelText: "URL de l'activité (Optionnel)"),
                  ),
                  TextFormField(
                    controller: imgCtrl, 
                    decoration: const InputDecoration(labelText: "URL de l'image (Optionnel)"),
                  ),
                  const SizedBox(height: 16),
                  
                  // Menu déroulant dynamique
                  DropdownButtonFormField<int>(
                    value: selectedCat,
                    decoration: const InputDecoration(labelText: "Catégorie *"),
                    validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
                    items: _categories.map((cat) {
                      return DropdownMenuItem<int>(
                        value: cat.id,
                        child: Text(cat.title),
                      );
                    }).toList(),
                    onChanged: (v) => selectedCat = v,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          // BOUTON SUPPRIMER (Uniquement en mode édition)
          if (isEditing)
            TextButton(
              onPressed: () {
                // Popup de confirmation avant de supprimer
                showDialog(
                  context: dialogContext,
                  builder: (confirmContext) => AlertDialog(
                    title: const Text("Supprimer l'activité ?"),
                    content: const Text("Cette action est irréversible. Voulez-vous continuer ?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(confirmContext),
                        child: const Text("Annuler"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          try {
                            await _activityService.deleteActivity(activity.id!);
                            if (mounted) {
                              Navigator.pop(confirmContext); // Ferme la confirmation
                              Navigator.pop(dialogContext); // Ferme le formulaire principal
                              _refresh(); // Met à jour la liste
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Activité supprimée avec succès'), backgroundColor: Colors.green),
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
                        child: const Text("Supprimer", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),

          // BOUTON ANNULER
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: Text("Annuler", style: TextStyle(color: Colors.grey[600])),
          ),

          // BOUTON VALIDER
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkCyan),
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedCat != null) {
                final data = AdminActivity(
                  id: isEditing ? activity.id : null,
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                  activityUrl: urlCtrl.text,
                  imageUrl: imgCtrl.text,
                  shortDescription: descCtrl.text,
                  idCategory: selectedCat!,
                  idUtilisateur: currentUserId,
                  estActive: isEditing ? activity.estActive : true,
                );

                try {
                  if (isEditing) {
                    await _activityService.updateActivity(activity.id!, data);
                  } else {
                    await _activityService.createActivity(data);
                  }
                  if (mounted) {
                    Navigator.pop(dialogContext);
                    _refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Activité enregistrée avec succès'), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                   if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                    );
                   }
                }
              }
            },
            child: const Text("Valider", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Gestion des Activités", style: AppTextStyles.titleStyleH2.copyWith(color: AppColors.tropicalTeal)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.skyBlue),
              onPressed: () => _showActivityDialog(), 
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Nouvelle", style: TextStyle(color: Colors.white)),
            ),
          ),
          IconButton(icon: Icon(Icons.refresh, color: AppColors.tropicalTeal), onPressed: _refresh),
        ],
      ),
      body: FutureBuilder<List<AdminActivity>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: AppColors.darkCyan));
          if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Aucune activité trouvée."));
          
          final acts = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: acts.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, i) => ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text(acts[i].title, style: AppTextStyles.textStyleBig),
              subtitle: Text(acts[i].shortDescription, style: AppTextStyles.textStyleRegularBackground),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: acts[i].estActive,
                    activeColor: AppColors.darkCyan,
                    onChanged: (v) async {
                      try {
                        await _activityService.toggleStatus(acts[i].id!, v);
                        _refresh();
                      } catch (e) {
                         if (mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
                          );
                         }
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: AppColors.skyBlue), 
                    onPressed: () => _showActivityDialog(activity: acts[i])
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}