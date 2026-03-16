import 'package:flutter/material.dart';
import '../ui/widgets/widgets.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';
import '../views/category_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityService _activityService = ActivityService();
  late Future<List<Activity>> _activitiesFuture;
  
  String? _selectedCategory;

  // catégories temporaires en dur
  final List<Map<String, dynamic>> _categories = [
    {'title': 'Sport', 'icon': Icons.sports_basketball, 'color': const Color(0xFF65B9D0)},
    {'title': 'Stress', 'icon': Icons.brightness_high, 'color': const Color(0xFF6FB9AE)},
    {'title': 'Santé', 'icon': Icons.medical_services, 'color': const Color(0xFF558E85)},
    {'title': 'Méditation', 'icon': Icons.self_improvement, 'color': const Color(0xFFF1D483)},
    {'title': 'Anxiété', 'icon': Icons.hourglass_bottom, 'color': const Color(0xFFB1AD85)},
  ];

  @override
  void initState() {
    super.initState();
    _activitiesFuture = _activityService.getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: const CustomFullAppBar(
        title: 'Activité',
      ),
      body: FutureBuilder<List<Activity>>(
        future: _activitiesFuture,
        builder: (context, snapshot) { 
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: AppColors.tropicalTeal));
          }
          if(snapshot.hasError){
            return const Center(child: Text('Une erreur est survenue'));
          }
          if(!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('Aucune activité disponible'));
          }
          
          final allActivities = snapshot.data!;
          
          // La fameuse étape 4 : la nouvelle condition de filtre
          final filteredActivities = _selectedCategory == null 
              ? allActivities 
              : allActivities.where((a) => a.categories.any((c) => c.title == _selectedCategory)).toList();
          
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: filteredActivities.length + 3,
            itemBuilder: (context, index) {
              
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Catégories', style: Theme.of(context).textTheme.headlineMedium),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (context) => CategoryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Voir tout',
                          style: TextStyle(color: AppColors.tropicalTeal, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              if (index == 1) {
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, catIndex) {
                      final category = _categories[catIndex];
                      return CategoryPill(
                        title: category['title'],
                        icon: category['icon'],
                        color: category['color'],
                        isSelected: _selectedCategory == category['title'],
                        onTap: () {
                          setState(() {
                            if (_selectedCategory == category['title']) {
                              _selectedCategory = null;
                            } else {
                              _selectedCategory = category['title'];
                            }
                          });
                        },
                      );
                    },
                  ),
                );
              }

              if (index == 2) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 40),
                  child: Text('Activités', style: Theme.of(context).textTheme.headlineMedium),
                );
              }
              
              final activity = filteredActivities[index - 3];
              return ActivityCard(
                activity: activity,
                onTap: () {
                  print('Clic sur ${activity.title}');
                },
              );
            },
          );
        }
      ),
    );
  }
}