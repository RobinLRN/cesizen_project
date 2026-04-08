import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'ui/widgets/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CesiZen',
      debugShowCheckedModeBanner: false,
      // Le FutureBuilder décide du premier écran à afficher
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          // Pendant que l'app vérifie le stockage sécurisé
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Si on a un token (utilisateur connecté) -> Accueil
          // Sinon -> Page de connexion
          if (snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      
      // définir les routes
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}