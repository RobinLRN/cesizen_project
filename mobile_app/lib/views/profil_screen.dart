import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart'; // Supposant que CustomFullAppBar et CustomNavigationBar y sont
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true; // On affiche un chargement le temps de vérifier

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // --- LE FAMEUX VIGILE ---
  Future<void> _checkAuthentication() async {
    final token = await AuthService().getToken();
    
    if (!mounted) return;

    if (token == null) {
      // Pas de token = Pas connecté -> Redirection immédiate vers le Login
      // Remplacer '/login' par le nom exact de votre route de connexion
      Navigator.pushReplacementNamed(context, '/login'); 
    } else {
      // Token présent -> On enlève l'écran de chargement et on affiche le profil
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tant qu'on vérifie, on affiche un petit cercle de chargement
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.darkCyan),
        ),
      );
    }

    return Scaffold(
      appBar: CustomFullAppBar(
        title: '',
        onBackPress: () {}, 
        trailingIcon: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile_settings');
          },
          child: const Icon(
            Icons.settings, 
            color: AppColors.softPeach, 
            size: 24,
          ),
        ),
      ),
      body: PageLayout(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Avatar (placeholder pour le moment)
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey, // Remplacer par l'image de l'utilisateur plus tard
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.softPeach,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera_alt, size: 20, color: AppColors.darkCyan),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Nom de l'utilisateur (placeholder)
            const Center(
              child: Text(
                "Nom d'utilisateur",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.softPeach, // À ajuster selon votre thème exact
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const CustomNavigationBar(), // Votre barre de navigation en bas
    );
  }
}