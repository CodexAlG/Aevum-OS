import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/providers/mission_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class GremioScreen extends StatefulWidget {
  const GremioScreen({super.key});

  @override
  State<GremioScreen> createState() => _GremioScreenState();
}

class _GremioScreenState extends State<GremioScreen> {
  String _selectedCategory = 'Diarias';

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
      floatingActionButton: _buildForgeButton(context),
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
            ),
            child: Text(
              cat.toUpperCase(),
              style: TextStyle(
                color: isSelected ? AppColors.surface : AppColors.textSub,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMissionList() {
    return Consumer<MissionProvider>(
      builder: (context, provider, child) {
        final filtered = provider.missions
            .where((m) => m.category == _selectedCategory && !m.isDone)
            .toList();
        
        return Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.only(bottom: 130),
            itemBuilder: (context, index) => _buildTacticalCard(filtered[index]),
          ),
        );
      },
    );
  }

  Widget _buildTacticalCard(Mission mission) {
    Color rankColor = mission.rank == 'B' ? AppColors.rankLow : mission.rank == 'A' ? AppColors.rankMid : AppColors.rankHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: rankColor.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.heavyImpact();
            context.read<PlayerProvider>().completarDesafio(mission.xp);
            context.read<MissionProvider>().completeMission(mission.id);
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.textSub),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mission.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textTitle)),
                      Text('RANGO ${mission.rank}', style: TextStyle(fontSize: 10, color: rankColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text('+${mission.xp}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textTitle)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForgeButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showForgeModal(context),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add, color: AppColors.surface),
      label: const Text('FORJAR DESAFÍO', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.surface, letterSpacing: 1)),
    );
  }

  void _showForgeModal(BuildContext context) {
    String title = '';
    String rank = 'B';
    int xp = 50;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NUEVA FORJA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 2)),
              const SizedBox(height: 24),
              TextField(
                onChanged: (val) => title = val,
                style: const TextStyle(color: AppColors.textTitle),
                decoration: InputDecoration(
                  hintText: 'NOMBRE DEL DESAFÍO',
                  hintStyle: const TextStyle(color: AppColors.textSub, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              const Text('SELECCIONAR RANGO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 2)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRankOption('E', 'Bajo', AppColors.rankLow, 50, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                  _buildRankOption('B', 'Medio', AppColors.rankMid, 150, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                  _buildRankOption('S', 'Difícil', AppColors.rankHigh, 500, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty) {
                      context.read<MissionProvider>().addMission(Mission(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: title.toUpperCase(),
                        category: _selectedCategory,
                        xp: xp,
                        rank: rank,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('GUARDAR EN EL GREMIO', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.surface)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRankOption(String r, String label, Color color, int valXp, String currentRank, Function(String, int) onSelect) {
    bool isSelected = currentRank == r;
    return GestureDetector(
      onTap: () => onSelect(r, valXp),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Column(
          children: [
            Text(r, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
            Text(label.toUpperCase(), style: TextStyle(fontSize: 8, color: isSelected ? color : AppColors.textSub)),
          ],
        ),
      ),
    );
  }
}
