import 'package:flutter/material.dart';
import 'services/admin_auth_service.dart';
import 'backoffice_layout.dart';
// Réutilise ta page login existante — adapte l'import à ton chemin
import 'views/admin_login_screen.dart'; 

class AdminAuthWrapper extends StatefulWidget {
  const AdminAuthWrapper({super.key});

  @override
  State<AdminAuthWrapper> createState() => _AdminAuthWrapperState();
}

class _AdminAuthWrapperState extends State<AdminAuthWrapper> {
  bool _loading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final logged = await AdminAuthService.isLoggedIn();
    setState(() { _isAdmin = logged; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Si connecté → backoffice, sinon → login
    return _isAdmin ? BackOfficeLayout() : AdminLoginScreen();
  }
}