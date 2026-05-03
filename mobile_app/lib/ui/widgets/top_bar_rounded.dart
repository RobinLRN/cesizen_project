import 'package:flutter/material.dart';

// --- VERSION UNIQUE : BARRE AVEC LOGO ET ARC DE CERCLE ---
// Ce composant utilise un CustomClipper pour créer une courbe fluide en bas.
class CustomLogoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;

  const CustomLogoAppBar({
    super.key,
    this.backgroundColor = const Color(0xFF558B84), // Vert pétrole par défaut
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      // Hauteur totale incluant la courbe
      preferredSize: const Size.fromHeight(150),
      child: ClipPath(
        clipper: ArcClipper(),
        child: Container(
          color: backgroundColor,
          child: SafeArea(
            child: Center(
              child: Padding(
                // Ajustement de la position du logo pour qu'il soit bien centré
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Image.asset('assets/images/logo_blanc.png', height: 60),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

// --- CLIPPER PERSONNALISÉ POUR L'ARC DE CERCLE ---
// Cette classe définit la forme précise de la découpe en bas de la barre.
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // On commence en haut à gauche
    path.lineTo(0, size.height - 50);

    // On crée une courbe de Bézier quadratique
    // Le premier point est le sommet de la courbe (au centre tout en bas)
    // Le second point est l'arrivée à droite (à la même hauteur qu'à gauche)
    path.quadraticBezierTo(
      size.width / 2, // Position X du sommet (milieu)
      size.height, // Position Y du sommet (bas total)
      size.width, // Position X finale
      size.height - 50, // Position Y finale
    );

    // On ferme le tracé vers le haut
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
