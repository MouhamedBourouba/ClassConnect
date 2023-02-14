import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/domain/cubit/home/main_page/home_cubit.dart';
import 'package:school_app/domain/utils/extension.dart';
import 'package:school_app/ui/pages/create_class_page.dart';
import 'package:school_app/ui/widgets/outlined_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: SafeArea(
        child: HomeBody(theme: theme),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<HomeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
        backgroundColor: theme.colorScheme.secondary,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(
              homeCubit.state.currentUser?.firstName.firstLatter() ?? "A",
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
            builder: (ctx) => ClassesOptionsBottomSheet(homeCubit: homeCubit),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: HomeDrawer(theme: theme),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}

class ClassesOptionsBottomSheet extends StatelessWidget {
  const ClassesOptionsBottomSheet({
    super.key,
    required this.homeCubit,
  });

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateClassPage()));
            },
            child: const Text("Create class"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(context: context, builder: (context) => const JoinClassDialog());
            },
            child: const Text("Join class"),
          )
        ],
      ),
    );
  }
}

class JoinClassDialog extends StatelessWidget {
  const JoinClassDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.watch<HomeCubit>();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        height: 270,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -100,
              child: Image.asset(
                "assets/images/blackboard.png",
                width: 160,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 76),
                  Text(
                    "Join Class",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: homeCubit.onJoinClassIdChanged,
                    decoration: const InputDecoration(
                      hintText: "Class code",
                      border: outlinedInputBorder,
                      prefixIcon: Icon(Icons.code),
                      suffixIcon: Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        message: "Ask your teacher for the class code",
                        child: Icon(Icons.info_outline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: homeCubit.state.joinClassId.isNotEmpty ? homeCubit.joinClass : null,
                      child: const Text("join"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
