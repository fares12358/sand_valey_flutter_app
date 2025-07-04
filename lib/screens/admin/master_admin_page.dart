import 'package:flutter/material.dart';

class MasterAdminPage extends StatelessWidget {
  const MasterAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Admin Dashboard')),
      body: const Center(child: Text('Welcome Master Admin')),
    );
  }
}
