import 'package:flutter/material.dart';
import 'package:sand_valley/screens/home/test.dart';
import 'package:sand_valley/screens/splash/splash_screen.dart';
import 'package:sand_valley/screens/home/home_screen.dart';

//admin
import 'package:sand_valley/screens/admin/admin_page.dart';
import 'package:sand_valley/screens/admin/master_admin_page.dart';
import 'package:sand_valley/screens/admin/admin_login_screen.dart';
import '../screens/admin/forgot_password_screen.dart';
import 'package:sand_valley/screens/admin/otp_screen.dart';
import 'package:sand_valley/screens/admin/reset_password_screen.dart';

// Communicate
import 'package:sand_valley/screens/Communicate/Communicate-main.dart';
import 'package:sand_valley/screens/Communicate/Communicate-eng.dart';
import 'package:sand_valley/screens/Communicate/Communicate-call.dart';

// Fertilizer
import 'package:sand_valley/screens/Fertilizer/Fertilizer-main.dart';
import 'package:sand_valley/screens/Fertilizer/Fertilizer-type-one.dart';
import 'package:sand_valley/screens/Fertilizer/Fertilizer-type-two.dart';
import 'package:sand_valley/screens/Fertilizer/Fertilizer.description.dart';

// Insecticide
import 'package:sand_valley/screens/Insecticide/Insecticide-main.dart';
import 'package:sand_valley/screens/Insecticide/Insecticide-type.dart';
import 'package:sand_valley/screens/Insecticide/Insecticide.description.dart';

// Seeds
import 'package:sand_valley/screens/seeds/seed-main.dart';
import 'package:sand_valley/screens/seeds/seed-type.dart';
import 'package:sand_valley/screens/seeds/seed-description.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/home': (context) => const HomeScreen(),
    // '/home': (context) => const Test(),
    
    //admin
    '/admin-login': (context) => const AdminLoginScreen(),
    '/admin-master': (context) => const MasterAdminPage(),
    '/admin': (context) => const AdminPage(),
    '/admin-forgot-password': (context) => const ForgotPasswordScreen(),
    '/otp': (context) => const OtpScreen(),
    '/reset-password': (context) => const ResetPasswordScreen(),
    
    // Communicate
    '/communicate-main': (context) => const CommunicateMainPage(),
    '/communicate-eng': (context) => const CommunicateEngPage(),
    '/communicate-call': (context) => const CommunicateCallPage(),

    // Fertilizer
    '/fertilizer-main': (context) => const FertilizerMainPage(),
    '/fertilizer-type-one': (context) => const FertilizerTypeOnePage(),
    '/fertilizer-type-two': (context) => const FertilizerTypeTwoPage(),
    '/fertilizer-description': (context) => const FertilizerDescriptionPage(),

    // Insecticide
    '/insecticide-main': (context) => const InsecticideMainPage(),
    '/insecticide-type': (context) => const InsecticideTypePage(),
    '/insecticide-description': (context) => const InsecticideDescriptionPage(),

    // Seeds
    '/seed-main': (context) => const SeedMainPage(),
    '/seed-type': (context) => const SeedTypePage(),
    '/seed-description': (context) => const SeedDescriptionPage(),
  };
}
