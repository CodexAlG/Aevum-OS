import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/screens/onboarding_screen.dart';
import 'package:aevum_os/screens/codice_screen.dart';
import 'package:aevum_os/screens/nexo_screen.dart';
import 'package:aevum_os/screens/gremio_screen.dart';
import 'package:aevum_os/screens/logros_screen.dart';
import 'package:aevum_os/widgets/mechanical_nav_bar.dart';
import 'package:aevum_os/theme/app_colors.dart';

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
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        // If not initialized, show Onboarding
        if (!player.isInitialized) {
          return const OnboardingScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          extendBody: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  AppColors.card,
                  AppColors.surface,
                ],
              ),
            ),
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 1.0,
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
                
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
          ),
        );
      },
    );
  }
}
