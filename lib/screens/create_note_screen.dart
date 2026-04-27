import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:aevum_os/providers/note_provider.dart';
import 'package:aevum_os/theme/app_colors.dart';

class CreateNoteScreen extends StatefulWidget {
  final Note? noteToEdit;

  const CreateNoteScreen({super.key, this.noteToEdit});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  // STT fix: snapshot of text BEFORE each listen session
  String _textoPrevio = '';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool get _isEditing => widget.noteToEdit != null;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _titleController = TextEditingController(text: widget.noteToEdit?.title ?? '');
    _contentController = TextEditingController(text: widget.noteToEdit?.content ?? '');
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        // FIX: snapshot current content BEFORE listening starts
        _textoPrevio = _contentController.text;
        setState(() => _isListening = true);
        _pulseController.repeat(reverse: true);
        _speech.listen(
          onResult: (val) {
            // FIX: always build from snapshot, never cumulate on top of result
            final separator = _textoPrevio.isNotEmpty &&
                    _textoPrevio[_textoPrevio.length - 1] != ' '
                ? ' '
                : '';
            _contentController.text =
                '$_textoPrevio$separator${val.recognizedWords}';
            _contentController.selection =
                TextSelection.collapsed(offset: _contentController.text.length);
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _pulseController.stop();
      _pulseController.reset();
      _speech.stop();
    }
  }

  void _save() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) return;
    final provider = context.read<NoteProvider>();

    if (_isEditing) {
      provider.removeNote(widget.noteToEdit!.id);
    }
    provider.addNote(_titleController.text, _contentController.text);
    Navigator.pop(context);
    if (_isEditing) Navigator.pop(context); // Back out of detail screen too
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEditing ? 'EDITAR REGISTRO' : 'NUEVO REGISTRO',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textTitle, letterSpacing: 2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSub),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'GUARDAR',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            // Title field — autofocus disabled, user taps to focus
            TextField(
              controller: _titleController,
              autofocus: false,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textTitle),
              decoration: const InputDecoration(
                hintText: 'TÍTULO DEL ARCHIVO',
                hintStyle: TextStyle(color: AppColors.textSub, fontSize: 20),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),
            // Content field — takes all available vertical space
            Expanded(
              child: TextField(
                controller: _contentController,
                autofocus: false,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16, color: AppColors.textSub, height: 1.7),
                decoration: const InputDecoration(
                  hintText: 'Escribe o usa el micrófono para dictar...',
                  hintStyle: TextStyle(color: AppColors.textSub, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            // Bottom HUD: mic button
            _buildMicHUD(),
          ],
        ),
      ),
    );
  }

  Widget _buildMicHUD() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (_isListening)
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: _listen,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? AppColors.primary : AppColors.card,
                    border: Border.all(
                      color: _isListening ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: _isListening
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 20)]
                        : [],
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? AppColors.surface : AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isListening ? 'ESCUCHANDO...' : 'DICTADO POR VOZ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: _isListening ? AppColors.primary : AppColors.textSub,
                  letterSpacing: 1,
                ),
              ),
              Text(
                _isListening ? 'Toca para detener' : 'Toca para dictar',
                style: const TextStyle(fontSize: 10, color: AppColors.textSub),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
