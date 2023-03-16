import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_state.dart';
part 'class_cubit.freezed.dart';

class ClassCubit extends Cubit<ClassState> {
  ClassCubit() : super(const ClassState.initial());
}
