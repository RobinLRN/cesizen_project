import 'package:cesizen/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool obscureText;

  const FormInput({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          obscureText: obscureText,
          style: GoogleFonts.merriweatherSans(
            color: AppColors.softPeach,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: AppColors.darkCyan) : null,
            suffixIcon: suffixIcon,
            hintStyle: GoogleFonts.merriweatherSans(
              color: AppColors.drySage,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: AppColors.drySage, width: 1.5),
            ),
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