import 'package:flutter/material.dart';
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
    {'id': 1, 'title': 'HIDRATACIÓN', 'category': 'Diarias', 'xp': 50, 'isDone': false},
    {'id': 2, 'title': 'LECTURA', 'category': 'Diarias', 'xp': 120, 'isDone': false},
    {'id': 3, 'title': 'CÓDIGO PURO', 'category': 'Corto Plazo', 'xp': 300, 'isDone': false},
    {'id': 4, 'title': 'MARATÓN VOID', 'category': 'Épicas', 'xp': 1500, 'isDone': false},
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
              _buildCategoryTabs(),
              const SizedBox(height: 32),
              _buildMissionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EL GREMIO',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 2),
        ),
        Text(
          'DESAFÍOS TÁCTICOS DISPONIBLES',
          style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 3),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Diarias', 'Corto Plazo', 'Épicas'].map((cat) {
        bool isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 15)] : [],
            ),
            child: Text(
              cat.toUpperCase(),
              style: TextStyle(
                color: isSelected ? AppColors.surface : AppColors.textSub,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMissionList() {
    final filtered = _missions.where((m) => m['category'] == _selectedCategory && !m['isDone']).toList();
    return Expanded(
      child: ListView.builder(
        itemCount: filtered.length,
        padding: const EdgeInsets.only(bottom: 130),
        itemBuilder: (context, index) => _buildTacticalCard(filtered[index]),
      ),
    );
  }

  Widget _buildTacticalCard(Map<String, dynamic> mission) {
    int xp = mission['xp'];
    Color rankColor = xp <= 50 ? AppColors.rankLow : xp <= 150 ? AppColors.rankMid : AppColors.rankHigh;
    String rankLetter = xp <= 50 ? 'B' : xp <= 150 ? 'A' : 'S';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10)),
          BoxShadow(color: rankColor.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: -5),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Rank Background Text
            Positioned(
              right: -10, top: -10,
              child: Text(
                rankLetter,
                style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: rankColor.withValues(alpha: 0.05)),
              ),
            ),
            
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<PlayerProvider>().completarDesafio(xp);
                  setState(() => mission['isDone'] = true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: rankColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Icon(Icons.shield_outlined, color: rankColor, size: 24),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mission['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textTitle)),
                            const SizedBox(height: 4),
                            Text('RANGO $rankLetter', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: rankColor, letterSpacing: 2)),
                          ],
                        ),
                      ),
                      Text('+$xp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textTitle)),
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
}
