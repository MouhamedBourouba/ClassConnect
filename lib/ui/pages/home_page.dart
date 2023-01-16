import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/domain/cubit/authentication/screen_status.dart';
import 'package:school_app/domain/cubit/home/home_cubit.dart';
import 'package:school_app/domain/extension.dart';
import 'package:school_app/ui/widgets/outlined_text_field.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeCubit = context.read<HomeCubit>();

    return BlocProvider(
      create: (context) => HomeCubit(),
      child: BlocSelector<HomeCubit, HomeState, ScreenStatus>(
        selector: (state) {
          return state.screenStatus;
        },
        builder: (context, state) {
          if (state == ScreenStatus.initial) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: const Text("Classes"),
                  backgroundColor: theme.colorScheme.secondary,
                  actions: [
                    CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        homeCubit.state.currentUser.username.firstLatter(),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                              },
                              child: const Text("Create class"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Join class: "),
                                    actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    actions: [
                                      const TextField(
                                        decoration: InputDecoration(
                                          border: outlinedInputBorder,
                                          hintText: "class code",
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text("Join"),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
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
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  final classNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Class details:",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Please enter class name";
                  } else {
                    return null;
                  }
                },
                controller: classNameTextController,
                decoration: const InputDecoration(
                  label: Text("Class name"),
                  filled: true,
                ),
                onChanged: homeCubit.changeClassName,
              ),
              const SizedBox(height: 16),
              DropDownTextField(
                initialValue: "match",
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return "Please enter class Subject";
                  } else {
                    return null;
                  }
                },
                textFieldDecoration: const InputDecoration(filled: true, label: Text("Subject")),
                dropDownList: const [
                  DropDownValueModel(name: "match", value: 0),
                  DropDownValueModel(name: "arabic", value: 1),
                  DropDownValueModel(name: "english", value: 2),
                  DropDownValueModel(name: "french", value: 3),
                  DropDownValueModel(name: "history", value: 4),
                  DropDownValueModel(name: "physics", value: 5),
                  DropDownValueModel(name: "science", value: 6),
                  DropDownValueModel(name: "other", value: 7),
                ],
                onChanged: (value) {
                  try {
                    value as DropDownValueModel;
                    log(value.value.toString());
                    log(homeCubit.state.createClassSubject.toString());
                    homeCubit.changeClassSubject(value.value as int);
                  } on Exception {
                    homeCubit.changeClassSubject(null);
                  }
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previousState, currentState) {
                    return !(previousState.createClassClassName == currentState.createClassClassName &&
                        previousState.createClassSubject == currentState.createClassSubject);
                  },
                  builder: (context, state) {
                    final canCreate = state.createClassClassName.isNotEmpty && state.createClassSubject != null;
                    print(canCreate.toString());
                    return TextButton(
                      onPressed: canCreate
                          ? () {
                              homeCubit.createClass();
                            }
                          : null,
                      child: Text(
                        "create",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
