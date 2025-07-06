import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MasterAdminPage extends StatelessWidget {
  const MasterAdminPage({super.key});

  Future<void> _logout(BuildContext context) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.deleteAll(); // clear all saved tokens/roles
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // red background
                foregroundColor: Colors.white, // white text
              ),
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
      body: const Center(child: Text('Master Admin')),
    );
  }
}