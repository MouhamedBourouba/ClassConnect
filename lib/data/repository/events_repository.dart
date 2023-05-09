import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:ClassConnect/data/model/user_event.dart';
import 'package:ClassConnect/utils/utils.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class EventsRepository {
  Future<int> getNotificationNumber();

  Future<List<UserEvent>> getEvents();

  Future<Result<Unit, Unit>> postEvent(UserEvent userEvent);

  Future<void> removeEvent(String eventId);
}

@LazySingleton(as: EventsRepository)
class EventsRepositoryImpl extends EventsRepository {
  final CloudDataSource cloudDataSource;
  final LocalDataSource localDataSource;

  EventsRepositoryImpl(this.cloudDataSource, this.localDataSource);

  @override
  Future<List<UserEvent>> getEvents() async {
    if (await isOnline()) {
      final events = (await cloudDataSource.getAllRows(MTable.eventsTable) ?? []).map((e) => UserEvent.fromMap(e));
      final userRelatedEvents = events.where((element) => element.eventReceiverId == localDataSource.getCurrentUser()!.id);
      for (final element in userRelatedEvents) {
        localDataSource.addEvent(element);
      }
      for (final event in userRelatedEvents) {
        cloudDataSource.updateValue(true, MTable.eventsTable, rowKey: event.id, columnKey: "seen");
      }
      return userRelatedEvents.toList();
    } else {
      return localDataSource.getEvents();
    }
  }

  @override
  Future<int> getNotificationNumber() async {
    final events = (await isOnline()) ? (await cloudDataSource.getAllRows(MTable.eventsTable))?.map((e) => UserEvent.fromMap(e)) : localDataSource.getEvents();
    return ((events?.where((element) => element.eventReceiverId == localDataSource.getCurrentUser()?.id && !element.seen).length) ?? -1) + 1;
  }

  @override
  Future<Result<Unit, Unit>> postEvent(UserEvent userEvent) async =>
      await cloudDataSource.appendRow(userEvent.toMap(), MTable.eventsTable) ? Result.success(unit) : Result.error(unit);

  @override
  Future<void> removeEvent(String eventId) async {
    await cloudDataSource.deleteRow(MTable.eventsTable, rowKey: eventId);
    localDataSource.removeEvent(eventId);
  }
}
