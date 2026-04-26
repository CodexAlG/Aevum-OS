import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aevum_os/providers/player_provider.dart';
import 'package:aevum_os/theme/app_theme.dart';
import 'package:aevum_os/screens/main_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aevum OS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainLayout(),
    );
  }
}
