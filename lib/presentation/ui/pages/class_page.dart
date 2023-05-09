import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/class_page/class_cubit.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ClassCubit(classId),
      child: Builder(
        builder: (context) {
          final classCubit = context.watch<ClassCubit>();
          final state = classCubit.state;
          const body = [_MessagesStream(), _Assignments(), _Members()];

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: Text(state.currentClass?.className ?? ""),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.message), label: "Stream"),
                BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_sharp), label: "assignment"),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "members"),
              ],
              onTap: classCubit.navigate,
              currentIndex: state.pageIndex,
            ),
            body: body[state.pageIndex],
          );
        },
      ),
    );
  }
}

class _MessagesStream extends StatelessWidget {
  const _MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ClassCubit>();
    final state = cubit.state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                "Share with your class ...",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: CupertinoColors.inactiveGray),
              ),
              leading: CircleAvatar(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(state.currentUser?.fullName[0].toUpperCase() ?? "A"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Assignments extends StatelessWidget {
  const _Assignments({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _Members extends StatelessWidget {
  const _Members({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ClassCubit>();
    final state = cubit.state;
    if (state.pageState == PageState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.pageState == PageState.error) {
      getIt<ErrorLogger>().showError(state.errorMessage);
      cubit.setStateToInit();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        buildMembersSeparator(
          context,
          isAddIconVisible: state.currentClass?.teachers.contains(state.currentUser?.id),
          onAddIconClicked: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("invite teacher"),
                  content: TextField(
                    decoration: const InputDecoration(
                      label: Text("teacher email"),
                    ),
                    onChanged: cubit.onTeacherEmailChanged,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Invite"),
                    )
                  ],
                );
              },
            ).then((value) => cubit.inviteMember(Role.teacher));
          },
          title: "Teachers",
        ),
        SizedBox(height: state.teachers.length * 56, child: buildListOfUsers(context, users: state.teachers)),
        buildMembersSeparator(
          context,
          onAddIconClicked: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("invite class mate"),
                  content: TextField(
                    decoration: const InputDecoration(
                      label: Text("class mate email"),
                    ),
                    onChanged: cubit.onTeacherEmailChanged,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Invite"),
                    )
                  ],
                );
              },
            ).then((value) => cubit.inviteMember(Role.classMate));
          },
          title: "Class Mates",
        ),
        Expanded(child: buildListOfUsers(context, users: state.classMembers, colorsHash: state.teachers.length)),
      ],
    );
  }

  Widget buildListOfUsers(BuildContext context, {required List<User> users, int? colorsHash}) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final currentUser = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: getIt<RandomColorGenerator>().getColorHash(index + (colorsHash ?? 0)),
            foregroundColor: Colors.white,
            child: Text(
              currentUser.fullName.firstLatter().toUpperCase(),
              textScaleFactor: 1.3,
            ),
          ),
          title: Text(currentUser.fullName),
        );
      },
      itemCount: users.length,
    );
  }

  Widget buildMembersSeparator(
    BuildContext context, {
    required VoidCallback onAddIconClicked,
    required String title,
    bool? isAddIconVisible,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: const Color.fromRGBO(0, 128, 0, 1),
                      ),
                ),
              ),
              Visibility(
                visible: isAddIconVisible ?? true,
                child: IconButton(
                  onPressed: () => onAddIconClicked(),
                  icon: const Icon(
                    Icons.person_add_alt,
                    color: Color.fromRGBO(0, 128, 0, 1),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            thickness: 1,
            color: Color.fromRGBO(0, 128, 0, 1),
          ),
        ),
      ],
    );
  }
}
