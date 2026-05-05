import 'package:cesizen/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiagInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final String? Function(String?)? validator;

  const DiagInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Le titre de l'input
        Text(
          label,
          style: GoogleFonts.merriweatherSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.tropicalTeal,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          //focus input style
          style: GoogleFonts.merriweatherSans(
            color: AppColors.softPeach,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          //default input style
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.drySage)
                : null,
            hintStyle: GoogleFonts.merriweatherSans(
              color: AppColors.drySage,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            //default border
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColors.drySage, width: 1.5),
            ),
            //focus boder
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColors.drySage, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }
}
