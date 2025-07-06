import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2)); // optional loading time

    final token = await _secureStorage.read(key: 'token');
    final role = await _secureStorage.read(key: 'role');

    if (token != null && role != null) {
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin-master');
      } else if (role == 'user') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg-main-screen.png', fit: BoxFit.cover),
          Center(
            child: Image.asset('assets/images/logo.png', width: 180, height: 180),
          ),
        ],
      ),
    );
  }
}
