import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color skyBlue = Color(0xFF6BBCD0);
  static const Color tropicalTeal = Color(0xFF6BBCB5);
  static const Color darkCyan = Color(0xFF528E8A);
  static const Color softPeach = Color(0xFFF2D492);
  static const Color drySage = Color(0xFFB8B08D);
}


final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.darkCyan,
    primary: AppColors.skyBlue,
    secondary: AppColors.tropicalTeal,
    surface: Colors.white,
  ),
  
  textTheme: GoogleFonts.latoTextTheme().copyWith(
    
    displayLarge: GoogleFonts.merriweatherSans(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkCyan,
    ),
    displayMedium: GoogleFonts.merriweatherSans(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.darkCyan,
    ),
    headlineMedium: GoogleFonts.merriweatherSans(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkCyan,
    ),
    titleLarge: GoogleFonts.merriweatherSans(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkCyan,
    ),
  ),
);


//  titre
// Text(
//   "Mon Titre",
//   style: Theme.of(context).textTheme.headlineMedium,
// )

// texte
// Text(
//   "Ceci est un texte de description.",
//   style: Theme.of(context).textTheme.bodyMedium,
// )
