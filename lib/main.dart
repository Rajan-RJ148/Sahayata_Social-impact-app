import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'config/app_config.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const HelpConnectApp());
}

class HelpConnectApp extends StatelessWidget {
  const HelpConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      // For demo purposes, start with onboarding
      // In production, check if user is logged in
      home: const OnboardingScreen(),
      // home: const MainScreen(),
    );
  }
}
