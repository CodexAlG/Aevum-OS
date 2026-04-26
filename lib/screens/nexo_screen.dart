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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<PlayerProvider>(
          builder: (context, player, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHUD(player),
                  const SizedBox(height: 48),
                  _buildEnfoqueSection(player),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHUD(PlayerProvider player) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.card.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTacticalBadge('VITALIDAD', '${player.hp}%', AppColors.danger),
          _buildCentralCore(player),
          _buildTacticalBadge('EVOLUCIÓN', '${player.xp} XP', AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildTacticalBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: color.withValues(alpha: 0.6),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.textTitle,
            shadows: [
              Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCentralCore(PlayerProvider player) {
    return Stack(
      alignment: Alignment.center,
      children: [
        XpHaloAvatar(
          xp: player.xp,
          nextLevelXp: player.nextLevelXp,
          level: player.level,
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.primary.withValues(alpha: 0.2), Colors.transparent],
            ),
          ),
          child: Center(
            child: Text(
              '${player.level}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textTitle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnfoqueSection(PlayerProvider player) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ENFOQUE DEL DÍA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.textSub,
              letterSpacing: 5,
              shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(0, 4))],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 130),
              children: [
                _buildRPGCard(title: 'Meditación Matutina', xp: 50, player: player),
                _buildRPGCard(title: 'Lectura Técnica', xp: 120, player: player),
                _buildRPGCard(title: 'Entrenamiento Épico', xp: 250, player: player),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRPGCard({required String title, required int xp, required PlayerProvider player}) {
    Color rankColor;
    String rankLetter;
    
    if (xp <= 50) {
      rankColor = AppColors.rankLow;
      rankLetter = 'B';
    } else if (xp <= 150) {
      rankColor = AppColors.rankMid;
      rankLetter = 'A';
    } else {
      rankColor = AppColors.rankHigh;
      rankLetter = 'S';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: rankColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              left: 0, top: 0, bottom: 0, width: 6,
              child: Container(color: rankColor),
            ),
            Positioned(
              right: 16, top: 16,
              child: Text(
                rankLetter,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: rankColor.withValues(alpha: 0.15),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => player.completarDesafio(xp),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textTitle),
                        ),
                      ),
                      _buildXpBadge(xp, rankColor),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildXpBadge(int xp, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        '+$xp XP',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color),
      ),
    );
  }
}
