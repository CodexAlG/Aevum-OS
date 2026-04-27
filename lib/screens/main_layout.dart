import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/screens/onboarding_screen.dart';
import 'package:aevum_os/screens/codice_screen.dart';
import 'package:aevum_os/screens/dailys_screen.dart';
import 'package:aevum_os/screens/nexo_screen.dart';
import 'package:aevum_os/screens/gremio_screen.dart';
import 'package:aevum_os/screens/logros_screen.dart';
import 'package:aevum_os/theme/app_colors.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 2; // Start on Nexo (middle)

  final List<Widget> _screens = const [
    CodiceScreen(),
    DailysScreen(),
    NexoScreen(),
    GremioScreen(),
    LogrosScreen(),
  ];

  final List<IconData> _navIcons = [
    Icons.auto_stories_outlined,
    Icons.calendar_today_outlined,
    Icons.blur_on_outlined,
    Icons.shield_outlined,
    Icons.workspace_premium_outlined,
  ];

  final List<String> _navLabels = [
    'CÓDICE',
    'DAILYS',
    'NEXO',
    'GREMIO',
    'LOGROS',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        if (!player.isInitialized) {
          return const OnboardingScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // Background Gradient
              Container(
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
              ),
              
              // Main Content
              IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              
              // Integrated Navigation Bar
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildIntegratedNavBar(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntegratedNavBar() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tabWidth = screenWidth / _navIcons.length;

    return Container(
      width: double.infinity,
      height: 85 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Tactical Selection Indicator (Line)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: 0,
            left: _currentIndex * tabWidth + (tabWidth * 0.25),
            child: Container(
              width: tabWidth * 0.5,
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.8),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          
          // Navigation Items
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navIcons.length, (index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: tabWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _navIcons[index],
                          color: isSelected ? AppColors.primary : AppColors.textSub,
                          size: 26,
                          shadows: isSelected ? [
                            Shadow(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              blurRadius: 15,
                            )
                          ] : null,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _navLabels[index],
                          style: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textSub,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
