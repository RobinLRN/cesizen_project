//flutter run -d chrome -t lib/main_admin.dartx

import 'package:flutter/material.dart';
import 'backoffice/admin_auth_wrapper.dart';
import 'ui/widgets/widgets.dart'; // ton thème existant

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CesiZen Admin',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AdminAuthWrapper(), // ← c'est tout
    );
  }
}