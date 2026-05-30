import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/onboarding_screen.dart';
import 'services/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HelpConnect',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
