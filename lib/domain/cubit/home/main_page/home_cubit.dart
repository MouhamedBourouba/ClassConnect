import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/di/di.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.initial()) {
    userRepository = getIt();
    emit(state.copyWith(currentUser: userRepository.getCurrentUser()));
  }

  late UserRepository userRepository;

  void onJoinClassIdChanged(String value) => emit(state.copyWith(joinClassId: value));

  joinClass() {}
}
