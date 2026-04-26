import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class CodiceScreen extends StatefulWidget {
  const CodiceScreen({super.key});

  @override
  State<CodiceScreen> createState() => _CodiceScreenState();
}

class _CodiceScreenState extends State<CodiceScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _records = [
    {
      'text': 'Iniciando el sistema operativo Aevum. La sincronización de los núcleos está al 85%.',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'text': 'Objetivo del día: Completar la arquitectura del Códice y definir el sistema de misiones.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'text': 'Nota mental: La persistencia de datos offline es prioritaria para el Nexo.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  void _addRecord() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _records.insert(0, {
          'text': _controller.text.trim(),
          'date': DateTime.now(),
        });
        _controller.clear();
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
      'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC'
    ];
    String day = date.day.toString().padLeft(2, '0');
    String month = months[date.month - 1];
    String year = date.year.toString();
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    
    return '$day $month $year - $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildInputTerminal(),
              const SizedBox(height: 32),
              _buildRecordsList(),
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
          'EL CÓDICE',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textTitle,
            letterSpacing: -1,
          ),
        ),
        Text(
          'REGISTROS Y DESCARGA MENTAL',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildInputTerminal() {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: AppColors.textTitle),
      decoration: InputDecoration(
        hintText: '> Iniciar registro...',
        hintStyle: const TextStyle(color: AppColors.textSub),
        fillColor: AppColors.card,
        filled: true,
        suffixIcon: IconButton(
          icon: const Icon(Icons.send_rounded, color: AppColors.primary),
          onPressed: _addRecord,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onSubmitted: (_) => _addRecord(),
    );
  }

  Widget _buildRecordsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _records.length,
        padding: const EdgeInsets.only(bottom: 130),
        itemBuilder: (context, index) {
          final record = _records[index];
          return _buildRecordCard(record['text'], record['date']);
        },
      ),
    );
  }

  Widget _buildRecordCard(String text, DateTime date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: const Border(
          left: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                color: AppColors.textSub,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textTitle,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
