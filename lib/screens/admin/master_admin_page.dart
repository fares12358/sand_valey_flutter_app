import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sand_valley/components/account_settings_section.dart';
import 'package:sand_valley/components/add_account_section.dart';
import 'package:sand_valley/components/view_users_section.dart';

class MasterAdminPage extends StatefulWidget {
  const MasterAdminPage({super.key});

  @override
  State<MasterAdminPage> createState() => _MasterAdminPageState();
}

class _MasterAdminPageState extends State<MasterAdminPage> {
  final GlobalKey<ViewUsersSectionState> _viewUsersKey = GlobalKey();

  void _refreshUsers() {
    _viewUsersKey.currentState?.fetchUsers();
  }

  Future<void> _logout(BuildContext context) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildNavButton(String title,String rout) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/${rout.toLowerCase()}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF7941D),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7941D),
        title: const Text(
          'Master Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => _logout(context),
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg-main-screen.png', fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // btns
                    _buildNavButton('Seeds','seed-main-admin'),
                    const SizedBox(height: 12),
                    _buildNavButton('Fertilizer','fertilizer-admin'),
                    const SizedBox(height: 12),
                    _buildNavButton('Insecticide','insecticide-admin'),
                    const SizedBox(height: 12),
                    _buildNavButton('Comunicate','communicate-admin'),
                    const SizedBox(height: 30),
                    // components
                    const AccountSettingsSection(),
                    const SizedBox(height: 30),
                    AddAccountSection(onUserAdded: _refreshUsers),
                    const SizedBox(height: 30),
                    ViewUsersSection(key: _viewUsersKey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}