import 'package:flutter/material.dart';
import 'package:sand_valley/routes/app_routes.dart';
import 'package:sand_valley/screens/splash/splash_screen.dart';

void main() {
  runApp(const SandValleyApp());
}

class SandValleyApp extends StatelessWidget {
  const SandValleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sand Valley',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF7941D),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFF7941D),
        highlightColor: const Color(0xFFF7941D),
        splashColor: const Color(0xFFF7941D).withOpacity(0.1),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFF7941D),
          selectionColor: Color(0xFFFFD8B0),
          selectionHandleColor: Color(0xFFF7941D),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7941D),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF7941D)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFF7941D), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
