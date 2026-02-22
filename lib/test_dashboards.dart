import 'package:flutter/material.dart';
import 'models.dart';
import 'data.dart';
import 'client_dashboard.dart';
import 'fundi_dashboard.dart';
import 'admin_dashboard.dart';

/// Test wrapper pages for dashboard testing purposes.
/// These pages use mock data to allow viewing dashboards without authentication.

class TestClientDashboard extends StatelessWidget {
  const TestClientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the first mock client for testing
    final client = MockData.clients.first;
    return ClientDashboard(client: client);
  }
}

class TestFundiDashboard extends StatelessWidget {
  const TestFundiDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the first mock fundi for testing
    final fundi = MockData.fundis.first;
    return FundiDashboard(fundi: fundi);
  }
}

class TestAdminDashboard extends StatelessWidget {
  const TestAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a mock admin for testing
    final admin = Admin(
      id: 'admin_1',
      name: 'Test Admin',
      email: 'admin@fundi.com',
      phone: '+254700000000',
      isVerified: true,
      joinedAt: DateTime(2023, 1, 1),
      department: 'Operations',
      permissions: ['all'],
    );
    return AdminDashboard(admin: admin);
  }
}
