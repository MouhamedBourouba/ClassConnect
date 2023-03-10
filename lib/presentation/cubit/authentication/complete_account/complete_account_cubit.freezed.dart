// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complete_account_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CompleteAccountState {
  String get grade => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get parentPhone => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)?
        initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompleteAccountStateCopyWith<CompleteAccountState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteAccountStateCopyWith<$Res> {
  factory $CompleteAccountStateCopyWith(CompleteAccountState value,
          $Res Function(CompleteAccountState) then) =
      _$CompleteAccountStateCopyWithImpl<$Res, CompleteAccountState>;
  @useResult
  $Res call(
      {String grade,
      String firstName,
      String lastName,
      String parentPhone,
      bool isSuccess,
      bool isLoading});
}

/// @nodoc
class _$CompleteAccountStateCopyWithImpl<$Res,
        $Val extends CompleteAccountState>
    implements $CompleteAccountStateCopyWith<$Res> {
  _$CompleteAccountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? parentPhone = null,
    Object? isSuccess = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      parentPhone: null == parentPhone
          ? _value.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res>
    implements $CompleteAccountStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String grade,
      String firstName,
      String lastName,
      String parentPhone,
      bool isSuccess,
      bool isLoading});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$CompleteAccountStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grade = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? parentPhone = null,
    Object? isSuccess = null,
    Object? isLoading = null,
  }) {
    return _then(_$_Initial(
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      parentPhone: null == parentPhone
          ? _value.parentPhone
          : parentPhone // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {this.grade = "First Grade",
      this.firstName = "",
      this.lastName = "",
      this.parentPhone = "",
      this.isSuccess = false,
      this.isLoading = false});

  @override
  @JsonKey()
  final String grade;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  @JsonKey()
  final String parentPhone;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'CompleteAccountState.initial(grade: $grade, firstName: $firstName, lastName: $lastName, parentPhone: $parentPhone, isSuccess: $isSuccess, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.parentPhone, parentPhone) ||
                other.parentPhone == parentPhone) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, grade, firstName, lastName,
      parentPhone, isSuccess, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)
        initial,
  }) {
    return initial(
        grade, firstName, lastName, parentPhone, isSuccess, isLoading);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)?
        initial,
  }) {
    return initial?.call(
        grade, firstName, lastName, parentPhone, isSuccess, isLoading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String grade, String firstName, String lastName,
            String parentPhone, bool isSuccess, bool isLoading)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          grade, firstName, lastName, parentPhone, isSuccess, isLoading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements CompleteAccountState {
  const factory _Initial(
      {final String grade,
      final String firstName,
      final String lastName,
      final String parentPhone,
      final bool isSuccess,
      final bool isLoading}) = _$_Initial;

  @override
  String get grade;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get parentPhone;
  @override
  bool get isSuccess;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
