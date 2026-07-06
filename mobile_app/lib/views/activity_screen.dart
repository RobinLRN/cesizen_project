import 'package:flutter/material.dart';
import '../ui/widgets/widgets.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';
import '../services/category_service.dart';
import '../views/category_screen.dart';
import '../models/activity_category.dart';
import 'activity_detail_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final ActivityService _activityService = ActivityService();
  final CategoryService _categoryService=CategoryService();
  late Future<Map<String, dynamic>> _screenDataFuture;  
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _screenDataFuture = _loadScreenData();
  }

  Future<Map<String, dynamic>> _loadScreenData() async {
    final results = await Future.wait([
      _activityService.getActivities(),
      _categoryService.getCategories(),
    ]);

    return {
      'activities': results[0],
      'categories': results[1],
    };
  }

  //fonction pour les icônes
 IconData _getIconFromString(String? iconName) {
    switch (iconName) {
      case 'sports_basketball': return Icons.sports_basketball;
      case 'brightness_high': return Icons.brightness_high;
      case 'medical_services': return Icons.medical_services;
      case 'self_improvement': return Icons.self_improvement;
      case 'hourglass_bottom': return Icons.hourglass_bottom;
      default: return Icons.category;
    }
  }

  // Fonction de couleurs
  Color _getColorFromTitle(String title) {
    switch (title) {
      case 'Sport': return const Color(0xFF65B9D0);
      case 'Stress': return const Color(0xFF6FB9AE);
      case 'Santé': return const Color(0xFF558E85);
      case 'Méditation': return const Color(0xFFF1D483);
      case 'Anxiété': return const Color(0xFFB1AD85);
      default: return AppColors.drySage; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: const CustomFullAppBar(title: 'Activités'),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _screenDataFuture,
        builder: (context, snapshot) { 
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: AppColors.tropicalTeal));
          }
          if(snapshot.hasError){
            return const Center(child: Text('Une erreur est survenue lors du chargement'));
          }
          if(!snapshot.hasData){
            return const Center(child: Text('Aucune donnée disponible'));
          }
          
          final allActivities = snapshot.data!['activities'] as List<Activity>;
          final allCategories = snapshot.data!['categories'] as List<ActivityCategory>;
          
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
                       onPressed: () async {
                        final categorySelected = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen()),
                        );

                        if(categorySelected != null) {
                          setState(() {
                            _selectedCategory = categorySelected as String;
                          });
                        }
                       },
                       child: Text(
                        'Voir tout',
                       style: TextStyle(color: AppColors.softPeach, fontWeight: FontWeight.w700),
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
                    itemCount: allCategories.length,
                    itemBuilder: (context, catIndex) {
                      final category = allCategories[catIndex];
                      return CategoryPill(
                        title: category.title,
                        icon: _getIconFromString(category.iconName),
                        // On applique la logique de couleur ici
                        color: _getColorFromTitle(category.title),
                        isSelected: _selectedCategory == category.title,
                        onTap: () {
                          setState(() {
                            if (_selectedCategory == category.title) {
                              _selectedCategory = null;
                            } else {
                              _selectedCategory = category.title;
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
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: Text('Activités', style: Theme.of(context).textTheme.headlineMedium),
                );
              }
              
              final activity = filteredActivities[index - 3];
              return ActivityCard(
                activity: activity,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailScreen(activity: activity),
                    ),
                  );
                },
              );
            },
          );
        }
      ),
    );
  }
}