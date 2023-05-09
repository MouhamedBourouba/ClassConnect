import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/home/notifications/notifications_cubit.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/presentation/ui/widgets/loading.dart';
import 'package:ClassConnect/utils/error_logger.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: BlocListener<NotificationsCubit, NotificationsState>(
        listener: (context, state) {
          if(state.pageState == PageState.loading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
          if(state.pageState == PageState.error) {
            getIt<ErrorLogger>().showError(state.error);
          }
        },
        child: Builder(
          builder: (context) {
            final cubit = context.watch<NotificationsCubit>();
            final state = cubit.state;
            return Scaffold(
              appBar: AppBar(
                title: const Text("Notifications"),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, int index) {
                        return const Divider(color: Colors.black);
                      },
                      padding: const EdgeInsets.only(top: 6),
                      itemBuilder: (context, index) {
                        final currentEvent = state.events[index];
                        switch (currentEvent.eventType) {
                          case EventType.classMemberShipInvitation:
                            final data = cubit.decodeClassInvitationEventData(currentEvent.encodedContent!);
                            return ListTile(
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "${data.senderName} ",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
                                    ),
                                    TextSpan(
                                      text: data.role == Role.teacher ? "invited you to teach in " : "invited you to ",
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    TextSpan(
                                      text: "${data.className} class",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                              leading: CircleAvatar(
                                foregroundColor: Colors.white,
                                backgroundColor: getIt<RandomColorGenerator>().getColorHash(index),
                                child: Text(data.senderName[0].toUpperCase()),
                              ),
                              subtitle: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary),
                                    onPressed: () => cubit.acceptInvitation(currentEvent.id ,data),
                                    child: const Text("Join"),
                                  ),
                                  const SizedBox(width: 12),
                                  TextButton(
                                    onPressed: () => cubit.removeEvent(currentEvent.id),
                                    child: const Text(
                                      "Decline",
                                      style: TextStyle(color: CupertinoColors.inactiveGray),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          case EventType.classMemberShipAccepted:
                            return Placeholder();
                        }
                      },
                      itemCount: state.events.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
