// ignore_for_file: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:school_app/data/data_source/classes_data_source.dart';
import 'package:school_app/data/model/class.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/domain/cubit/authentication/screen_status.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            currentUser: User.defaultUser(),
            screenStatus: ScreenStatus.loading,
            createClassClassName: "",
            createClassSubject: 0,
          ),
        ) {
    _init();
  }

  late ClassesDataSource classesDataSource;

  Future<void> _init() async {
    emit(state.copyWith(currentUser: await GetIt.I.getAsync(), screenStatus: ScreenStatus.initial));
    classesDataSource = await GetIt.I.getAsync();
  }

  void changeClassName(String value) => emit(state.copyWith(createClassClassName: value));

  void changeClassSubject(int? value) => emit(state.copyWith(createClassSubject: value));

  Future<void> createClass() async {
    final uuid = GetIt.I.get<Uuid>();
    classesDataSource.createClass(
      classAdded: Class(
        id: uuid.v1().substring(0, 5),
        creatorId: state.currentUser.id,
        streamMessagesId: uuid.v1().substring(0, 6),
        studentsIds: [],
        homeWorkId: uuid.v1().substring(0, 7),
        bannedStudents: [],
        className: state.createClassClassName,
        subject: state.createClassSubject ?? 0,
      ),
      currentUser: state.currentUser,
    );
  }
}
