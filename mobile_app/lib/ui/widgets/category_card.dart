import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryCard extends StatelessWidget{
  final String title; 
  final IconData icon;
  final Color color; 
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(50, 50, 93, 0.25),
              blurRadius: 27,
              spreadRadius: -5,
              offset: Offset(0, 13),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.3),
              blurRadius: 16,
              spreadRadius: -8,
              offset: Offset(0, 8),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 35,),
            ),
            const SizedBox(height: 15,),
            Text(
              title, 
              style: TextStyle(
                color: AppColors.drySage,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ),
    );
  }
}