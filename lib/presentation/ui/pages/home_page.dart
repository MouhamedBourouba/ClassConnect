import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/presentation/cubit/home/join_class/join_class_cubit.dart';
import 'package:ClassConnect/presentation/cubit/home/main_page/home_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/class_page.dart';
import 'package:ClassConnect/presentation/ui/pages/create_class_page.dart';
import 'package:ClassConnect/presentation/ui/pages/login_page.dart';
import 'package:ClassConnect/presentation/ui/pages/profile_page.dart';
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
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeStateSingedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              const LoginScreen().asRoute(),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return state.map(
              loading: (loading) => const ColoredBox(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              loaded: (loaded) => HomeBody(
                theme: theme,
                homeState: loaded,
              ),
              error: (error) => Scaffold(body: Center(child: Text(error.errorMessage))),
              singOut: (HomeStateSingedOut value) => Container(),
            );
          },
        ),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.homeState, required this.theme});

  final ThemeData theme;
  final HomeStateLoaded homeState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classes"),
        backgroundColor: theme.colorScheme.secondary,
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(context, UpdateProfile().asRoute()),
            child: Hero(
              tag: "profile_avatar",
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  homeState.currentUser.fullName.firstLatter().toUpperCase(),
                  style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
              ),
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
      drawer: HomeDrawer(theme: theme, currentUser: homeState.currentUser, notificationCounter: homeState.notificationCounter),
      body: ListView.builder(
        itemCount: homeState.classes.length,
        itemBuilder: (context, index) {
          final class_ = homeState.classes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            elevation: 6,
            child: ListTile(
              leading: CircleAvatar(
                foregroundImage: AssetImage(class_.subject.getSubjectIconPath()),
                backgroundColor: Colors.transparent,
              ),
              subtitle: Text(
                "Teacher: ${context.read<HomeCubit>().getTeacher(class_).fullName}",
                maxLines: 1,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
              title: Text(
                class_.className,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                "code: ${class_.id}",
                style: theme.textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ClassPage(classId: class_.id);
                  }),
                );
              },
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
    this.notificationCounter,
  });

  final ThemeData theme;
  final User currentUser;
  final int? notificationCounter;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.secondary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueGrey,
                  child: Text(
                    currentUser.fullName.firstLatter().toUpperCase(),
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  currentUser.fullName,
                  style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  currentUser.email,
                  style: theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              "Notifications",
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Badge(
              label: Text(notificationCounter.toString()),
              isLabelVisible: notificationCounter != null,
              child: Icon(
                Icons.notifications,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              "Sing Out",
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Icon(
              Icons.logout,
              color: theme.colorScheme.primary,
            ),
            onTap: context.read<HomeCubit>().singOut,
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
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
