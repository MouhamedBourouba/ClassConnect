part of 'home_cubit.dart';

abstract class HomeState extends Equatable {

  final User currentUser;

  const HomeState({required this.currentUser}) : super();


  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial({required super.currentUser});
}

class HomeLoading extends HomeState {
  const HomeLoading({required super.currentUser});
}
