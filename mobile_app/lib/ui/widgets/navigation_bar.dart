import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme.dart';
import '../../views/login_screen.dart'; // Importe ta page de connexion
import '../../views/placeholder_screen.dart';
import '../../views/activity_screen.dart';
import '../../views/diagnostic_start_screen.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  final _storage = const FlutterSecureStorage();

  // Fonction pour gérer la redirection Profil
  void _handleProfileNavigation(BuildContext context) async {
    String? token = await _storage.read(key: 'jwt_token');
    
    if (context.mounted) {
      if (token != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.tropicalTeal, // Ta couleur vert pétrole
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.menu_book_rounded, "Tracker", () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackerScreen()));
          }),
          _navItem(Icons.show_chart_rounded, "Activités", () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityScreen()));
          }),
          
          // Bouton Home Central
          GestureDetector(
            onTap: () { /* Déjà sur Home */ },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.softPeach, // Couleur beige/doré de ton design
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_filled, color: AppColors.tropicalTeal, size: 35),
            ),
          ),

          _navItem(Icons.pie_chart_rounded, "Diagnostic", () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const DiagnosticStartScreen()));
          }),
          _navItem(Icons.person_rounded, "Profil", () => _handleProfileNavigation(context)),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.softPeach, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.softPeach, fontSize: 12)),
        ],
      ),
    );
  }
}