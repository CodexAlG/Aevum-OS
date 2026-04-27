import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  final List<Map<String, dynamic>> _achievements = [
    {'title': 'INICIO DE CICLO', 'desc': 'COMPLETAR ONBOARDING.', 'rarety': 'B', 'isUnlocked': true},
    {'title': 'PRIMER LOGRO', 'desc': 'COMPLETAR UN DESAFÍO.', 'rarety': 'A', 'isUnlocked': true},
    {'title': 'MAESTRO VOID', 'desc': '7 DÍAS DE ACTIVIDAD.', 'rarety': 'S', 'isUnlocked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 32),
              _buildAchievementGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EL ARCHIVO',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'INSIGNIAS DE RANGO Y MÉRITO',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildAchievementGrid() {
    return Expanded(
      child: ListView.builder(
        itemCount: _achievements.length,
        padding: const EdgeInsets.only(bottom: 130),
        itemBuilder: (context, index) => _buildAchievementTile(_achievements[index]),
      ),
    );
  }

  Widget _buildAchievementTile(Map<String, dynamic> achievement) {
    bool isUnlocked = achievement['isUnlocked'];
    String rarety = achievement['rarety'];
    Color raretyColor = rarety == 'S' ? AppColors.rankHigh : rarety == 'A' ? AppColors.rankMid : AppColors.rankLow;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.card : AppColors.card.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isUnlocked ? raretyColor.withValues(alpha: 0.3) : AppColors.border),
        boxShadow: isUnlocked ? [
          BoxShadow(color: raretyColor.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 2)
        ] : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            ColorFiltered(
              colorFilter: isUnlocked ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply) : const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: raretyColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: Icon(Icons.stars, color: raretyColor, size: 32),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['title'],
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: isUnlocked ? AppColors.textTitle : AppColors.textSub,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement['desc'],
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            if (!isUnlocked) const Icon(Icons.lock_outline, color: AppColors.border, size: 20),
          ],
        ),
      ),
    );
  }
}
