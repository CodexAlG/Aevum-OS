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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => _showForgeModal(context),
          backgroundColor: AppColors.card,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.primary, width: 1),
          ),
          icon: const Icon(Icons.add, color: AppColors.primary, size: 20),
          label: const Text(
            '+ FORJAR DESAFÍO',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 1,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EL GREMIO', style: Theme.of(context).textTheme.headlineMedium),
        Text('DESAFÍOS TÁCTICOS DISPONIBLES', style: Theme.of(context).textTheme.labelSmall),
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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

        if (filtered.isEmpty) {
          return const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.textSub, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'SIN DESAFÍOS ACTIVOS',
                    style: TextStyle(color: AppColors.textSub, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.only(bottom: 180),
            itemBuilder: (context, index) => _buildTacticalCard(filtered[index]),
          ),
        );
      },
    );
  }

  Widget _buildTacticalCard(Mission mission) {
    final Color rankColor = mission.rank == 'E'
        ? AppColors.rankLow
        : mission.rank == 'B'
            ? AppColors.rankMid
            : AppColors.rankHigh;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: rankColor.withValues(alpha: 0.12), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.heavyImpact();
            context.read<PlayerProvider>().addXp(mission.xp, mission.attribute);
            context.read<MissionProvider>().completeMission(mission.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('MISIÓN COMPLETADA: +${mission.xp} XP EN ${mission.attribute.toUpperCase()}'),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          onLongPress: () => _showDeleteConfirm(context, mission),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: rankColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mission.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textTitle, fontSize: 14)),
                      if (mission.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(mission.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSub)),
                        ),
                      const SizedBox(height: 4),
                      Text('RANGO ${mission.rank}  •  ${mission.attribute.toUpperCase()}  •  +${mission.xp} XP',
                          style: TextStyle(fontSize: 10, color: rankColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.check_circle_outline, color: AppColors.textSub, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, Mission mission) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('ELIMINAR DESAFÍO', style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: Text('¿Borrar "${mission.title}"?', style: const TextStyle(color: AppColors.textSub)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR', style: TextStyle(color: AppColors.textSub))),
          TextButton(
            onPressed: () {
              context.read<MissionProvider>().deleteMission(mission.id);
              Navigator.pop(ctx);
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showForgeModal(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String rank = 'E';
    int xp = 50;
    String category = _selectedCategory;
    String attribute = 'Enfoque';

    final List<String> attributes = ['Fuerza', 'Logica', 'Sabiduria', 'Constancia', 'Enfoque', 'Vitalidad'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setModalState) => AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        const SizedBox(width: 12),
                        const Text('NUEVA FORJA',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 2)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    TextField(
                      controller: titleController,
                      autofocus: false,
                      style: const TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'NOMBRE DEL DESAFÍO',
                        hintStyle: const TextStyle(color: AppColors.textSub, fontSize: 12),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description field
                    TextField(
                      controller: descController,
                      autofocus: false,
                      maxLines: 3,
                      style: const TextStyle(color: AppColors.textSub, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'DESCRIPCIÓN (OPCIONAL)',
                        hintStyle: const TextStyle(color: AppColors.textSub, fontSize: 12),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Attribute selector
                    const Text('ATRIBUTO A POTENCIAR',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: attributes.map((attr) {
                          bool sel = attribute == attr;
                          return GestureDetector(
                            onTap: () => setModalState(() => attribute = attr),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: sel ? AppColors.primary : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                attr.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: sel ? AppColors.surface : AppColors.textSub,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Rank selector
                    const Text('DIFICULTAD / RANGO',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRankOption('E', 'CIAN', AppColors.rankLow, 50, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                        _buildRankOption('B', 'PÚRPURA', AppColors.rankMid, 150, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                        _buildRankOption('S', 'ORO', AppColors.rankHigh, 500, rank, (r, x) => setModalState(() { rank = r; xp = x; })),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Category/Plazo selector
                    const Text('PLAZO',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ['Diarias', 'Corto Plazo', 'Épicas'].map((cat) {
                        bool sel = category == cat;
                        return GestureDetector(
                          onTap: () => setModalState(() => category = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? AppColors.primary : Colors.transparent),
                            ),
                            child: Text(
                              cat.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: sel ? AppColors.primary : AppColors.textSub,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            context.read<MissionProvider>().addMission(Mission(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  title: titleController.text.toUpperCase(),
                                  description: descController.text,
                                  category: category,
                                  xp: xp,
                                  rank: rank,
                                  attribute: attribute,
                                ));
                            setState(() => _selectedCategory = category);
                            Navigator.pop(sheetCtx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('GUARDAR EN EL GREMIO',
                            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.surface)),
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

  Widget _buildRankOption(String r, String label, Color color, int valXp, String currentRank, Function(String, int) onSelect) {
    bool isSelected = currentRank == r;
    return GestureDetector(
      onTap: () => onSelect(r, valXp),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 1.5),
        ),
        child: Column(
          children: [
            Text(r, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 8, color: isSelected ? color : AppColors.textSub, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
