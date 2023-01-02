import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:school_app/data/hive.dart';
import 'package:school_app/domain/controllers/complete_account_provider.dart';
import 'package:school_app/domain/controllers/home_provider.dart';
import 'package:school_app/domain/controllers/login_controller.dart';
import 'package:school_app/domain/controllers/register_controller.dart';
import 'package:school_app/domain/utils/locator.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();
  await setUpHive();
  final pref = GetIt.I.get<SharedPreferences>();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LoginProvider()),
        ChangeNotifierProvider(create: (ctx) => HomeProvider()),
        ChangeNotifierProvider(create: (ctx) => CompleteAccountProvider()),
        ChangeNotifierProvider(create: (ctx) => RegisterProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: pref.getBool("isAccountCompleted") == true
            ? HomePage()
            : pref.getBool("isLoggedIn") == true
                ? const CompleteAccountPage()
                : const LoginPage(),
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            secondary: Color.fromRGBO(63, 114, 175, 1),
            primary: Color.fromRGBO(17, 45, 78, 1),
            background: Color.fromRGBO(219, 226, 239, 1),
            onSecondary: Colors.white,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
      ),
    ),
  );
}
