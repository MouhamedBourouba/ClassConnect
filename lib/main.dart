import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/login_page.dart';

void main() async {
  await init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  StatelessWidget firstScreen() {
    final user = getIt<UserRepository>().getCurrentUser();
    if (user == null) {
      return const LoginScreen();
    } else if (user.firstName == null || user.lastName == null || user.parentPhone == null || user.grade == null) {
      return const CompleteAccountPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

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
