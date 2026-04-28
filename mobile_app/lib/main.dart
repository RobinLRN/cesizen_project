//main.dart backoffice

import 'package:flutter/material.dart';
import 'ui/widgets/widgets.dart';
import 'backoffice/backoffice_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CesiZen Admin',
      theme: AppTheme.lightTheme, // Utilise ton thème défini
      home: BackOfficeLayout(), // <-- On force le démarrage sur le Backoffice
    );
  }
}