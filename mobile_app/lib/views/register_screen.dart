import 'package:cesizen/views/login_screen.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isStepTwo = false;

  void _goToNextStep() {
    //On vérifie que les champs ne sont pas vides
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    // On vérifie que les mots de passe correspondent
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas.';
      });
      return;
    }

    // On efface les anciennes erreurs et on passe à l'étape suivante
    setState(() {
      _errorMessage = null;
      _isStepTwo = true;
    });
  }

  //Valider étape finale et appeler l'API d'inscription
  void _handleRegister() async {
    if (_pseudoController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez choisir un pseudo.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Appel API
    String? result = await _authService.register(
      _pseudoController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // On vérifie que la page est toujours à l'écran
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Gestion du résultat
    if (result == null) {
      // Si result est null, c'est un succès absolu !
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Compte créé avec succès ! Vous pouvez maintenant vous connecter.',
          ),
          backgroundColor: AppColors.tropicalTeal,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // S'il y a du texte dans result, on l'affiche directement en rouge
      setState(() {
        _errorMessage = result;
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
            Text(
              _isStepTwo
                  ? 'Choisissez votre nom d\'utilisateur'
                  : 'Inscrivez-vous gratuitement',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            //Afficher l'étaper 1
            if (!_isStepTwo) ...[
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
                hint: 'Créez un mot de passe',
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
              //Confirm Password Input
              FormInput(
                label: 'Confirmer le mot de passe',
                hint: 'Retapez votre mot de passe',
                controller: _confirmPasswordController,
                icon: Icons.lock,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.drySage,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ],

            //Afficher l'étape 2
            if (_isStepTwo) ...[
              FormInput(
                label: 'Nom d\'utilisateur',
                hint: 'Entrez votre nom d\'utilisateur...',
                controller: _pseudoController,
                icon: Icons.person,
              ),
            ],

            const SizedBox(height: 50),

            // Affichage des erreurs
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),

            // Boutons dynamiques selon l'étape
            if (!_isStepTwo)
              MainButton(
                text: 'Suivant',
                icon: Icons.arrow_forward,
                onPressed: _goToNextStep,
              )
            else
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.tropicalTeal,
                      ),
                    )
                  : Column(
                      children: [
                        MainButton(
                          text: 'S\'inscrire',
                          icon: Icons.person_add,
                          onPressed: _handleRegister,
                        ),
                        const SizedBox(height: 15),
                        // Bouton pour revenir à l'étape
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isStepTwo = false;
                              _errorMessage = null;
                            });
                          },
                          child: Text(
                            'Retour',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.drySage,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    ),

            const SizedBox(height: 20),

            // Le lien pour retourner à la connexion (uniquement à l'étape 1)
            if (!_isStepTwo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà un compte ?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      ' Se connecter.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.tropicalTeal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        ),
      ),
    );
  }
}
