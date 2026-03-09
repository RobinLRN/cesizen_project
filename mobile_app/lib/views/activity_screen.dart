import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';


class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Activité',
      child: Center(
        child: Text('Ici, vous verrez les activités de vos amis et de votre communauté.'),
      ),
    );
  }
}