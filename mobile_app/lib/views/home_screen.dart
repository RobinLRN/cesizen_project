import 'package:flutter/material.dart';
import '../ui/widgets/page_layout.dart';
import '../ui/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomFullAppBar(title: 'Accueil'),
      body: PageLayout(child: Column(children: [ 

          ]
        )),
    );
  }
}
