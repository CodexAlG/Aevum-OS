import 'package:flutter/material.dart';
import 'package:aevum_os/theme/app_colors.dart';

class DailysScreen extends StatelessWidget {
  const DailysScreen({super.key});

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
              const Expanded(
                child: Center(
                  child: Text(
                    'DAILYS PRÓXIMAMENTE',
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LAS DAILYS',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          'RUTINAS DE ALTO RENDIMIENTO',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
