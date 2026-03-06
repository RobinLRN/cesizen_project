import 'package:flutter/material.dart';
// import 'widgets/diag_input.dart';
import 'widgets/top_bar_rounded.dart';

class StyleguideScreen extends StatelessWidget {
  const StyleguideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appel de la version sans texte ni bouton
        appBar: CustomLogoAppBar(),
    );
  }
}