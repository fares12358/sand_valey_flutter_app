import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<void> _logout(BuildContext context) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.deleteAll(); // Clear token, role, etc.
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
      body: const Center(child: Text('Admin')),
    );
  }
}
