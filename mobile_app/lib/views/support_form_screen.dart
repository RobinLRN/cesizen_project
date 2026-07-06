import 'package:flutter/material.dart';
import '../services/support_service.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';

class SupportFormScreen extends StatefulWidget {
  const SupportFormScreen({super.key});

  @override
  State<SupportFormScreen> createState() => _SupportFormScreenState();
}

class _SupportFormScreenState extends State<SupportFormScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final SupportService _supportService = SupportService();

  // Catégories proposées : clé technique (envoyée au backend) -> libellé affiché.
  final Map<String, String> _categories = const {
    'bug': 'Bug / Problème technique',
    'suggestion': "Suggestion d'amélioration",
    'question': 'Question',
    'autre': 'Autre',
  };
  String _selectedCategory = 'bug';

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    // Validation locale : sujet et description obligatoires.
    if (_subjectController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez renseigner un sujet et une description.';
      });
      return;
    }

    // Validation basique de l'email s'il est renseigné.
    final email = _emailController.text.trim();
    if (email.isNotEmpty &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      setState(() {
        _errorMessage = "L'adresse email n'est pas valide.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _supportService.submitTicket(
      category: _selectedCategory,
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      email: email.isEmpty ? null : email,
    );

    // On vérifie que la page est toujours affichée.
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Merci ! Votre signalement a bien été transmis.'),
          backgroundColor: AppColors.tropicalTeal,
        ),
      );
      Navigator.pop(context);
    } else {
      setState(() => _errorMessage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomFullAppBar(
        title: 'Signaler un problème',
        onBackPress: () => Navigator.pop(context),
      ),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Un souci ? Dites-nous tout',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Décrivez le problème rencontré : notre équipe le prendra en charge au plus vite.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Type de signalement
              FormDropdown(
                label: 'Type de signalement',
                icon: Icons.category,
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 30),

              // Sujet
              FormInput(
                label: 'Sujet',
                hint: 'Résumez le problème en quelques mots',
                controller: _subjectController,
                icon: Icons.title,
              ),
              const SizedBox(height: 30),

              // Description (multi-lignes)
              FormInput(
                label: 'Description',
                hint: 'Décrivez ce qui se passe, étape par étape...',
                controller: _descriptionController,
                icon: Icons.description,
                maxLines: 6,
              ),
              const SizedBox(height: 30),

              // Email de contact (facultatif)
              FormInput(
                label: 'Email de contact (facultatif)',
                hint: 'Pour être recontacté si nécessaire',
                controller: _emailController,
                icon: Icons.email,
              ),
              const SizedBox(height: 40),

              // Affichage des erreurs
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Bouton d'envoi (ou loader)
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.tropicalTeal,
                      ),
                    )
                  : MainButton(
                      text: 'Envoyer le signalement',
                      icon: Icons.send,
                      onPressed: _handleSubmit,
                    ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
