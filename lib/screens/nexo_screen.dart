import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';
import 'package:aevum_os/widgets/xp_halo_avatar.dart';
import 'package:aevum_os/services/quote_service.dart';

class NexoScreen extends StatelessWidget {
  const NexoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<PlayerProvider>(
          builder: (context, player, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHUD(player),
                  const SizedBox(height: 32),
                  _buildOracleSection(),
                  const SizedBox(height: 32),
                  _buildEvolutionChart(),
                  const SizedBox(height: 32),
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
        Text(
          '${player.level}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: AppColors.textTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildOracleSection() {
    return FutureBuilder<Map<String, String>>(
      future: QuoteService.getDailyQuote(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        final quoteData = snapshot.data!;
        final category = quoteData['category'];
        final quote = quoteData['quote'];

        IconData categoryIcon;
        switch (category) {
          case 'Software': categoryIcon = Icons.code; break;
          case 'Gym': categoryIcon = Icons.fitness_center; break;
          case 'Fútbol': categoryIcon = Icons.sports_soccer; break;
          case 'Volley': categoryIcon = Icons.sports_volleyball; break;
          case 'RPG': categoryIcon = Icons.sports_esports; break;
          default: categoryIcon = Icons.format_quote;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Icon(categoryIcon, color: AppColors.primary, size: 24),
              const SizedBox(height: 12),
              Text(
                quote ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category?.toUpperCase() ?? '',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary.withValues(alpha: 0.5),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEvolutionChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'EVOLUCIÓN TEMPORAL',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    spots: const [
                      FlSpot(0, 30),
                      FlSpot(1, 45),
                      FlSpot(2, 40),
                      FlSpot(3, 60),
                      FlSpot(4, 55),
                      FlSpot(5, 80),
                      FlSpot(6, 75),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnfoqueSection(PlayerProvider player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ENFOQUE DEL DÍA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.textSub,
            letterSpacing: 5,
          ),
        ),
        const SizedBox(height: 24),
        _buildRPGCard(title: 'Meditación Matutina', xp: 50, player: player),
        _buildRPGCard(title: 'Lectura Técnica', xp: 120, player: player),
        _buildRPGCard(title: 'Entrenamiento Épico', xp: 250, player: player),
      ],
    );
  }

  Widget _buildRPGCard({required String title, required int xp, required PlayerProvider player}) {
    Color rankColor = xp <= 50 ? AppColors.rankLow : xp <= 150 ? AppColors.rankMid : AppColors.rankHigh;
    String rankLetter = xp <= 50 ? 'B' : xp <= 150 ? 'A' : 'S';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: () => player.completarDesafio(xp),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textTitle)),
        subtitle: Text('RANGO $rankLetter', style: TextStyle(fontSize: 10, color: rankColor, fontWeight: FontWeight.bold, letterSpacing: 1)),
        trailing: Text('+$xp', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.textTitle)),
      ),
    );
  }
}
