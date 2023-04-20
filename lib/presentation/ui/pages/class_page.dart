import 'package:ClassConnect/data/model/user.dart';
import 'package:ClassConnect/presentation/cubit/class_page/class_cubit.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

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
    return const Placeholder();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        buildMembersSeparator(
          context,
          onAddIconClicked: () async {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add teacher"),
                  content: TextField(
                    decoration: const InputDecoration(
                      label: Text("Teacher email"),
                    ),
                    onChanged: cubit.onTeacherEmailChanged,
                  ),
                  actions: [
                    TextButton(onPressed: cubit.inviteTeacher, child: const Text("Invite"))
                  ],
                );
              },
            );
          },
          title: "Teachers",
        ),
        SizedBox(height: state.teachers.length * 56, child: buildListOfUsers(context, users: state.teachers)),
        buildMembersSeparator(
          context,
          onAddIconClicked: () => null,
          title: "Members",
        ),
        Expanded(child: buildListOfUsers(context, users: state.classMembers)),
      ],
    );
  }

  Widget buildListOfUsers(BuildContext context, {required List<User> users}) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final currentUser = users[index];
        final avatarColor = Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: avatarColor,
            foregroundColor: Colors.white,
            child: Text(currentUser.fullName.firstLatter()),
          ),
          title: Text(currentUser.fullName),
        );
      },
      itemCount: users.length,
    );
  }

  Widget buildMembersSeparator(BuildContext context, {required VoidCallback onAddIconClicked, required String title}) {
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
              IconButton(
                onPressed: () => onAddIconClicked(),
                icon: const Icon(
                  Icons.person_add_alt,
                  color: Color.fromRGBO(0, 128, 0, 1),
                  size: 24,
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
