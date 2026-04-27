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
                  _buildTitle(context),
                  const SizedBox(height: 32),
                  _buildHUD(player),
                  const SizedBox(height: 40),
                  _buildRadarChart(player),
                  const SizedBox(height: 40),
                  _buildOracleSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EL NEXO',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'CENTRO DE OPERACIONES Y ANÁLISIS',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildHUD(PlayerProvider player) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakBadge(player),
              _buildCentralCore(player),
              _buildLevelBadge(player),
            ],
          ),
          const SizedBox(height: 24),
          _buildXpBar(player),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(PlayerProvider player) {
    return Column(
      children: [
        const Icon(Icons.local_fire_department, color: AppColors.primary, size: 28),
        const SizedBox(height: 4),
        const Text(
          'STREAK',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: AppColors.textSub,
            letterSpacing: 1,
          ),
        ),
        Text(
          '${player.streak} DÍAS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: AppColors.textTitle,
            shadows: [
              Shadow(
                color: AppColors.primary.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge(PlayerProvider player) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.rankHigh.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Text(
            'S',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.rankHigh,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'LVL ${player.level}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.textTitle,
            letterSpacing: 1,
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
          xp: player.currentXp,
          nextLevelXp: player.nextLevelXp,
          level: player.level,
        ),
        const CircleAvatar(
          radius: 35,
          backgroundColor: AppColors.surface,
          backgroundImage: AssetImage('assets/icon/logo_foreground.png'), // New Aevum Logo (Transparent)
        ),
      ],
    );
  }

  Widget _buildXpBar(PlayerProvider player) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'EVOLUCIÓN DE NÚCLEO',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSub, letterSpacing: 1),
            ),
            Text(
              '${player.currentXp} / ${player.nextLevelXp} XP',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: player.currentXp / player.nextLevelXp,
            minHeight: 4,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChart(PlayerProvider player) {
    final attrs = player.attributes;
    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'ANÁLISIS DE ATRIBUTOS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                radarBorderData: const BorderSide(color: Colors.transparent),
                gridBorderData: BorderSide(color: AppColors.textSub.withValues(alpha: 0.2), width: 1),
                tickBorderData: const BorderSide(color: Colors.transparent),
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                tickCount: 3,
                titlePositionPercentageOffset: 0.2,
                titleTextStyle: const TextStyle(color: AppColors.textSub, fontSize: 10, fontWeight: FontWeight.bold),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0: return const RadarChartTitle(text: 'FUERZA');
                    case 1: return const RadarChartTitle(text: 'LÓGICA');
                    case 2: return const RadarChartTitle(text: 'SABIDURÍA');
                    case 3: return const RadarChartTitle(text: 'CONSTANCIA');
                    case 4: return const RadarChartTitle(text: 'ENFOQUE');
                    case 5: return const RadarChartTitle(text: 'VITALIDAD');
                    default: return const RadarChartTitle(text: '');
                  }
                },
                dataSets: [
                  RadarDataSet(
                    fillColor: AppColors.primary.withValues(alpha: 0.4),
                    borderColor: AppColors.primary,
                    borderWidth: 2,
                    entryRadius: 3,
                    dataEntries: [
                      RadarEntry(value: attrs['Fuerza'] ?? 0),
                      RadarEntry(value: attrs['Logica'] ?? 0),
                      RadarEntry(value: attrs['Sabiduria'] ?? 0),
                      RadarEntry(value: attrs['Constancia'] ?? 0),
                      RadarEntry(value: attrs['Enfoque'] ?? 0),
                      RadarEntry(value: attrs['Vitalidad'] ?? 0),
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Icon(categoryIcon, color: AppColors.primary, size: 24),
              const SizedBox(height: 16),
              Text(
                quote ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSub,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category?.toUpperCase() ?? '',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary.withValues(alpha: 0.4),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
