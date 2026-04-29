import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true; // On affiche un chargement le temps de vérifier
  String _pseudo = "Utilisateur"; // Valeur par défaut, sera remplacée par le pseudo réel

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Fonction pour vérifier si l'utilisateur est connecté et récupérer son pseudo
  Future<void> _checkAuthentication() async {
    final token = await AuthService().getToken();
    
    if (!mounted) return;

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login'); 
    } else {
      // RÉCUPÉRATION DU PSEUDO ICI :
      final savedPseudo = await AuthService().getPseudo();
      
      setState(() {
        if (savedPseudo != null) {
          _pseudo = savedPseudo;
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Text(
                _pseudo, 
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.softPeach, 
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: const CustomNavigationBar(), 
    );
  }
}