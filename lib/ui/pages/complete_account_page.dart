import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:school_app/domain/controllers/complete_account_provider.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/widgets/authentication_scaffold.dart';
import 'package:school_app/ui/widgets/loading.dart';

class CompleteAccountPage extends StatelessWidget {
  const CompleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fToast = FToast().init(context);

    welcomeText() => Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "Complete Your ",
              style: theme.textTheme.headline5,
            ),
            Text(
              "Account",
              style: theme.textTheme.headline5!
                  .copyWith(color: theme.colorScheme.secondary),
            ),
          ],
        );

    fullNameTextFields() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Consumer<CompleteAccountProvider>(
                builder: (context, provider, _) => Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text("First Name"),
                      filled: true,
                    ),
                    onChanged: provider.updateFirstName,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Consumer<CompleteAccountProvider>(
                  builder: (context, provider, __) => TextField(
                    decoration: const InputDecoration(
                      label: Text("Last Name"),
                      filled: true,
                    ),
                    onChanged: provider.updateLastName,
                  ),
                ),
              ),
            ],
          ),
        );

    phoneNumberTextField() => Consumer<CompleteAccountProvider>(
          builder: (context, provider, widget) => Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 16, bottom: 0),
            child: InternationalPhoneNumberInput(
              inputDecoration: InputDecoration(
                label: const Text("Prent phone"),
                filled: true,
                errorText: provider.parentPhoneTextFieldValue.errorMessage,
              ),
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              onInputChanged: provider.updatePhoneNumber,
            ),
          ),
        );

    gradeTextField() => Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Consumer<CompleteAccountProvider>(
              builder: (context, provider, _) {
            return DropDownTextField(
              onChanged: (value) {
                provider.updateGrade(value);
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
            );
          }),
        );

    saveButton() => Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 16),
          child: Consumer<CompleteAccountProvider>(
            builder: (context, provider, widget) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  backgroundColor: theme.colorScheme.secondary),
              onPressed: provider.firstNameTextFieldValue.isNotEmpty &&
                      provider.lastNameTextFieldValue.isNotEmpty &&
                      provider.gradeTextFieldValue != null &&
                      provider.parentPhoneTextFieldValue.value.isNotEmpty &&
                      provider.parentPhoneTextFieldValue.errorMessage == null
                  ? () {
                      provider.saveUserAccount(
                        onStart: () => LoadingController.showLoading(context),
                        onCompleted: () => LoadingController.hideLoading(context),
                        onError: (error) => Fluttertoast.showToast(msg: error, backgroundColor: Colors.red),
                        onSuccess: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (ctx) => HomePage()),
                          (route) => false,
                        ),
                      );
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Sing in",
                  style:
                      theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        );

    return SafeArea(
      child: AuthenticationScaffold(
        topImageSize: 150,
        hideWhenKeyboardAppears: false,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const SizedBox(height: 100),
                welcomeText(),
                const Divider(thickness: 1),
                fullNameTextFields(),
                gradeTextField(),
                phoneNumberTextField(),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Divider(thickness: 2),
                ),
                saveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
