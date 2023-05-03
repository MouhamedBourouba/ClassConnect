import 'dart:convert';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/events_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_cubit.freezed.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState.initial()) {
    eventsRepository.getEvents().then((value) => emit(state.copyWith(pageState: PageState.init, events: value)));
    for (final element in state.events) {
      if (element.eventType == EventType.classMemberShipInvitation) {
        // classesRepository.getClassById(jsonDecode(source))
      }
    }
  }

  final EventsRepository eventsRepository = getIt();
  final ClassesRepository classesRepository = getIt();

  // Class getClassById(String classId) {}
}
