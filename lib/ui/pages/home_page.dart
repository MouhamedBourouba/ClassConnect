import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/extentions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final username = GetIt.I.get<SharedPreferences>().getString("username");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Classes"),
          backgroundColor: theme.colorScheme.secondary,
          // leading: IconButton(onPressed: () {
          //
          // }, icon: const Icon(Icons.menu)),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          username?.firstLatter() ?? "A",
                          style: theme.textTheme.headline6!
                              .copyWith(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      username ?? "username",
                      style: theme.textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
