//Ce fichier défini les marges communes à toutes les pages de l'application.
//La top est implémentée dans ce composant pour éviter de devoir la réimplémenter à chaque page et pour garantir qu'elle soit toujours full width, même avec les marges définies dans le Padding.
import 'package:flutter/material.dart';

class PageLayout extends StatelessWidget {
  final Widget child;
  final bool showAppBar;
  final Color? backgroundColor;

  const PageLayout({
    super.key,
    required this.child,
    this.showAppBar = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: child,
      ),
    );
  }
}

//Exemple d'utilisation :

// @override
//   Widget build(BuildContext context) {
//     return PageLayout(
//       child: Column(
//         children: [
//           const Text("Ma barre de recherche ici"),
//           const SizedBox(height: 20),
//           const Text("Mes cartes ici"),
//           // Tout ce que tu mets ici aura automatiquement la marge de 20px
//         ],
//       ),
//     );
//   }
