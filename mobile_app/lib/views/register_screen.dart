import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';
import 'home_screen.dart';


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

    void _handleRegister() async {
        if (
            _pseudoController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _passwordController.text.trim().isEmpty ||
            _confirmPasswordController.text.trim().isEmpty
        ) {
            setState(() {
                _errorMessage = 'Veuillez remplir tous les champs.';
            });
            return;
        }

        if (_passwordController.text.trim()!= _confirmPasswordController.text.trim()
        ) {
            setState(() {
                _errorMessage = 'Les mots de passe ne correspondent pas.';
            });
            return;
        }
    }
  
  }