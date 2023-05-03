import 'dart:convert';

import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/presentation/cubit/home/notifications/notifications_cubit.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
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
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                final currentEvent = state.events[index];
                switch (currentEvent.eventType) {
                  case EventType.classMemberShipInvitation:
                    final data = ClassInvitationEventData.fromMap((jsonDecode(currentEvent.encodedContent ?? "") as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString())));
                    return ListTile(
                      title: Text(
                          "${data.senderName} has invited you to  ${data.role == Role.teacher ? "class to be a teacher" : ""}"),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Accept"),
                          ),
                          ElevatedButton(
                            onPressed: () => null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Refuse"),
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
          );
        },
      ),
    );
  }
}
