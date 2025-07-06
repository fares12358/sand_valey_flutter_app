import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sand_valley/widgets/background_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
 
  Future<void> _handleAdminTap() async {
  final role = await _secureStorage.read(key: 'role');

  if (role != null) {
    if (role == 'admin') {
      Navigator.pushNamed(context, '/admin-master');
    } else if (role == 'user') {
      Navigator.pushNamed(context, '/admin');
    } else {
      Navigator.pushNamed(context, '/admin-login');
    }
  } else {
    Navigator.pushNamed(context, '/admin-login');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        child: Stack(
          children: [
            const Center(
              child: Text(
                'Welcome to Sand Valley',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _handleAdminTap,
                child: const Center(
                  child: Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF7941D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
