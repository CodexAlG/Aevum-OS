import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class XpHaloAvatar extends StatelessWidget {
  final int xp;
  final int nextLevelXp;
  final int level;

  const XpHaloAvatar({
    super.key,
    required this.xp,
    required this.nextLevelXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (xp / nextLevelXp).clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Layer 1: Avatar with Soft Shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundColor: AppColors.card,
            child: Icon(
              Icons.person_outline,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 40,
            ),
          ),
        ),
        
        // Layer 2: Neon Progress Halo
        SizedBox(
          width: 105,
          height: 105,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: progress),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 5,
                color: AppColors.primary,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              );
            },
          ),
        ),
        
        // Soft Glow Layer
        SizedBox(
          width: 105,
          height: 105,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            color: AppColors.primary.withValues(alpha: 0.2),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
