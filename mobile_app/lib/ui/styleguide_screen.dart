import 'package:flutter/material.dart';
// import 'widgets/diag_input.dart';
import 'widgets/top_bar.dart';

class StyleguideScreen extends StatelessWidget {
  const StyleguideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Appel de la version sans texte ni bouton
      appBar: CustomEmptyAppBar(),
      body: Center(
        child: Text('Accueil de l\'application'),
      ),
    );
  }
}