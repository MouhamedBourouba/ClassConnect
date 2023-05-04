import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/home/notifications/notifications_cubit.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/extension.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.watch<NotificationsCubit>();
          final state = cubit.state;
          if (state.pageState == PageState.loading) return const Center(child: CircularProgressIndicator());
          return Scaffold(
            appBar: AppBar(
              title: const Text("Notifications"),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 6),
              itemBuilder: (context, index) {
                final currentEvent = state.events[index];
                switch (currentEvent.eventType) {
                  case EventType.classMemberShipInvitation:
                    final data = cubit.decodeClassInvitationEventData(currentEvent.encodedContent!);
                    return Dismissible(
                      background: const ColoredBox(
                        color: Colors.red,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => cubit.refuseInvitation(data),
                      key: ObjectKey(index),
                      child: ListTile(
                        title: const Text("Teaching invitation"),
                        subtitle: Text("${data.senderName} invited you to ${data.className} class"),
                        leading: CircleAvatar(
                          backgroundColor: getIt<RandomColorGenerator>().getColorHash(index),
                          foregroundColor: Colors.white,
                          child: Text(data.senderName.firstLatter().toUpperCase()),
                        ),
                        trailing: IconButton(
                          onPressed: () => cubit.acceptInvitation(data),
                          icon: const Icon(Icons.check),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    );
                  case EventType.classMemberShipAccepted:
                    return Placeholder();
                }
              },
              itemCount: state.events.length,
            ),
          );
        },
      ),
    );
  }
}
