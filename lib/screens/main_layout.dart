import 'package:flutter/material.dart';
import 'package:aevum_os/screens/codice_screen.dart';
import 'package:aevum_os/screens/nexo_screen.dart';
import 'package:aevum_os/screens/gremio_screen.dart';
import 'package:aevum_os/screens/logros_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    CodiceScreen(),
    NexoScreen(),
    GremioScreen(),
    LogrosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Códice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Nexo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flash_on),
            label: 'Gremio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Logros',
          ),
        ],
      ),
    );
  }
}
