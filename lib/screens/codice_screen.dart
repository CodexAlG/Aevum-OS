import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/note_provider.dart';
import 'package:aevum_os/screens/note_detail_screen.dart';
import 'package:aevum_os/screens/create_note_screen.dart';
import 'package:aevum_os/theme/app_colors.dart';

class CodiceScreen extends StatelessWidget {
  const CodiceScreen({super.key});

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
              _buildTitle(context),
              const SizedBox(height: 32),
              _buildRecordList(context),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateNoteScreen()),
          ),
          backgroundColor: AppColors.card,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.primary, width: 1),
          ),
          child: const Icon(Icons.edit_outlined, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EL CÓDICE', style: Theme.of(context).textTheme.headlineMedium),
        Text('ARCHIVOS DE DATOS Y REGISTROS', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }

  Widget _buildRecordList(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, provider, child) {
        if (provider.notes.isEmpty) {
          return const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, color: AppColors.textSub, size: 48),
                  SizedBox(height: 16),
                  Text('SIN REGISTROS EN EL ARCHIVO',
                      style: TextStyle(color: AppColors.textSub, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: provider.notes.length,
            padding: const EdgeInsets.only(bottom: 180),
            itemBuilder: (context, index) => _buildDataFile(context, provider.notes[index]),
          ),
        );
      },
    );
  }

  Widget _buildDataFile(BuildContext context, Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NoteDetailScreen(note: note)),
          ),
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.article_outlined, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '0x${note.id.length > 4 ? note.id.substring(note.id.length - 4) : note.id}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSub, letterSpacing: 1),
                          ),
                          Text(note.date,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.title.toUpperCase(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textTitle, height: 1.4),
                      ),
                      if (note.content.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSub, height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
