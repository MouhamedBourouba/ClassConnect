import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/presentation/cubit/home/join_class/join_class_cubit.dart';
import 'package:ClassConnect/presentation/cubit/home/main_page/home_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/create_class_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/join_class_dialog.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return state.when(
            loading: () => const ColoredBox(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            loaded: (user, classes, teachers) => HomeBody(
              currentUser: user,
              theme: theme,
              classes: classes,
              teachers: teachers,
            ),
            error: (errorMessage) => Scaffold(body: Center(child: Text(errorMessage))),
          );
        },
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.theme,
    required this.currentUser,
    required this.classes,
    required this.teachers,
  });

  final ThemeData theme;
  final User currentUser;
  final List<Class> classes;
  final List<User> teachers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
        backgroundColor: theme.colorScheme.secondary,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Text(
              currentUser.firstName.firstLatter(),
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
            builder: (ctx) => const ClassesOptionsBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: HomeDrawer(theme: theme, currentUser: currentUser),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final class_ = classes[index];
          final teacher = teachers.where((user) => user.id == class_.creatorId).first;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 6,
            child: ListTile(
              leading: CircleAvatar(
                foregroundImage: AssetImage(class_.subject.getSubjectIconPath()),
                backgroundColor: Colors.transparent,
              ),
              subtitle: Text("Teacher: ${teacher.username}"),
              title: Text(class_.className),
              trailing: Text(
                "class code: ${class_.id}",
                style: theme.textTheme.caption,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            ),
          );
        },
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.theme,
    required this.currentUser,
  });

  final ThemeData theme;
  final User currentUser;

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
                      currentUser.firstName.firstLatter(),
                      style: theme.textTheme.headline6!.copyWith(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  currentUser.username,
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
  });

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
              showDialog(
                context: context,
                builder: (context) => BlocProvider(
                  child: const JoinClassDialog(),
                  create: (c) => JoinClassCubit(),
                ),
              );
            },
            child: const Text("Join class"),
          )
        ],
      ),
    );
  }
}
