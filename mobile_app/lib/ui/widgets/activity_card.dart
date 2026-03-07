import 'package:flutter/material.dart';
import '../theme.dart';
import '../../models/resource.dart';

class ActivityCard extends StatelessWidget {
  final Resource resource;
  final String type;
  final List<String> categories;
  final VoidCallback onViewDetails;

  const ActivityCard({
    super.key,
    required this.resource,
    required this.onViewDetails,
    required this.type,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PARTIE IMAGE (STACK) ---
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                // Emplacement pour Image.network(resource.coverImgLink) plus tard
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    _buildActionButton(Icons.favorite_border, () {}),
                    const SizedBox(width: 10),
                    _buildActionButton(Icons.bookmark_border, () {}),
                  ],
                ),
              ),
            ],
          ),

          // --- CONTENU (PADDING) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Catégorie et Durée
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.darkCyan),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: AppColors.darkCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppColors.darkCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      resource.readTime,
                      style: const TextStyle(
                        color: AppColors.darkCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Titre
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  resource.description,
                  style: TextStyle(color: Colors.grey[600], height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Auteur et Date
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.darkCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      resource.author,
                      style: const TextStyle(color: AppColors.darkCyan),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.darkCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${resource.publishedAt.day}/${resource.publishedAt.month}/${resource.publishedAt.year}",
                      style: const TextStyle(color: AppColors.darkCyan),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Catégories et Bouton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: categories
                            .map(
                              (cat) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.darkCyan.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  cat,
                                  style: const TextStyle(
                                    color: AppColors.darkCyan,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkCyan,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Consulter"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour les boutons orange permanents
  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// Exemple d'utilisation :
//On crée un objet Resource fictif en attendant l'API :

// final testResource = Resource(
//   id: 1,
//   title: 'Activité entre amis',
//   description: 'Une superbe activité à réaliser avec vos proches.',
//   coverImgLink: '',
//   readTime: '10 min',
//   publishedAt: DateTime.now(),
//   author: 'Charles',
// );

// Dans une page :

// ActivityCard(
//   resource: testResource,
//   type: 'Activité',
//   categories: const ['Communication', 'Famille'],
//   onViewDetails: () => print('Bouton cliqué !'),
// )
