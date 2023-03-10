import 'package:ClassConnect/presentation/cubit/home/create_class/create_class_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateClassPage extends StatelessWidget {
  const CreateClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateClassCubit(),
      child: const CreateClassBody(),
    );
  }
}

class CreateClassBody extends StatelessWidget {
  const CreateClassBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<CreateClassCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create class"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocListener<CreateClassCubit, CreateClassState>(
        listenWhen: (previous, current) => previous.isLoading != current.isLoading,
        listener: (context, state) {
          if (state.isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
          if (state.isSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          }
        },
        child: Form(
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
                    } else if (value?.contains(',') == true) {
                      return "please remove the comma ','";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    label: Text("Class name"),
                    filled: true,
                    prefixIcon: Icon(Icons.class_),
                  ),
                  onChanged: homeCubit.onClassNameChanged,
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
                    DropDownValueModel(name: "math", value: 0),
                    DropDownValueModel(name: "arabic", value: 1),
                    DropDownValueModel(name: "english", value: 2),
                    DropDownValueModel(name: "french", value: 3),
                    DropDownValueModel(name: "history", value: 4),
                    DropDownValueModel(name: "physics", value: 5),
                    DropDownValueModel(name: "science", value: 6),
                    DropDownValueModel(name: "other", value: 7),
                  ],
                  onChanged: (value) {
                    if (value == "") {
                      homeCubit.onClassSubjectChanged("");
                      return;
                    }
                    homeCubit.onClassSubjectChanged((value as DropDownValueModel).name);
                  },
                ),
                const SizedBox(height: 8),
                const CreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.watch<CreateClassCubit>();
    final state = homeCubit.state;
    final canCreate = state.className.isNotEmpty && state.classSubject != "" && !state.className.contains(',');
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: canCreate ? homeCubit.createClass : null,
        child: Text(
          "create",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: canCreate ? Theme.of(context).colorScheme.primary : Colors.grey),
        ),
      ),
    );
  }
}
