import 'package:flutter/material.dart';
import 'widgets/diag_input.dart';

class StyleguideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DiagInput(
            hint: "Saisissez votre adresse email", 
            controller: TextEditingController(),
            label: "Email",
            icon: Icons.email,
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}