part of 'home_cubit.dart';

class HomeState extends Equatable {
  final User currentUser;
  final ScreenStatus screenStatus;
  final String createClassClassName;
  final int? createClassSubject;

  const HomeState({
    required this.currentUser,
    required this.screenStatus,
    required this.createClassClassName,
    required this.createClassSubject,
  });

  HomeState copyWith({
    User? currentUser,
    ScreenStatus? screenStatus,
    String? createClassClassName,
    int? createClassSubject,
  }) {
    return HomeState(
      currentUser: currentUser ?? this.currentUser,
      screenStatus: screenStatus ?? this.screenStatus,
      createClassClassName: createClassClassName ?? this.createClassClassName,
      createClassSubject: createClassSubject ?? this.createClassSubject,
    );
  }

  @override
  List<Object> get props => [currentUser, screenStatus, createClassClassName, createClassSubject ?? -1];
}
