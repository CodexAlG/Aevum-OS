import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';
import 'package:aevum_os/widgets/xp_halo_avatar.dart';

class NexoScreen extends StatelessWidget {
  const NexoScreen({super.key});

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
                  _buildBrandTitle(),
                  const SizedBox(height: 24),
                  _buildAuroraHeader(player),
                  const SizedBox(height: 48),
                  _buildChallengeSection(player),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrandTitle() {
    return const Text(
      'AEVUM: VOID',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.textSub,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildAuroraHeader(PlayerProvider player) {
    bool isCritical = player.hp < 30;
    
    return Row(
      children: [
        // Left Side: Vital Metrics
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player.hp}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textTitle,
                ),
              ),
              Text(
                isCritical ? 'CRÍTICO' : 'VITALIDAD ESTABLE',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: isCritical ? AppColors.danger : AppColors.success.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        
        // Center: The Core (Avatar with Halo)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: XpHaloAvatar(
            xp: player.xp,
            nextLevelXp: player.nextLevelXp,
            level: player.level,
          ),
        ),
        
        // Right Side: Evolution Metrics
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LVL ${player.level}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'CONCENTRACIÓN',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  color: AppColors.primary.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeSection(PlayerProvider player) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENFOQUE DEL DÍA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSub,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 130),
              children: [
                _buildChallengeCard(
                  title: 'Meditación Matutina',
                  xpReward: 50,
                  onComplete: () => player.gainXp(50),
                ),
                const SizedBox(height: 18),
                _buildChallengeCard(
                  title: 'Lectura de Crecimiento',
                  xpReward: 30,
                  onComplete: () => player.gainXp(30),
                ),
                const SizedBox(height: 18),
                _buildChallengeCard(
                  title: 'Práctica de Gratitud',
                  xpReward: 40,
                  onComplete: () => player.gainXp(40),
                ),
                const SizedBox(height: 18),
                _buildChallengeCard(
                  title: 'Sesión de Deep Work',
                  xpReward: 100,
                  onComplete: () => player.gainXp(100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required int xpReward,
    required VoidCallback onComplete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onComplete,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.panorama_fish_eye,
                  color: AppColors.textSub,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: ShapeDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    '+$xpReward XP',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
