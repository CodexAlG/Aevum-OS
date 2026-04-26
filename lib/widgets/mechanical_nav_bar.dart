import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aevum_os/theme/app_colors.dart';

class MechanicalNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MechanicalNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<MechanicalNavBar> createState() => _MechanicalNavBarState();
}

class _MechanicalNavBarState extends State<MechanicalNavBar> with SingleTickerProviderStateMixin {
  late double _continuousValue;
  late AnimationController _snapController;
  late Animation<double> _snapAnimation;
  
  bool _isDragging = false;
  int _lastHapticIndex = 1;

  @override
  void initState() {
    super.initState();
    _continuousValue = widget.currentIndex / 3;
    _lastHapticIndex = widget.currentIndex;
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _snapAnimation = _snapController.drive(CurveTween(curve: Curves.easeOutCubic));
    _snapController.addListener(() {
      if (!_isDragging) {
        setState(() {
          _continuousValue = _snapAnimation.value;
        });
      }
    });
  }

  @override
  void didUpdateWidget(MechanicalNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex && !_isDragging) {
      _snapValueTo(widget.currentIndex / 3);
    }
  }

  void _snapValueTo(double target) {
    _snapAnimation = Tween<double>(
      begin: _continuousValue,
      end: target,
    ).animate(_snapController);
    _snapController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        const double height = 135.0;
        
        final double radius = width * 0.85;
        final double centerX = width / 2;
        final double centerY = height + (radius * 0.85);
        
        const double span = math.pi / 3.2;
        const double startAngle = -math.pi / 2 - (span / 2);
        
        double getAngleForValue(double val) => startAngle + (val * span);

        return GestureDetector(
          onPanStart: (_) {
            setState(() {
              _isDragging = true;
            });
            HapticFeedback.selectionClick();
          },
          onPanUpdate: (details) {
            double newVal = (details.localPosition.dx / width).clamp(0.0, 1.0);
            int newIndex = (newVal * 3).round();
            
            setState(() {
              _continuousValue = newVal;
            });
            
            if (newIndex != _lastHapticIndex) {
              HapticFeedback.selectionClick();
              _lastHapticIndex = newIndex;
              widget.onTap(newIndex);
            }
          },
          onPanEnd: (_) {
            setState(() => _isDragging = false);
            _snapValueTo(widget.currentIndex / 3);
            HapticFeedback.mediumImpact();
          },
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: MechanicalBasePainter(
                        centerX: centerX,
                        centerY: centerY,
                        radius: radius,
                      ),
                    ),
                  ),
                ),
                
                ...List.generate(4, (index) {
                  final double val = index / 3;
                  final angle = getAngleForValue(val);
                  final x = centerX + (radius + 20) * math.cos(angle);
                  final y = centerY + (radius + 20) * math.sin(angle);
                  
                  final icons = [
                    Icons.book_outlined,
                    Icons.home_outlined,
                    Icons.flash_on_outlined,
                    Icons.emoji_events_outlined
                  ];
                  
                  double dist = (_continuousValue - val).abs();
                  bool isNear = dist < 0.12;
                  bool isActive = widget.currentIndex == index;

                  return Positioned(
                    left: x - 40,
                    top: y - 40,
                    width: 80,
                    child: Transform.scale(
                      scale: isNear || isActive ? 1.15 : 1.0,
                      child: Opacity(
                        opacity: isNear || isActive ? 1.0 : 0.5,
                        child: Icon(
                          icons[index],
                          color: isNear || isActive ? Colors.white : AppColors.textSub,
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }),

                Builder(
                  builder: (context) {
                    final angle = getAngleForValue(_continuousValue);
                    final x = centerX + radius * math.cos(angle);
                    final y = centerY + radius * math.sin(angle);

                    return Positioned(
                      left: x - 10,
                      top: y - 10,
                      child: _buildTacticalLED(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTacticalLED() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.8),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class MechanicalBasePainter extends CustomPainter {
  final double centerX;
  final double centerY;
  final double radius;

  MechanicalBasePainter({
    required this.centerX,
    required this.centerY,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect domeRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius + 45);
    
    final Paint basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.card,
          AppColors.card.withValues(alpha: 0.9),
          AppColors.surface.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final Path basePath = Path()
      ..addArc(domeRect, math.pi, math.pi);
    canvas.drawPath(basePath, basePaint);

    final Paint edgePaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawArc(domeRect, math.pi, math.pi, false, edgePaint);

    final Paint groovePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35;

    final Rect trackRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    canvas.drawArc(trackRect, math.pi + math.pi/4, math.pi/2, false, groovePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
