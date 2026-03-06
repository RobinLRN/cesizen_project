import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool sucess = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (sucess) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Connexion réussie!')));
      }
    } else {
      setState(() {
        _errorMessage =
            'Échec de la connexion. Veuillez vérifier vos identifiants.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomLogoAppBar(),
      body: PageLayout(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Se connecter à \n CESIZEN',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            FormInput(
              label: 'Email',
              hint: 'Entrez votre adresse email',
              controller: _emailController,
              icon: Icons.email,
            ),
            const SizedBox(height: 50),
            FormInput(
              label: 'Mot de passe',
              hint: 'Entrez votre mot de passe',
              controller: _passwordController,
              icon: Icons.lock,
            ),
            const SizedBox(height: 50),
            MainButton(
              text: 'Se connecter',
              icon: Icons.arrow_forward, 
              onPressed: _handleLogin,
              ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pas encore de compte ?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                GestureDetector(
                  onTap: () {
                    print('Redirection vers la page d\'inscription');
                  },
                  child: Text(' S\'inscrire.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.tropicalTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: (){
                print('Redirection vers la page de mot de passe oublié');
              },
              child: Text('Mot de passe oublié ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.tropicalTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
