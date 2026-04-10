import 'package:flutter/material.dart';
import '../ui/theme.dart';
import '../ui/widgets/page_layout.dart';
import 'diagnostic_questionnaire_screen.dart'; // On va le créer juste après

class DiagnosticStartScreen extends StatelessWidget {
  const DiagnosticStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tropicalTeal, // Fond vert de ta maquette
      body: PageLayout(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // L'icône de battement de coeur / stress
              const Icon(
                Icons.timeline_rounded, 
                size: 100, 
                color: Colors.white,
              ),
              const SizedBox(height: 40),
              
              // Titre
              Text(
                'Echelle de stress',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              
              // Description
              const Text(
                'Ce test de Holmes & Rahe évalue votre charge mentale basée sur les évènements des 12 derniers mois.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),
              
              // Bouton Commencer
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiagnosticQuestionnaireScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softPeach.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Commencer',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}