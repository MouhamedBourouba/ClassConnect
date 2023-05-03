import 'dart:convert';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/settings_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/ui/pages/email_verification_page.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  StatelessWidget firstScreen() {
    final settingRepository = getIt<SettingsRepository>();
    if (!settingRepository.isAuthenticated()) {
      return const LoginScreen();
    } else if (!settingRepository.isEmailVerified()) {
      return const EmailVerificationPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassConnect',
      debugShowCheckedModeBanner: false,
      home: firstScreen(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          secondary: Color.fromRGBO(63, 114, 175, 1),
          primary: Color.fromRGBO(17, 45, 78, 1),
          background: Color.fromRGBO(219, 226, 239, 1),
          onSecondary: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
