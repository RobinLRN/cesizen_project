import 'package:flutter/material.dart';
import '../ui/widgets/category_card.dart';
import '../ui/theme.dart';
import '../models/activity_category.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<ActivityCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.getCategories();
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

  // fonction pour les couleurs
  Color _getColorFromTitle(String title) {
    switch (title) {
      case 'Sport': return AppColors.skyBlue;
      case 'Stress': return AppColors.tropicalTeal;
      case 'Santé': return AppColors.darkCyan;
      case 'Méditation': return AppColors.softPeach;
      case 'Anxiété': return AppColors.drySage;
      default: return AppColors.drySage; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: const BoxDecoration(
              color: AppColors.darkCyan,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back, 
                    color: Color(0xFFF1D483),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Catégories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<ActivityCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.tropicalTeal));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erreur de chargement des catégories'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucune catégorie disponible'));
                }

                final categories = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return CategoryCard(
                      title: cat.title,
                      icon: _getIconFromString(cat.iconName),
                      // On appelle la nouvelle fonction qui analyse le titre
                      color: _getColorFromTitle(cat.title),
                      onTap: () {
                        print('Catégorie sélectionnée : ${cat.title}');
                      },
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}