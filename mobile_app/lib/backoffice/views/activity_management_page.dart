import 'package:flutter/material.dart';
import '../services/admin_activity_service.dart';
import '../models/admin_activity_model.dart';
import '../../ui/theme.dart'; 

class ActivityManagementPage extends StatefulWidget {
  const ActivityManagementPage({super.key});

  @override
  State<ActivityManagementPage> createState() => _ActivityManagementPageState();
}

class _ActivityManagementPageState extends State<ActivityManagementPage> {
  final AdminActivityService _activityService = AdminActivityService();
  late Future<List<AdminActivity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = _activityService.fetchActivities();
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
    
    int selectedCat = isEditing ? activity.idCategory : 1;
    int currentUserId = isEditing ? activity.idUtilisateur : 1; // Simulation de l'utilisateur connecté

    showDialog(
      context: context,
      barrierDismissible: false, // Force l'utilisateur à utiliser les boutons pour fermer
      builder: (context) => AlertDialog(
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
                    validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  TextFormField(
                    controller: descCtrl, 
                    decoration: const InputDecoration(labelText: "Description courte *"),
                    validator: (value) => value == null || value.isEmpty ? 'Ce champ est requis' : null,
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
                  DropdownButtonFormField<int>(
                    value: selectedCat,
                    decoration: const InputDecoration(labelText: "Catégorie *"),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Stress")),
                      DropdownMenuItem(value: 2, child: Text("Sport")),
                      DropdownMenuItem(value: 3, child: Text("Méditation")),
                    ],
                    onChanged: (v) => selectedCat = v!,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Annuler", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkCyan),
            onPressed: () async {
              if (formKey.currentState!.validate()) { // Validation "Blindée"
                final data = AdminActivity(
                  id: isEditing ? activity.id : null,
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                  activityUrl: urlCtrl.text,
                  imageUrl: imgCtrl.text,
                  shortDescription: descCtrl.text,
                  idCategory: selectedCat,
                  idUtilisateur: currentUserId, // On inclut l'ID utilisateur
                );

                try {
                  if (isEditing) {
                    await _activityService.updateActivity(activity.id!, data);
                  } else {
                    await _activityService.createActivity(data);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    _refresh();
                  }
                } catch (e) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur serveur : $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                  );
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
                      await _activityService.toggleStatus(acts[i].id!, v);
                      _refresh();
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