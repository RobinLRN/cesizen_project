import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart'; 
import '../ui/theme.dart';
import '../services/auth_service.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  void _handleLogout(BuildContext context) async { // <-- N'oubliez pas le 'async'
    
    // On appelle la fonction de déconnexion
    await AuthService().logout();
    
    // Redirection vers la page d'accueil
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  // Widget utilitaire pour créer les boutons de la liste
  Widget _buildSettingsItem(String title, VoidCallback onTap, {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25), // Bordures arrondies selon maquette
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.darkCyan), // Bordure colorée
            borderRadius: BorderRadius.circular(25),
            color: Colors.white, // Fond blanc
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isLogout ? Colors.red : AppColors.darkCyan, // Rouge si déconnexion
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLogout ? Colors.red : AppColors.darkCyan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(
        title: 'Paramètres du profil',
        onBackPress: () => Navigator.pop(context),
      ),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Section Compte et profil
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text("Compte et profil", style: TextStyle(color: AppColors.darkCyan, fontWeight: FontWeight.bold)),
              ),
              _buildSettingsItem("Nom", () {}),
              _buildSettingsItem("Prénom", () {}),
              _buildSettingsItem("Email", () {}),
              _buildSettingsItem("Modifier mot de passe", () {}),
              
              const SizedBox(height: 20),
              
              // Section Confidentialité et sécurité
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text("Confidentialité et sécurité", style: TextStyle(color: AppColors.darkCyan, fontWeight: FontWeight.bold)),
              ),
              _buildSettingsItem("Cookies", () {}),
              _buildSettingsItem("Politique de confidentialité", () {}),
              _buildSettingsItem("Aide et FAQ", () {}),
              
              const SizedBox(height: 20),

              
              
              // Section Déconnexion
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text("Déconnexion", style: TextStyle(color: AppColors.darkCyan, fontWeight: FontWeight.bold)),
              ),
              _buildSettingsItem(
                "Déconnexion", 
                () => _handleLogout(context),
                isLogout: true, // Applique le style rouge
              ),
              
              const SizedBox(height: 40), // Espace en bas
            ],
          ),
        ),
      ),
    );
  }
}