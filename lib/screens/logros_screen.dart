import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class LogrosScreen extends StatefulWidget {
  const LogrosScreen({super.key});

  @override
  State<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends State<LogrosScreen> {
  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'PRIMER PASO',
      'desc': 'Completar el primer enfoque del día.',
      'icon': Icons.flare,
      'isUnlocked': true,
    },
    {
      'title': 'DISCIPLINA DE HIERRO',
      'desc': '7 días seguidos de hábitos perfectos.',
      'icon': Icons.bolt,
      'isUnlocked': true,
    },
    {
      'title': 'MENTE CLARA',
      'desc': '10 horas totales de meditación.',
      'icon': Icons.self_improvement,
      'isUnlocked': false,
    },
    {
      'title': 'MAESTRO DEL CÓDICE',
      'desc': 'Escribir 50 registros personales.',
      'icon': Icons.auto_awesome,
      'isUnlocked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<PlayerProvider>(
          builder: (context, player, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsCard(player),
                  const SizedBox(height: 32),
                  _buildAchievementsList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EL ARCHIVO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitle,
          ),
        ),
        Text(
          'REGISTROS DE EVOLUCIÓN E INSIGNIAS',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(PlayerProvider player) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RANGO ACTUAL',
                style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              Text(
                'Nivel ${player.level}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textTitle),
              ),
            ],
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'ESTADO',
                style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              Text(
                'ÓPTIMO',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textTitle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _achievements.length,
        padding: const EdgeInsets.only(bottom: 130),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildAchievementCard(_achievements[index]);
        },
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    bool isUnlocked = achievement['isUnlocked'];

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.card : AppColors.card.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isUnlocked ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
          width: 1,
        ),
        boxShadow: isUnlocked 
          ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ]
          : [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked ? AppColors.primary.withValues(alpha: 0.1) : AppColors.border.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement['icon'],
                color: isUnlocked ? AppColors.primary : AppColors.textSub,
                size: 28,
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
                    ),
                  ),
                  Text(
                    achievement['desc'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isUnlocked ? AppColors.textSub : AppColors.textSub.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (!isUnlocked)
              const Icon(Icons.lock_outline, color: AppColors.textSub, size: 20),
          ],
        ),
      ),
    );
  }
}
