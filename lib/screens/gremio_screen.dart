import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class GremioScreen extends StatefulWidget {
  const GremioScreen({super.key});

  @override
  State<GremioScreen> createState() => _GremioScreenState();
}

class _GremioScreenState extends State<GremioScreen> {
  String _selectedCategory = 'Diarias';

  final List<Map<String, dynamic>> _missions = [
    {
      'id': 1,
      'title': 'HIDRATACIÓN CONSCIENTE',
      'category': 'Diarias',
      'xp': 50,
      'description': 'Beber 2L de agua durante el día.',
      'isDone': false,
    },
    {
      'id': 2,
      'title': 'LECTURA PROFUNDA',
      'category': 'Diarias',
      'xp': 100,
      'description': '15 minutos de lectura sin distracciones.',
      'isDone': false,
    },
    {
      'id': 3,
      'title': 'PROYECTO AURORA',
      'category': 'Corto Plazo',
      'xp': 500,
      'description': 'Completar la fase de diseño inicial.',
      'isDone': false,
    },
    {
      'id': 4,
      'title': 'MARATÓN DE BIENESTAR',
      'category': 'Épicas',
      'xp': 2000,
      'description': '7 días seguidos de hábitos perfectos.',
      'isDone': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFilters(),
              const SizedBox(height: 32),
              _buildMissionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ENFOQUE DEL DÍA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitle,
            letterSpacing: -0.5,
          ),
        ),
        const Text(
          'DESAFÍOS ACTIVOS Y DIRECTRICES',
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

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Diarias', 'Corto Plazo', 'Épicas'].map((cat) {
        bool isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
            child: Text(
              cat,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSub,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMissionList() {
    final filtered = _missions
        .where((m) => m['category'] == _selectedCategory && !m['isDone'])
        .toList();
    
    return Expanded(
      child: filtered.isEmpty 
        ? Center(child: Text('Sin desafíos pendientes', style: TextStyle(color: AppColors.textSub)))
        : ListView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.only(bottom: 130),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildMissionCard(filtered[index]);
            },
          ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(mission['id']),
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _completeMission(mission),
            borderRadius: BorderRadius.circular(30),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(
                    Icons.panorama_fish_eye,
                    color: AppColors.textSub,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textTitle,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mission['description'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const ShapeDecoration(
                      color: AppColors.primary,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      '+${mission['xp']} XP',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _completeMission(Map<String, dynamic> mission) {
    HapticFeedback.heavyImpact();
    
    // Llama a completarDesafio con el valor de XP
    Provider.of<PlayerProvider>(context, listen: false).completarDesafio(mission['xp']);
    
    // Animación de desvanecimiento
    setState(() {
      mission['isDone'] = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Desafío completado! +${mission['xp']} XP'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
