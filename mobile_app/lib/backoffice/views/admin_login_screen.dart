import 'package:flutter/material.dart';
import '../services/admin_auth_service.dart';
import '../../ui/widgets/page_layout.dart';
import '../../ui/widgets/widgets.dart';
import '../backoffice_layout.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});
  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // On vérifie que les champs ne sont pas vides
  void _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    // On efface les anciennes erreurs
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Appel API
    bool success = await AdminAuthService.login(
  _emailController.text.trim(),
  _passwordController.text.trim(),
);

    // On vérifie que la page est toujours à l'écran
    if (!mounted) return;

    // On arrête le cercle de chargement
    setState(() {
      _isLoading = false;
    });

    // Gestion du résultat
    if (success) {
      // Redirection vers la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BackOfficeLayout()),
      );
    } else {
      setState(() {
        _errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomLogoAppBar(),
      body: PageLayout(
        child: SingleChildScrollView(
          child: Column(
          children: [
            // Titre
            Text(
              'Se connecter à \n CESIZEN',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            //Email Input
            FormInput(
              label: 'Email',
              hint: 'Entrez votre adresse email',
              controller: _emailController,
              icon: Icons.email,
            ),

            const SizedBox(height: 50),

            //Password Input
            FormInput(
              label: 'Mot de passe',
              hint: 'Entrez votre mot de passe',
              controller: _passwordController,
              icon: Icons.lock,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.drySage,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),

            // Affichage conditionnel du message d'erreur
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            // Affichage conditionnel du chargement ou du bouton
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.tropicalTeal,
                    ),
                  )
                : MainButton(
                    text: 'Se connecter',
                    icon: Icons.arrow_forward,
                    onPressed: _handleLogin,
                  ),

            const SizedBox(height: 50),
           
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                print('Redirection vers la page de mot de passe oublié');
              },
              child: Text(
                'Mot de passe oublié ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.tropicalTeal,
                  fontWeight: FontWeight.w700,
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
