import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class XpHaloAvatar extends StatefulWidget {
  final int xp;
  final int nextLevelXp;
  final int level;
  final bool showIcon;

  const XpHaloAvatar({
    super.key,
    required this.xp,
    required this.nextLevelXp,
    required this.level,
    this.showIcon = false,
  });

  @override
  State<XpHaloAvatar> createState() => _XpHaloAvatarState();
}

class _XpHaloAvatarState extends State<XpHaloAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.xp / widget.nextLevelXp).clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Layer 1: Core Base
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: widget.showIcon ? Icon(
            Icons.person_outline,
            color: AppColors.primary.withValues(alpha: 0.6),
            size: 32,
          ) : null,
        ),
        
        // Layer 2: Neon Progress Halo (Pulsing Breathing Effect)
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Opacity(
                opacity: 0.3 + (_pulseAnimation.value - 1.0) * 3,
                child: child,
              ),
            );
          },
          child: SizedBox(
            width: 105,
            height: 105,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.05),
                );
              },
            ),
          ),
        ),
        
        // Steady Outer Ring
        SizedBox(
          width: 110,
          height: 110,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 1,
            color: AppColors.primary.withValues(alpha: 0.2),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
