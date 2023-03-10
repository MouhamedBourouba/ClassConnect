import 'package:ClassConnect/presentation/cubit/authentication/complete_account/complete_account_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/email_verification_page.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/authentication_scaffold.dart';
import 'package:ClassConnect/presentation/ui/widgets/button.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CompleteAccountPage extends StatelessWidget {
  const CompleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget welcomeText() => Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "Complete Your ",
              style: theme.textTheme.headline5,
            ),
            Text(
              "Account",
              style: theme.textTheme.headline5!.copyWith(color: theme.colorScheme.secondary),
            ),
          ],
        );

    return SafeArea(
      child: BlocProvider(
        create: (context) => CompleteAccountCubit(),
        child: BlocListener<CompleteAccountCubit, CompleteAccountState>(
          listener: (context, state) {
            if (state.isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
            if (state.isSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const EmailVerificationPage();
                  },
                ),
                (route) => false,
              );
            }
          },
          child: AuthenticationScaffold(
            topImageSize: 150,
            body: Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    welcomeText(),
                    const Divider(
                      color: Colors.black,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: const [
                          FullNameTextField(),
                          GradeDropDown(),
                          PhoneNumberTextField(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CompleteAccountButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CompleteAccountButton extends StatelessWidget {
  const CompleteAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final completeAccountCubit = context.watch<CompleteAccountCubit>();
    final phoneNumber = completeAccountCubit.state.parentPhone;
    final bool phoneNUmberTrue = phoneNumber.length > 8 && phoneNumber.length < 12;
    final canSave = completeAccountCubit.state.grade != "" &&
        phoneNUmberTrue &&
        completeAccountCubit.state.firstName.isNotEmpty &&
        completeAccountCubit.state.lastName.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MButton(
        onClick: canSave ? completeAccountCubit.completeRegistration : null,
        title: "Save",
      ),
    );
  }
}

class MDivider extends StatelessWidget {
  const MDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.0),
      child: Divider(thickness: 2),
    );
  }
}

class GradeDropDown extends StatelessWidget {
  const GradeDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: DropDownTextField(
        onChanged: (value) {
          if (value == "") {
            context.read<CompleteAccountCubit>().onGradeChange("");
            return;
          } else {
            value as DropDownValueModel;
            context.read<CompleteAccountCubit>().onGradeChange(value.name);
          }
        },
        initialValue: "First Grade",
        textFieldDecoration: const InputDecoration(
          label: Text("Grade"),
          filled: true,
        ),
        dropDownList: const [
          DropDownValueModel(name: "First Grade", value: 1),
          DropDownValueModel(name: "Second Grade", value: 2),
          DropDownValueModel(name: "Third Grade", value: 3),
        ],
      ),
    );
  }
}

class FullNameTextField extends StatelessWidget {
  const FullNameTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: context.read<CompleteAccountCubit>().onFirstNameChange,
              decoration: const InputDecoration(
                label: Text("First Name"),
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              onChanged: context.read<CompleteAccountCubit>().onLastNameChange,
              decoration: const InputDecoration(
                label: Text("Last Name"),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberTextField extends StatelessWidget {
  const PhoneNumberTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 16),
      child: InternationalPhoneNumberInput(
        validator: (value) {
          final phoneNumber = value?.replaceAll(" ", "");
          if (value == null || value.isEmpty || (phoneNumber!.length > 8 && phoneNumber.length < 12)) return null;
          return "Invalid phone number";
        },
        inputDecoration: const InputDecoration(
          label: Text("Prent phone"),
          filled: true,
        ),
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        initialValue: PhoneNumber(isoCode: "DZ"),
        onInputChanged: (PhoneNumber value) {
          context
              .read<CompleteAccountCubit>()
              .onParentPhoneChange(value.phoneNumber?.split(value.dialCode!).last ?? "");
        },
      ),
    );
  }
}
