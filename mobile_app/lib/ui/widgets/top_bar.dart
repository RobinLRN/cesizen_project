import 'package:flutter/material.dart';
import '../theme.dart';

// --- VERSION 1 : BARRE COMPLÈTE AVEC TITRE ET RETOUR ---
class CustomFullAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPress;
  final Color backgroundColor;
  final Widget? trailingIcon; 

  const CustomFullAppBar({
    super.key,
    required this.title,
    this.onBackPress,
    this.backgroundColor = AppColors.darkCyan,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ligne contenant la flèche de retour et l'icône optionnelle à droite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icône de retour
                    GestureDetector(
                      onTap: onBackPress ?? () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.softPeach,
                        size: 24,
                      ),
                    ),
                    if (trailingIcon != null) trailingIcon!,
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// --- VERSION 2 : BARRE ÉPURÉE (VIDE) ---
class CustomEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomEmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        backgroundColor: AppColors.darkCyan,
        automaticallyImplyLeading: false,
        flexibleSpace: null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}