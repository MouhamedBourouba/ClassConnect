// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeState {
  User? get currentUser => throw _privateConstructorUsedError;
  String get joinClassId => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isJoiningClassTaskSuccess => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User? currentUser, String joinClassId,
            bool isLoading, bool isJoiningClassTaskSuccess)
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User? currentUser, String joinClassId, bool isLoading,
            bool isJoiningClassTaskSuccess)?
        initial,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User? currentUser, String joinClassId, bool isLoading,
            bool isJoiningClassTaskSuccess)?
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
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {User? currentUser,
      String joinClassId,
      bool isLoading,
      bool isJoiningClassTaskSuccess});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = freezed,
    Object? joinClassId = null,
    Object? isLoading = null,
    Object? isJoiningClassTaskSuccess = null,
  }) {
    return _then(_value.copyWith(
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User?,
      joinClassId: null == joinClassId
          ? _value.joinClassId
          : joinClassId // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isJoiningClassTaskSuccess: null == isJoiningClassTaskSuccess
          ? _value.isJoiningClassTaskSuccess
          : isJoiningClassTaskSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User? currentUser,
      String joinClassId,
      bool isLoading,
      bool isJoiningClassTaskSuccess});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$_Initial>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = freezed,
    Object? joinClassId = null,
    Object? isLoading = null,
    Object? isJoiningClassTaskSuccess = null,
  }) {
    return _then(_$_Initial(
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User?,
      joinClassId: null == joinClassId
          ? _value.joinClassId
          : joinClassId // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isJoiningClassTaskSuccess: null == isJoiningClassTaskSuccess
          ? _value.isJoiningClassTaskSuccess
          : isJoiningClassTaskSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(
      {this.currentUser,
      this.joinClassId = "",
      this.isLoading = false,
      this.isJoiningClassTaskSuccess = false});

  @override
  final User? currentUser;
  @override
  @JsonKey()
  final String joinClassId;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isJoiningClassTaskSuccess;

  @override
  String toString() {
    return 'HomeState.initial(currentUser: $currentUser, joinClassId: $joinClassId, isLoading: $isLoading, isJoiningClassTaskSuccess: $isJoiningClassTaskSuccess)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            (identical(other.joinClassId, joinClassId) ||
                other.joinClassId == joinClassId) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isJoiningClassTaskSuccess,
                    isJoiningClassTaskSuccess) ||
                other.isJoiningClassTaskSuccess == isJoiningClassTaskSuccess));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentUser, joinClassId,
      isLoading, isJoiningClassTaskSuccess);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User? currentUser, String joinClassId,
            bool isLoading, bool isJoiningClassTaskSuccess)
        initial,
  }) {
    return initial(
        currentUser, joinClassId, isLoading, isJoiningClassTaskSuccess);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User? currentUser, String joinClassId, bool isLoading,
            bool isJoiningClassTaskSuccess)?
        initial,
  }) {
    return initial?.call(
        currentUser, joinClassId, isLoading, isJoiningClassTaskSuccess);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User? currentUser, String joinClassId, bool isLoading,
            bool isJoiningClassTaskSuccess)?
        initial,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(
          currentUser, joinClassId, isLoading, isJoiningClassTaskSuccess);
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

abstract class _Initial implements HomeState {
  const factory _Initial(
      {final User? currentUser,
      final String joinClassId,
      final bool isLoading,
      final bool isJoiningClassTaskSuccess}) = _$_Initial;

  @override
  User? get currentUser;
  @override
  String get joinClassId;
  @override
  bool get isLoading;
  @override
  bool get isJoiningClassTaskSuccess;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}
