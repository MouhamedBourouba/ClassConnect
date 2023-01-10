import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/data/extension.dart';
import 'package:school_app/domain/bloc/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeCubit = context.read<HomeCubit>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Classes"),
          backgroundColor: theme.colorScheme.secondary,
          actions: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                (homeCubit.state is Loaded) ? (homeCubit.state as Loaded).user.username.firstLatter() : 'A',
                style: theme.textTheme.headline6!.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
              ),
              builder: (ctx) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountPage()));
                      },
                      child: const Text("Create class"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Join class"),
                    )
                  ],
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
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

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create class"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text("Class name"),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
