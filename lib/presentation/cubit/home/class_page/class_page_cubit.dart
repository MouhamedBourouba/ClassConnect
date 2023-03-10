import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'class_page_state.dart';

class ClassPageCubit extends Cubit<ClassPageState> {
  ClassPageCubit() : super(ClassPageInitial());
}
