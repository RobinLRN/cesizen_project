import 'package:cesizen/ui/widgets/page_layout.dart';
import 'package:flutter/material.dart';
import '../ui/widgets/widgets.dart';

class CategoryScreen extends StatelessWidget{
  CategoryScreen({super.key});

  final List<Map<String, dynamic>> _categories = [
    {'title': 'stress', 'icon': Icons.brightness_high, 'color': AppColors.darkCyan},
    {'title': 'stress', 'icon': Icons.sports_basketball, 'color': AppColors.skyBlue},
    {'title': 'stress', 'icon': Icons.self_improvement, 'color': AppColors.softPeach},
    {'title': 'stress', 'icon': Icons.medical_services, 'color': AppColors.tropicalTeal},
    {'title': 'stress', 'icon': Icons.hourglass_bottom, 'color': AppColors.drySage},
  ];

  @override
  Widget build(BuildContext context){
  return Scaffold(
    appBar: CustomFullAppBar(title: 'Catégories'),
    backgroundColor: const Color(0xFFFDFBF7),
    body: PageLayout(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(25),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,//colonnes
                crossAxisSpacing: 20, //espace horizontal
                mainAxisSpacing: 20, //espace vertical
                childAspectRatio: 0.9, //proportions
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return CategoryCard(title: cat['title'], icon: cat['icon'], color: cat['color'], onTap: (){

                  });
                }
            )
          )
        ],
      ),
    )
  );
  }
}