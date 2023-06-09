part of 'notifications_cubit.dart';

@freezed
class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial({
    @Default([]) List<UserEvent> events,
    @Default([]) List<Class> classes,
    @Default(PageState.init) PageState pageState,
    @Default('') String error,
  }) = _Initial;
}
