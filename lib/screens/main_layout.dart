import 'package:flutter/material.dart';
import 'package:aevum_os/screens/codice_screen.dart';
import 'package:aevum_os/screens/nexo_screen.dart';
import 'package:aevum_os/screens/gremio_screen.dart';
import 'package:aevum_os/screens/logros_screen.dart';
import 'package:aevum_os/widgets/mechanical_nav_bar.dart';

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
      extendBody: true,
      body: Stack(
        children: [
          // 1. Optimized Screen content with IndexedStack and Fade
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: 1.0,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),
          
          // 2. Isolated Custom Navigation (RepaintBoundary for 60FPS)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RepaintBoundary(
              child: MechanicalNavBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  if (_currentIndex != index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
