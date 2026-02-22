import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  // Ensure smooth performance and proper error handling
  runApp(const FundiMarketplaceApp());
}

class FundiMarketplaceApp extends StatelessWidget {
  const FundiMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}