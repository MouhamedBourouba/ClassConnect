// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/model/user.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial(currentUser: User.defaultUser())) {
    fetchUser();
  }

  Future<void> fetchUser() async {
    final user = await GetIt.I.getAsync<User>();
    return;
  }
}
