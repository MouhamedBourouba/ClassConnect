import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/presentation/cubit/settings/update_profile_cubit.dart';
import 'package:ClassConnect/presentation/ui/pages/home_page.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        switch (state.pageState) {
          case PageState.init:
            break;
          case PageState.loading:
            showLoading(context);
            break;
          case PageState.success:
            hideLoading(context);
            Navigator.push(context, const HomePage().asRoute());
            context.read<UpdateProfileCubit>().setToInit();
            break;
          case PageState.error:
            hideLoading(context);
            getIt<ErrorLogger>().showError(state.errorMessage);
            break;
        }
      },
      child: const UpdateProfileBody(),
    );
  }
}

class UpdateProfileBody extends StatelessWidget {
  const UpdateProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateProfileCubit updateProfileCubit = context.watch<UpdateProfileCubit>();
    final UpdateProfileState state = updateProfileCubit.state;
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ignore: use_colored_box
          Container(
            color: theme.colorScheme.primary.withAlpha(250),
          ),
          Positioned(
            top: -300,
            child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                width: 600,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: -300,
            child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                width: 600,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: -300,
            child: Opacity(
              opacity: 0.15,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                width: 600,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 37,
            child: Text(
              "Profile",
              style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            left: 0,
            top: 30,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 16,
            right: 16,
            bottom: 100,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    state.currentUser.fullName,
                    style: theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  buildInfoChip(theme),
                  Text(
                    "Profile info",
                    style: theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: theme.colorScheme.primary,
                    thickness: 1.5,
                  ),
                  buildListView(context, theme),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Hero(
              tag: "profile_avatar",
              child: CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.secondary,
                child: Text(
                  state.currentUser.fullName.firstLatter().toUpperCase(),
                  style: theme.textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(
    BuildContext context,
    ThemeData theme,
  ) {
    final UpdateProfileCubit updateProfileCubit = context.watch<UpdateProfileCubit>();
    final UpdateProfileState state = updateProfileCubit.state;

    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildAccountInfoTile(
            theme,
            infoName: "Full Name",
            value: state.currentUser.fullName,
            icon: Icons.person,
            onTap: () {
              showUpdateDialog(
                "Edit name",
                context,
                TextField(
                  decoration: const InputDecoration(filled: true, label: Text("Full name")),
                  onChanged: updateProfileCubit.onFullNameChanged,
                ),
              ).then((value) {
                if (value) {
                  if (context.read<UpdateProfileCubit>().state.fullName.isNotEmpty) {
                    updateProfileCubit.update(UserField.fullName);
                  } else {
                    getIt<ErrorLogger>().showError("Invalid input");
                  }
                }
              });
            },
          ),
          buildAccountInfoTile(
            theme,
            icon: Icons.email,
            infoName: "Email",
            value: state.currentUser.email,
            onTap: () {
              showUpdateDialog(
                "Edit email",
                context,
                TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    label: Text("email"),
                    prefixIcon: Icon(Icons.email),
                  ),
                  onChanged: updateProfileCubit.onEmailChanged,
                ),
              ).then((value) {
                if (value) {
                  if (context.read<UpdateProfileCubit>().state.email.isEmail()) {
                    updateProfileCubit.update(UserField.email);
                  } else {
                    getIt<ErrorLogger>().showError("Invalid input");
                  }
                }
              });
            },
          ),
          buildAccountInfoTile(
            theme,
            icon: Icons.phone,
            infoName: "Phone number",
            value: state.currentUser.phoneNumber,
            onTap: () {
              showUpdateDialog(
                "Edit phone number",
                context,
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    updateProfileCubit.onPhoneNumberChanged(value);
                  },
                  decoration: const InputDecoration(
                    label: Text('Phone number'),
                    filled: true,
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ).then((value) {
                if (value) {
                  if (context.read<UpdateProfileCubit>().state.phoneNumber.length < 11 &&
                      context.read<UpdateProfileCubit>().state.phoneNumber.length > 9) {
                    updateProfileCubit.update(UserField.phoneNumber);
                  } else {
                    getIt<ErrorLogger>().showError("Invalid input");
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<bool> showUpdateDialog(String title, BuildContext context, Widget content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Update"),
          ),
        ],
      ),
    ).then((value) => value == true);
  }

  Widget buildAccountInfoTile(
    ThemeData theme, {
    required String infoName,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 4,
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        infoName,
        maxLines: 1,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.caption,
          ),
          const SizedBox(
            width: 6,
          ),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }

  Widget buildInfoChip(ThemeData theme) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: buildStatusChip(
                  icon: Icons.class_,
                  title: "Classes",
                  value: "15",
                  theme: theme,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 2,
                  child: ColoredBox(color: Colors.white),
                ),
              ),
              Expanded(
                child: buildStatusChip(
                  icon: Icons.task,
                  title: "Tasks Done",
                  value: "65",
                  theme: theme,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 2,
                  child: ColoredBox(color: Colors.white),
                ),
              ),
              Expanded(
                child: buildStatusChip(
                  icon: Icons.leaderboard,
                  title: "Rank",
                  value: "5045",
                  theme: theme,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildStatusChip({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
