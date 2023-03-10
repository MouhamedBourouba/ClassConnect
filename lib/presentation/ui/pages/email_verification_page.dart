import 'package:ClassConnect/presentation/cubit/authentication/email_verification/email_verification_cubit.dart';
import 'package:ClassConnect/presentation/cubit/authentication/email_verification/update_email_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/complete_account_page.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailVerificationCubit(emailUpdated: email),
      child: BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
        listenWhen: (previous, current) => previous.isLoading != current.isLoading,
        listener: (context, state) {
          if (state.isLoading) showLoading(context, "verifying email");
          if (!state.isLoading) hideLoading(context);
          if (state.isEmailVerified) {
            Navigator.pushAndRemoveUntil(
              context,
              const HomePage().asRoute(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final theme = Theme.of(context);
          final textStyles = theme.textTheme;
          final colors = theme.colorScheme;
          final EmailVerificationCubit emailVerificationCubit = context.read();

          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/verify_email.png",
                      width: 140,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Email Verification",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "A 6-digit number has been sent to ",
                              style: textStyles.bodySmall,
                            ),
                            TextSpan(
                              text: state.email,
                              style: textStyles.bodySmall!.copyWith(
                                color: colors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: " , ",
                              style: textStyles.caption,
                            ),
                            TextSpan(
                              text: "CHANGE",
                              style: textStyles.bodySmall!.copyWith(
                                color: colors.secondary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  emailVerificationCubit.isDialogOpened = true;
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const UpdateEmailDialog(),
                                  ).then((value) => emailVerificationCubit.isDialogOpened = false);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: OtpTextField(
                        numberOfFields: 6,
                        showFieldAsBox: true,
                        focusedBorderColor: colors.secondary,
                        filled: true,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        onSubmit: emailVerificationCubit.onCodeSubmitChanged,
                        onCodeChanged: emailVerificationCubit.onCodeChanged,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: !state.isMessageSent && !state.loadingEmail ? "Didn't receive code ? " : "",
                            style: textStyles.bodySmall,
                          ),
                          TextSpan(
                            text: state.isMessageSent
                                ? "OTP Message Sent Successfully resend in : ${state.timeLeft.toTimeAsMin()}"
                                : state.loadingEmail
                                    ? "Sending message please wait ..."
                                    : "Resend",
                            style: !state.isMessageSent && !state.loadingEmail
                                ? textStyles.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colors.secondary,
                                    decoration: TextDecoration.underline,
                                  )
                                : textStyles.bodySmall,
                            recognizer: !state.isMessageSent && !state.loadingEmail
                                ? (TapGestureRecognizer()..onTap = emailVerificationCubit.sendEmailVerificationMessage)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const MDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              state.code.length == 6 && !state.loadingEmail ? emailVerificationCubit.verifyEmail : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.secondary,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text("Verify email"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpdateEmailDialog extends StatelessWidget {
  const UpdateEmailDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textStyles = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => UpdateEmailCubit(),
      child: BlocConsumer<UpdateEmailCubit, UpdateEmailState>(
        listener: (context, state) => state.isSuccess
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailVerificationPage(
                    email: state.email,
                  ),
                ),
              )
            : null,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async => !state.isLoading,
            child: AlertDialog(
              title: const Text("Update email"),
              content: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  validator: (value) => value.isEmail() ? null : "Invalid email address",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    filled: true,
                  ),
                  onChanged: context.read<UpdateEmailCubit>().onEmailChanged,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "close",
                    style: textStyles.button!.copyWith(color: CupertinoColors.inactiveGray),
                  ),
                ),
                Visibility(
                  visible: !state.isLoading,
                  child: TextButton(
                    onPressed: state.email.isEmail() && !state.isLoading ? context.read<UpdateEmailCubit>().update : null,
                    child: const Text("update"),
                  ),
                ),
                Visibility(
                  visible: state.isLoading,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
