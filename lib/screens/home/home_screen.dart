import 'package:flutter/material.dart';
import 'package:sand_valley/widgets/background_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                onTap: () => Navigator.pushNamed(context, '/admin-login'),
                child: const Center(
                  child: Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF7941D),
                      fontWeight: FontWeight.bold
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
