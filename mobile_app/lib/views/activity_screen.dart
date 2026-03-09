import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class ActivityScreen extends StatefulWidget{
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  //Service qui va aller chercher les activités depuis l'API
  final ActivityService _activityService = ActivityService();
  //Stocker nos activités
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    //Requête vers le serveur dès que la page s'ouvre
    super.initState();
    _activitiesFuture = _activityService.getActivities();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const CustomLogoAppBar(),
      body: PageLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Nos activités', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            
            // L'Expanded fonctionne maintenant parfaitement car le PageLayout ne force plus un défilement
            Expanded(
              child: FutureBuilder<List<Activity>>(
                future: _activitiesFuture,
                builder: (context, snapshot) { 
                  //Indicateur pendant le chargement
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.tropicalTeal,
                      ),
                    );
                  }
                  //Si le serveur renvoie une erreur
                  if(snapshot.hasError){
                    return const Center(
                      child: Text('Une erreur est survenue'),
                    );
                  }
                  //Si la DB est vide 
                  if(!snapshot.hasData || snapshot.data!.isEmpty){
                    return Center(
                      child: Text(
                        'Aucune activité disponible', 
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  //succès
                  final activities = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: activities.length,
                    itemBuilder: (context, index){
                      final activity = activities[index];
                      return ActivityCard(
                        activity: activity,
                        onTap: () {
                          print('Clic sur ${activity.title}');
                        },
                      );
                    },
                  );
                }
              )
            )
          ],
        )
      ),
    );
  }
}