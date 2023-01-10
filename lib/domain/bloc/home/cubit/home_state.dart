part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState() : super();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class Loaded extends HomeState {
  final User user;

  const Loaded(this.user);
}
