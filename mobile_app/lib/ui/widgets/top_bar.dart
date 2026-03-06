import 'package:flutter/material.dart';
import '../theme.dart';

// --- VERSION 1 : BARRE COMPLÈTE AVEC TITRE ET RETOUR ---
// Cette version est idéale pour les pages de réglages ou de profil.
class CustomFullAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPress;

  const CustomFullAppBar({
    super.key,
    required this.title,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      // La hauteur de 100 pixels permet de loger confortablement la courbe
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        // Couleur de fond vert pétrole
        backgroundColor: AppColors.darkCyan,
        // Désactivation du bouton de retour par défaut pour un contrôle total
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            // Le padding bottom à 20 permet de remonter le titre par rapport au bord bas
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône de retour avec la couleur dorée spécifique
                GestureDetector(
                  onTap: onBackPress ?? () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.softPeach,
                    size: 24,
                  ),
                ),
                // Spacer pousse le titre vers le bas de la zone disponible
                const Spacer(),
                // Style du titre blanc et épuré
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Application de l'arrondi prononcé sur les coins inférieurs
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        elevation: 0,
      ),
    );
  }

  // Définition de la taille préférée requise par PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// --- VERSION 2 : BARRE ÉPURÉE (VIDE) ---
// Utile pour les écrans d'accueil ou les sections sans navigation complexe.
class CustomEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomEmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      // On conserve la même hauteur pour garder une cohérence visuelle
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        backgroundColor: AppColors.darkCyan,
        automaticallyImplyLeading: false,
        // On laisse flexibleSpace vide pour ne garder que la forme colorée
        flexibleSpace: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}