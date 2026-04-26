import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class CodiceScreen extends StatefulWidget {
  const CodiceScreen({super.key});

  @override
  State<CodiceScreen> createState() => _CodiceScreenState();
}

class _CodiceScreenState extends State<CodiceScreen> {
  final List<Map<String, dynamic>> _records = [
    {'text': 'Protocolo Aurora inicializado.', 'date': '26 ABRIL'},
    {'text': 'Sincronización de núcleo al 85%.', 'date': '25 ABRIL'},
    {'text': 'Entrenamiento de enfoque completado.', 'date': '24 ABRIL'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 32),
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildRecordList(),
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
          'EL CÓDICE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.textTitle, letterSpacing: 2),
        ),
        Text(
          'ARCHIVOS DE DATOS Y REGISTROS',
          style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 3),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const TextField(
        style: TextStyle(color: AppColors.textTitle),
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: AppColors.primary, size: 20),
          hintText: 'BUSCAR EN ARCHIVOS...',
          hintStyle: TextStyle(color: AppColors.textSub, fontSize: 12, letterSpacing: 1),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildRecordList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _records.length,
        padding: const EdgeInsets.only(bottom: 130),
        itemBuilder: (context, index) => _buildDataFile(_records[index]),
      ),
    );
  }

  Widget _buildDataFile(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.5),
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: AppColors.border,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('REF_DATA_ID: 0x${2048 + 1}', style: TextStyle(fontSize: 8, color: AppColors.textSub, fontWeight: FontWeight.bold)),
                Text(record['date'], style: const TextStyle(fontSize: 8, color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              record['text'].toUpperCase(),
              style: const TextStyle(fontSize: 13, color: AppColors.textTitle, height: 1.5, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
