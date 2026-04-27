import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class CodiceScreen extends StatefulWidget {
  const CodiceScreen({super.key});

  @override
  State<CodiceScreen> createState() => _CodiceScreenState();
}

class _CodiceScreenState extends State<CodiceScreen> {
  final List<Map<String, dynamic>> _records = [
    {'text': 'Protocolo Aurora inicializado.', 'date': '26 ABRIL', 'id': '0x0801'},
    {'text': 'Sincronización de núcleo al 85%.', 'date': '25 ABRIL', 'id': '0x0802'},
    {'text': 'Entrenamiento de enfoque completado.', 'date': '24 ABRIL', 'id': '0x0803'},
  ];

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EL CÓDICE',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'ARCHIVOS DE DATOS Y REGISTROS',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                        record['id'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSub,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        record['date'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record['text'].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textTitle,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
