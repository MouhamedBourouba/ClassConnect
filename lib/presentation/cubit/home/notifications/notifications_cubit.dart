import 'dart:convert';

import 'package:ClassConnect/data/model/class.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/data/repository/classes_data_source.dart';
import 'package:ClassConnect/data/repository/events_repository.dart';
import 'package:ClassConnect/di/di.dart';
import 'package:ClassConnect/presentation/cubit/page_state.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_cubit.freezed.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState.initial()) {
    _eventsRepository.getEvents().then((value) {
      emit(state.copyWith(events: value));
    });
  }

  final _invitationContent = [];
  final EventsRepository _eventsRepository = getIt();
  final ClassesRepository _classesRepository = getIt();

  ClassInvitationEventData decodeClassInvitationEventData(String data) {
    final classInvitationDataMap = (jsonDecode(data) as Map<String, dynamic>).map((key, value) => MapEntry(key, value.toString()));
    return ClassInvitationEventData.fromMap(classInvitationDataMap);
  }

  Future<void> acceptInvitation(String eventId, ClassInvitationEventData data) async {
    await checkInternetConnection();
    emit(state.copyWith(pageState: PageState.loading));
    (await _classesRepository.acceptInvitation(data)).when(
      (success) {
        emit(state.copyWith(pageState: PageState.success, events: List.from(state.events)..removeWhere((element) => element.id == eventId)));
        _eventsRepository.removeEvent(eventId);
      },
      (error) => emit(
        state.copyWith(pageState: PageState.error, error: error),
      ),
    );
  }

  Future<void> removeEvent(String eventId) async {
    await checkInternetConnection();
    emit(state.copyWith(pageState: PageState.loading));
    await _eventsRepository.removeEvent(eventId);
    emit(state.copyWith(pageState: PageState.init, events: List.from(state.events)..removeWhere((element) => element.id == eventId)));
  }
}
