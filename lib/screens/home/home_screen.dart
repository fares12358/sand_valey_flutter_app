import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sand_valley/widgets/background_container.dart';
import 'package:sand_valley/widgets/customWidget.dart';
import 'package:sand_valley/widgets/customWidgetReversed.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BackgroundContainer(
        child: Container(
          margin: EdgeInsets.only(top: screenHeight * 0.05),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
          width: screenWidth,
          child: Column(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: customLayout(
                          image: "assets/images/seeds-img.png",
                          text: "بذور",
                          routeName: '/seed-main',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: customLayoutReversed(
                          image: "assets/images/seeds-img.png",
                          text: "اسمده",
                          routeName: '/fertilizer-main',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: customLayout(
                          image: "assets/images/seeds-img.png",
                          text: "مبيدات",
                          routeName: '/insecticide-main',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: customLayoutReversed(
                          image: "assets/images/seeds-img.png",
                          text: "تواصل معنا",
                          routeName: '/communicate-main',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextButton(
                  onPressed: _handleAdminTap,
                  child: const Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFF7941D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
