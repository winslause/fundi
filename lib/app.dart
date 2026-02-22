import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'landing_page.dart';
import 'home_page.dart';
import 'fundis_page.dart';
import 'jobs_page.dart';
import 'test_dashboards.dart';

class App extends StatelessWidget {
  const App({super.key});

  Future<bool> _isFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final hasVisited = prefs.getBool('has_visited') ?? false;
    if (!hasVisited) {
      await prefs.setBool('has_visited', true);
    }
    return !hasVisited;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundi Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: FutureBuilder<bool>(
        future: _isFirstVisit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final isFirstVisit = snapshot.data ?? false;
          if (isFirstVisit) {
            return const LandingPage();
          }
          return const HomePage();
        },
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/fundis': (context) => const FundisPage(),
        '/jobs': (context) => const JobsPage(),
        '/client_dashboard': (context) => const TestClientDashboard(),
        '/fundi_dashboard': (context) => const TestFundiDashboard(),
        '/admin_dashboard': (context) => const TestAdminDashboard(),
      },
    );
  }
}