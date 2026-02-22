import 'package:flutter/material.dart';
import 'theme.dart';
import 'landing_page.dart'; // Import landing page instead of home_page

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundi Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingPage(), // Show landing page first
    );
  }
}