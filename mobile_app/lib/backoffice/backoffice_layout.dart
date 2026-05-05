import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'views/user_management_page.dart';
import 'views/activity_management_page.dart';

class BackOfficeLayout extends StatefulWidget {
  @override
  _BackOfficeLayoutState createState() => _BackOfficeLayoutState();
}

class _BackOfficeLayoutState extends State<BackOfficeLayout> {
  int _selectedIndex = 0;

  // Liste des pages du backoffice
  final List<Widget> _pages = [
    const UserManagementPage(),
    const ActivityManagementPage(),
    Center(child: Text("Configuration Diagnostic")),
  ];

  @override
  Widget build(BuildContext context) {
    // Sécurité : Si on n'est pas sur Web, on affiche un message d'erreur
    if (!kIsWeb) {
      return Scaffold(
        body: Center(
          child: Text("Le Backoffice est accessible uniquement sur Web."),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // MENU LATERAL
          NavigationRail(
            backgroundColor: Color(0xFF006D77),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: TextStyle(color: Colors.white),
            unselectedLabelTextStyle: TextStyle(color: Colors.white70),
            selectedIconTheme: IconThemeData(
              color: Color(0xFFFFDDD2),
            ), // SoftPeach
            unselectedIconTheme: IconThemeData(color: Colors.white70),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Utilisateurs'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fitness_center),
                label: Text('Activités'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text('Diagnostic'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // CONTENU DE LA PAGE
          Expanded(
            child: Container(
              color: Color(0xFFEDF6F9),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
