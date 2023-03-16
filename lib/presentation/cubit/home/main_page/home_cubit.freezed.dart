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
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(User currentUser, List<Class> classes) loaded,
    required TResult Function(String errorMessage) error,
    required TResult Function() singOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(User currentUser, List<Class> classes)? loaded,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? singOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(User currentUser, List<Class> classes)? loaded,
    TResult Function(String errorMessage)? error,
    TResult Function()? singOut,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeStateLoading value) loading,
    required TResult Function(HomeStateLoaded value) loaded,
    required TResult Function(HomeStateError value) error,
    required TResult Function(HomeStateSingedOut value) singOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStateLoading value)? loading,
    TResult? Function(HomeStateLoaded value)? loaded,
    TResult? Function(HomeStateError value)? error,
    TResult? Function(HomeStateSingedOut value)? singOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStateLoading value)? loading,
    TResult Function(HomeStateLoaded value)? loaded,
    TResult Function(HomeStateError value)? error,
    TResult Function(HomeStateSingedOut value)? singOut,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HomeStateLoadingCopyWith<$Res> {
  factory _$$HomeStateLoadingCopyWith(
          _$HomeStateLoading value, $Res Function(_$HomeStateLoading) then) =
      __$$HomeStateLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStateLoadingCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateLoading>
    implements _$$HomeStateLoadingCopyWith<$Res> {
  __$$HomeStateLoadingCopyWithImpl(
      _$HomeStateLoading _value, $Res Function(_$HomeStateLoading) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeStateLoading implements HomeStateLoading {
  const _$HomeStateLoading();

  @override
  String toString() {
    return 'HomeState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStateLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(User currentUser, List<Class> classes) loaded,
    required TResult Function(String errorMessage) error,
    required TResult Function() singOut,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(User currentUser, List<Class> classes)? loaded,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? singOut,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(User currentUser, List<Class> classes)? loaded,
    TResult Function(String errorMessage)? error,
    TResult Function()? singOut,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeStateLoading value) loading,
    required TResult Function(HomeStateLoaded value) loaded,
    required TResult Function(HomeStateError value) error,
    required TResult Function(HomeStateSingedOut value) singOut,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStateLoading value)? loading,
    TResult? Function(HomeStateLoaded value)? loaded,
    TResult? Function(HomeStateError value)? error,
    TResult? Function(HomeStateSingedOut value)? singOut,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStateLoading value)? loading,
    TResult Function(HomeStateLoaded value)? loaded,
    TResult Function(HomeStateError value)? error,
    TResult Function(HomeStateSingedOut value)? singOut,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HomeStateLoading implements HomeState {
  const factory HomeStateLoading() = _$HomeStateLoading;
}

/// @nodoc
abstract class _$$HomeStateLoadedCopyWith<$Res> {
  factory _$$HomeStateLoadedCopyWith(
          _$HomeStateLoaded value, $Res Function(_$HomeStateLoaded) then) =
      __$$HomeStateLoadedCopyWithImpl<$Res>;
  @useResult
  $Res call({User currentUser, List<Class> classes});
}

/// @nodoc
class __$$HomeStateLoadedCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateLoaded>
    implements _$$HomeStateLoadedCopyWith<$Res> {
  __$$HomeStateLoadedCopyWithImpl(
      _$HomeStateLoaded _value, $Res Function(_$HomeStateLoaded) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = null,
    Object? classes = null,
  }) {
    return _then(_$HomeStateLoaded(
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User,
      classes: null == classes
          ? _value._classes
          : classes // ignore: cast_nullable_to_non_nullable
              as List<Class>,
    ));
  }
}

/// @nodoc

class _$HomeStateLoaded implements HomeStateLoaded {
  const _$HomeStateLoaded(
      {required this.currentUser, final List<Class> classes = const []})
      : _classes = classes;

  @override
  final User currentUser;
  final List<Class> _classes;
  @override
  @JsonKey()
  List<Class> get classes {
    if (_classes is EqualUnmodifiableListView) return _classes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classes);
  }

  @override
  String toString() {
    return 'HomeState.loaded(currentUser: $currentUser, classes: $classes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateLoaded &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            const DeepCollectionEquality().equals(other._classes, _classes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, currentUser, const DeepCollectionEquality().hash(_classes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateLoadedCopyWith<_$HomeStateLoaded> get copyWith =>
      __$$HomeStateLoadedCopyWithImpl<_$HomeStateLoaded>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(User currentUser, List<Class> classes) loaded,
    required TResult Function(String errorMessage) error,
    required TResult Function() singOut,
  }) {
    return loaded(currentUser, classes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(User currentUser, List<Class> classes)? loaded,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? singOut,
  }) {
    return loaded?.call(currentUser, classes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(User currentUser, List<Class> classes)? loaded,
    TResult Function(String errorMessage)? error,
    TResult Function()? singOut,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(currentUser, classes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeStateLoading value) loading,
    required TResult Function(HomeStateLoaded value) loaded,
    required TResult Function(HomeStateError value) error,
    required TResult Function(HomeStateSingedOut value) singOut,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStateLoading value)? loading,
    TResult? Function(HomeStateLoaded value)? loaded,
    TResult? Function(HomeStateError value)? error,
    TResult? Function(HomeStateSingedOut value)? singOut,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStateLoading value)? loading,
    TResult Function(HomeStateLoaded value)? loaded,
    TResult Function(HomeStateError value)? error,
    TResult Function(HomeStateSingedOut value)? singOut,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class HomeStateLoaded implements HomeState {
  const factory HomeStateLoaded(
      {required final User currentUser,
      final List<Class> classes}) = _$HomeStateLoaded;

  User get currentUser;
  List<Class> get classes;
  @JsonKey(ignore: true)
  _$$HomeStateLoadedCopyWith<_$HomeStateLoaded> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomeStateErrorCopyWith<$Res> {
  factory _$$HomeStateErrorCopyWith(
          _$HomeStateError value, $Res Function(_$HomeStateError) then) =
      __$$HomeStateErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$HomeStateErrorCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateError>
    implements _$$HomeStateErrorCopyWith<$Res> {
  __$$HomeStateErrorCopyWithImpl(
      _$HomeStateError _value, $Res Function(_$HomeStateError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$HomeStateError(
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HomeStateError implements HomeStateError {
  const _$HomeStateError({this.errorMessage = ""});

  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'HomeState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateError &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateErrorCopyWith<_$HomeStateError> get copyWith =>
      __$$HomeStateErrorCopyWithImpl<_$HomeStateError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(User currentUser, List<Class> classes) loaded,
    required TResult Function(String errorMessage) error,
    required TResult Function() singOut,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(User currentUser, List<Class> classes)? loaded,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? singOut,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(User currentUser, List<Class> classes)? loaded,
    TResult Function(String errorMessage)? error,
    TResult Function()? singOut,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeStateLoading value) loading,
    required TResult Function(HomeStateLoaded value) loaded,
    required TResult Function(HomeStateError value) error,
    required TResult Function(HomeStateSingedOut value) singOut,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStateLoading value)? loading,
    TResult? Function(HomeStateLoaded value)? loaded,
    TResult? Function(HomeStateError value)? error,
    TResult? Function(HomeStateSingedOut value)? singOut,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStateLoading value)? loading,
    TResult Function(HomeStateLoaded value)? loaded,
    TResult Function(HomeStateError value)? error,
    TResult Function(HomeStateSingedOut value)? singOut,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HomeStateError implements HomeState {
  const factory HomeStateError({final String errorMessage}) = _$HomeStateError;

  String get errorMessage;
  @JsonKey(ignore: true)
  _$$HomeStateErrorCopyWith<_$HomeStateError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomeStateSingedOutCopyWith<$Res> {
  factory _$$HomeStateSingedOutCopyWith(_$HomeStateSingedOut value,
          $Res Function(_$HomeStateSingedOut) then) =
      __$$HomeStateSingedOutCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStateSingedOutCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateSingedOut>
    implements _$$HomeStateSingedOutCopyWith<$Res> {
  __$$HomeStateSingedOutCopyWithImpl(
      _$HomeStateSingedOut _value, $Res Function(_$HomeStateSingedOut) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeStateSingedOut implements HomeStateSingedOut {
  const _$HomeStateSingedOut();

  @override
  String toString() {
    return 'HomeState.singOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStateSingedOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(User currentUser, List<Class> classes) loaded,
    required TResult Function(String errorMessage) error,
    required TResult Function() singOut,
  }) {
    return singOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(User currentUser, List<Class> classes)? loaded,
    TResult? Function(String errorMessage)? error,
    TResult? Function()? singOut,
  }) {
    return singOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(User currentUser, List<Class> classes)? loaded,
    TResult Function(String errorMessage)? error,
    TResult Function()? singOut,
    required TResult orElse(),
  }) {
    if (singOut != null) {
      return singOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeStateLoading value) loading,
    required TResult Function(HomeStateLoaded value) loaded,
    required TResult Function(HomeStateError value) error,
    required TResult Function(HomeStateSingedOut value) singOut,
  }) {
    return singOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStateLoading value)? loading,
    TResult? Function(HomeStateLoaded value)? loaded,
    TResult? Function(HomeStateError value)? error,
    TResult? Function(HomeStateSingedOut value)? singOut,
  }) {
    return singOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStateLoading value)? loading,
    TResult Function(HomeStateLoaded value)? loaded,
    TResult Function(HomeStateError value)? error,
    TResult Function(HomeStateSingedOut value)? singOut,
    required TResult orElse(),
  }) {
    if (singOut != null) {
      return singOut(this);
    }
    return orElse();
  }
}

abstract class HomeStateSingedOut implements HomeState {
  const factory HomeStateSingedOut() = _$HomeStateSingedOut;
}
