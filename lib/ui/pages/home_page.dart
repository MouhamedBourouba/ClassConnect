import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/data/extension.dart';
import 'package:school_app/domain/bloc/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Classes"),
          backgroundColor: theme.colorScheme.secondary,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Text("+"),
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
                          "A",
                          style: theme.textTheme.headline6!.copyWith(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "username",
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
