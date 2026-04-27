import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/note_provider.dart';
import 'package:aevum_os/screens/create_note_screen.dart';
import 'package:aevum_os/theme/app_colors.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textTitle, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreateNoteScreen(noteToEdit: note)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  note.date,
                  style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2,
                  ),
                ),
                const Text(
                  'REF: SECURE_DATA',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textSub),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 1, height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 32),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16, color: AppColors.textSub, height: 1.8, letterSpacing: 0.5),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('ELIMINAR REGISTRO', style: TextStyle(color: AppColors.textTitle, fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: const Text('Esta acción es permanente.', style: TextStyle(color: AppColors.textSub)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR', style: TextStyle(color: AppColors.textSub))),
          TextButton(
            onPressed: () {
              context.read<NoteProvider>().removeNote(note.id);
              Navigator.pop(ctx);
              Navigator.pop(context); // Back to codice
            },
            child: const Text('ELIMINAR', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
