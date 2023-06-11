import "package:ClassConnect/data/model/class.dart";
import "package:ClassConnect/data/model/class_message.dart";
import "package:ClassConnect/data/repository/classes_data_source.dart";
import "package:ClassConnect/data/repository/user_repository.dart";
import "package:ClassConnect/presentation/ui/widgets/loading.dart";
import "package:ClassConnect/utils/error_logger.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import "../../../di/di.dart";

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({super.key, required this.currentClass});

  final Class currentClass;

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  String subject = "";
  String body = "";
  final currentUser = getIt<UserRepository>().getCurrentUser()!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Future<bool> sendMessage() async {
      final classesRepo = getIt<ClassesRepository>();
      final message = ClassMessage(
        id: getIt<Uuid>().v1(),
        streamMessagesId: widget.currentClass.streamMessagesId,
        senderId: currentUser.id,
        senderName: currentUser.fullName,
        sentTimeMS: DateTime.now().microsecondsSinceEpoch.toString(),
        title: subject,
        content: body,
      );
      final result = await classesRepo.sendMessage(message);
      return result.isSuccess();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.secondary,
        title: const Text("Send Message"),
        actions: [
          IconButton(
            onPressed: () {
              if(subject.isEmpty || body.isEmpty) {
                getIt<ErrorLogger>()
                    .showError('Please fill all required fields');
                return;
              }
              showLoading(context);
              sendMessage().then((success) {
                hideLoading(context);
                if (success) {
                  Navigator.pop(context);
                } else {
                  getIt<ErrorLogger>()
                      .showError('Unknown error happened please check your internet and try again');
                }
              });
            },
            icon: const Icon(Icons.send, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(border: InputBorder.none, hintText: "Subject"),
              onChanged: (value) => subject = value,
            ),
            const Divider(
              thickness: 1,
              color: CupertinoColors.inactiveGray,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => body = value,
                decoration: const InputDecoration(border: InputBorder.none, hintText: "Body"),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
