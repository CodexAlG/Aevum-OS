import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  String _selectedPriority = '';
  String _selectedDifficulty = '';

  void _nextStep() {
    HapticFeedback.mediumImpact();
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      context.read<PlayerProvider>().initialize(_selectedPriority, _selectedDifficulty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [AppColors.card, AppColors.surface],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgress(),
                const SizedBox(height: 48),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _buildStepContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: List.generate(3, (index) {
        bool isActive = index <= _currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.border,
              borderRadius: BorderRadius.circular(2),
              boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 10)] : [],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildSelectionStep(
          key: const ValueKey(0),
          title: 'INICIALIZACIÓN DE NÚCLEO',
          subtitle: '¿CUÁL ES TU PRIORIDAD DE EVOLUCIÓN HOY?',
          options: [
            {'label': 'Enfoque', 'icon': Icons.psychology_outlined},
            {'label': 'Fuerza', 'icon': Icons.fitness_center_outlined},
            {'label': 'Disciplina', 'icon': Icons.shield_outlined},
          ],
          onSelect: (val) {
            _selectedPriority = val;
            _nextStep();
          },
        );
      case 1:
        return _buildSelectionStep(
          key: const ValueKey(1),
          title: 'CALIBRACIÓN DE CARGA',
          subtitle: '¿QUÉ TAN PESADO ES EL CAMINO?',
          options: [
            {'label': 'Bajo', 'icon': Icons.speed_outlined},
            {'label': 'Medio', 'icon': Icons.trending_up_outlined},
            {'label': 'Épico', 'icon': Icons.bolt_outlined},
          ],
          onSelect: (val) {
            _selectedDifficulty = val;
            _nextStep();
          },
        );
      default:
        return Column(
          key: const ValueKey(2),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 80),
            const SizedBox(height: 24),
            const Text(
              'SINCRONIZACIÓN COMPLETA',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 2),
            ),
            const SizedBox(height: 48),
            _buildActionCard('INICIAR PROTOCOLO AEVUM', () => _nextStep()),
          ],
        );
    }
  }

  Widget _buildSelectionStep({
    required Key key,
    required String title,
    required String subtitle,
    required List<Map<String, dynamic>> options,
    required Function(String) onSelect,
  }) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 4)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textTitle)),
        const SizedBox(height: 48),
        ...options.map((opt) => _buildSelectionCard(opt['label'], opt['icon'], () => onSelect(opt['label']))),
      ],
    );
  }

  Widget _buildSelectionCard(String label, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(width: 24),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textTitle)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: AppColors.border, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String label, VoidCallback onTap) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.surface, letterSpacing: 2))),
        ),
      ),
    );
  }
}
