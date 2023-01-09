import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:school_app/domain/bloc/authentication/complete_account/complete_account_cubit.dart';
import 'package:school_app/domain/bloc/authentication/login/login_cubit.dart';
import 'package:school_app/domain/bloc/authentication/register/register_cubit.dart';
import 'package:school_app/domain/bloc/home/cubit/home_cubit.dart';
import 'package:school_app/domain/utils/locator.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDi();
  final hiveBox = await GetIt.I.getAsync<Box>();
  // final userdata = await GetIt.I.getAsync<UserDataSource>();
  // final userFromDb = await userdata.fetchUserById(user.id);
  // debugPrint(user.toString());
  // debugPrint(userFromDb?.toMap().toString());
  final firstPage = hiveBox.get("isLoggedIn") == true ? hiveBox.get("isAccountCompleted") == true
      ? const HomePage()
      : const CompleteAccountPage() : const LoginScreen();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (ctx) => LoginCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => CompleteAccountCubit()),
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: App(firstPage: firstPage),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.firstPage,
  });

  final Widget firstPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: firstPage,
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
