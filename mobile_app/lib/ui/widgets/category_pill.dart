import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryPill extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: isSelected 
                    ? Border.all(color: AppColors.darkCyan, width: 2) 
                    : null,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.darkCyan : AppColors.drySage,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}