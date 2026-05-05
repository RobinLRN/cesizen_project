//flutter run -d chrome

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'ui/widgets/widgets.dart';
import 'views/activity_screen.dart';
import 'views/diagnostic_start_screen.dart';
import 'views/profil_screen.dart';
import 'views/profile_settings_screen.dart';

void main() {
  // Indispensable pour que Flutter puisse interagir avec le stockage avant runApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Petite fonction pour vérifier si l'utilisateur est déjà passé par là
  Future<bool> _checkLoginStatus() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    // On retourne true si un token est trouvé
    return token != null;
  }

 // Dans ton fichier main.dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'CesiZen',
    theme: AppTheme.lightTheme,
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(), 
    routes: {
      '/home': (context) => const HomeScreen(),
      '/login': (context) => const LoginScreen(),
      '/activities': (context) => const ActivityScreen(),
      '/diagnostic': (context) => const DiagnosticStartScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/profile_settings': (context) => const ProfileSettingsScreen(),

      
      },
    );
  }
}