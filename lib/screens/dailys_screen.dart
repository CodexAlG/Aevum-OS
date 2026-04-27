import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/dailys_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class DailysScreen extends StatelessWidget {
  const DailysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer<DailysProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 32),
                  _buildHeader(context, provider),
                  const SizedBox(height: 24),
                  _buildHabitList(context, provider),
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
        Text('LAS DAILYS', style: Theme.of(context).textTheme.headlineMedium),
        Text('RUTINAS DE ALTO RENDIMIENTO', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, DailysProvider provider) {
    final hasHabits = provider.habits.isNotEmpty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'CONTRATO DIARIO',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSub, letterSpacing: 2),
        ),
        TextButton.icon(
          onPressed: () => _showEditRoutineModal(context, provider),
          icon: Icon(hasHabits ? Icons.edit_outlined : Icons.security,
              size: 14, color: AppColors.primary),
          label: Text(
            hasHabits ? 'EDITAR RUTINA' : 'DEFINIR RUTINA BASE',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitList(BuildContext context, DailysProvider provider) {
    if (provider.habits.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined, color: AppColors.textSub, size: 48),
              SizedBox(height: 16),
              Text('SIN CONTRATO ACTIVO',
                  style: TextStyle(color: AppColors.textSub, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('DEFINE TU RUTINA PARA COMENZAR',
                  style: TextStyle(color: AppColors.textSub, fontSize: 8, letterSpacing: 1)),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: provider.habits.length,
        padding: const EdgeInsets.only(bottom: 130),
        itemBuilder: (context, index) {
          final habit = provider.habits[index];
          return _buildHabitCard(context, habit);
        },
      ),
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: habit.isCompleted ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: () => context.read<DailysProvider>().toggleHabit(habit.id, context),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit.isCompleted ? AppColors.primary : AppColors.textSub.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  color: habit.isCompleted ? AppColors.primary : Colors.transparent,
                ),
                child: Icon(Icons.check, size: 16,
                    color: habit.isCompleted ? AppColors.surface : Colors.transparent),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  habit.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: habit.isCompleted ? AppColors.textSub : AppColors.textTitle,
                    decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (habit.isCompleted)
                const Icon(Icons.bolt, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditRoutineModal(BuildContext context, DailysProvider provider) {
    final List<TextEditingController> controllers = List.generate(
      5,
      (i) => TextEditingController(
        text: i < provider.habits.length ? provider.habits[i].title : '',
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setModalState) {
          final int filledCount =
              controllers.where((c) => c.text.isNotEmpty).length;
          return AnimatedPadding(
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
                    Row(
                      children: [
                        const Icon(Icons.security,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('EDITAR RUTINA BASE',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textTitle,
                                  letterSpacing: 2)),
                        ),
                        Text('$filledCount/5',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: filledCount >= 5
                                  ? AppColors.rankHigh
                                  : AppColors.primary,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'MÁXIMO 5 HÁBITOS. TUS COMPROMISOS DIARIOS.',
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textSub,
                          letterSpacing: 1),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controllers[index],
                                autofocus: false,
                                onChanged: (_) => setModalState(() {}),
                                style: const TextStyle(
                                    color: AppColors.textTitle, fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'HÁBITO # ${index + 1}',
                                  hintStyle: const TextStyle(
                                      color: AppColors.textSub, fontSize: 12),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                  prefixIcon: const Icon(Icons.bolt,
                                      size: 16, color: AppColors.primary),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            if (controllers[index].text.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  controllers[index].clear();
                                  setModalState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.danger
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.delete_outline,
                                      size: 18, color: AppColors.danger),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final titles = controllers
                              .map((c) => c.text.trim())
                              .where((t) => t.isNotEmpty)
                              .toList();
                          if (titles.isNotEmpty) {
                            context
                                .read<DailysProvider>()
                                .redefineRoutine(titles);
                            Navigator.pop(sheetCtx);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('GUARDAR RUTINA',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: AppColors.surface)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
