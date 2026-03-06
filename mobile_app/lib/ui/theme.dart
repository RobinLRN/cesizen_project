import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color skyBlue = Color(0xFF6BBCD0);
  static const Color tropicalTeal = Color(0xFF6BBCB5);
  static const Color darkCyan = Color(0xFF528E8A);
  static const Color softPeach = Color(0xFFF2D492);
  static const Color drySage = Color(0xFFB8B08D);
}

class AppTextStyles{
  static TextStyle titleStyleH1 = GoogleFonts.merriweatherSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.skyBlue,
  );

  static TextStyle titleStyleH2 = GoogleFonts.merriweatherSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.skyBlue,
  );

  static TextStyle titleStyleH3 = GoogleFonts.merriweatherSans(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: AppColors.skyBlue,
  );

  static TextStyle titleStyleH4 = GoogleFonts.merriweatherSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.skyBlue,
  );

  static TextStyle titleStyleH5 = GoogleFonts.merriweatherSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.skyBlue,
  );

  static TextStyle textStyleRegular = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 1.5
  );

  static  TextStyle textStyleRegularBackground = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    height: 1.5

  );

  static TextStyle textStyleBig = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.black
    
  );

  static TextStyle textStyleBigBackground = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.grey
  );


  static  TextStyle textStyleLittle = GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    height: 1.5
    
  );

  static TextStyle textStyleLittleBackground = GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey
  );
}


class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.tropicalTeal,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.tropicalTeal,
        primary: AppColors.tropicalTeal,
        secondary: AppColors.skyBlue,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.titleStyleH1,
        displayMedium: AppTextStyles.titleStyleH2,
        displaySmall: AppTextStyles.titleStyleH3,
        headlineMedium: AppTextStyles.titleStyleH4,
        headlineSmall: AppTextStyles.titleStyleH5,
        bodyLarge: AppTextStyles.textStyleBig,
        bodyMedium: AppTextStyles.textStyleRegular,
        bodySmall: AppTextStyles.textStyleLittle,
      ),
      useMaterial3: true,
    );
  }
}



    // titleLarge: GoogleFonts.merriweatherSans(
    //   fontSize: 20,
    //   fontWeight: FontWeight.w600,
    //   color: AppColors.darkCyan,
 


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
