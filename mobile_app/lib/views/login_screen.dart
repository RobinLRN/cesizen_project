import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../ui/widgets/widgets.dart';
import '../ui/widgets/page_layout.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
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

    if(sucess){
      if(mounted){
        ScaffoldMessenger.of( context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie!')),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Échec de la connexion. Veuillez vérifier vos identifiants.';
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return PageLayout(
      child: Column(
        children: [
          
        ],
      ),
    );
  }
}
