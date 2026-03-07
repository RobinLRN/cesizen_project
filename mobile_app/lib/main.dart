import 'package:cesizen/views/register_screen.dart';
import 'package:cesizen/views/login_screen.dart';
import 'package:cesizen/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'ui/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      //home: RegisterScreen(),
      //home: LoginScreen(),
      home: HomeScreen(),
    );
  }
}
