import 'package:flutter/material.dart';
import '../../models/activity.dart';
import '../theme.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onTap;

  const ActivityCard({super.key, required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
         boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.23),
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, 3),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Le Stack est indispensable ici pour superposer la pilule sur l'image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: activity.imageUrl != null
                      ? Image.network(
                          activity.imageUrl!,
                          height: 150,
                          width: double
                              .infinity, // Assure que l'image prenne toute la largeur
                          fit: BoxFit.cover,
                        )
                      : _buildPlaceholder(),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      // On joint les titres avec un slash, ou on affiche un texte par défaut
                      activity.categories.isNotEmpty 
                          ? activity.categories.map((c) => c.title).join('/')
                          : 'Sans catégorie',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.drySage,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                            color: AppColors.drySage,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.shortDescription ?? activity.content,
                          style: const TextStyle(
                            color: AppColors.drySage,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Le bouton rond avec la flèche
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.drySage,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFFDFBF7),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher un fond gris si l'image n'existe pas
  Widget _buildPlaceholder() {
    return Container(
      height:
          150, // J'ai ajusté la hauteur ici aussi pour correspondre à ton image
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}
