// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UpdateProfileState {
  User get currentUser => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;
  PageState get pageState => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)
        init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)?
        init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)?
        init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateProfileStateInit value) init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateProfileStateInit value)? init,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateProfileStateInit value)? init,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateProfileStateCopyWith<UpdateProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProfileStateCopyWith<$Res> {
  factory $UpdateProfileStateCopyWith(
          UpdateProfileState value, $Res Function(UpdateProfileState) then) =
      _$UpdateProfileStateCopyWithImpl<$Res, UpdateProfileState>;
  @useResult
  $Res call(
      {User currentUser,
      String fullName,
      String email,
      String phoneNumber,
      String errorMessage,
      PageState pageState});
}

/// @nodoc
class _$UpdateProfileStateCopyWithImpl<$Res, $Val extends UpdateProfileState>
    implements $UpdateProfileStateCopyWith<$Res> {
  _$UpdateProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = null,
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? errorMessage = null,
    Object? pageState = null,
  }) {
    return _then(_value.copyWith(
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      pageState: null == pageState
          ? _value.pageState
          : pageState // ignore: cast_nullable_to_non_nullable
              as PageState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProfileStateInitCopyWith<$Res>
    implements $UpdateProfileStateCopyWith<$Res> {
  factory _$$UpdateProfileStateInitCopyWith(_$UpdateProfileStateInit value,
          $Res Function(_$UpdateProfileStateInit) then) =
      __$$UpdateProfileStateInitCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User currentUser,
      String fullName,
      String email,
      String phoneNumber,
      String errorMessage,
      PageState pageState});
}

/// @nodoc
class __$$UpdateProfileStateInitCopyWithImpl<$Res>
    extends _$UpdateProfileStateCopyWithImpl<$Res, _$UpdateProfileStateInit>
    implements _$$UpdateProfileStateInitCopyWith<$Res> {
  __$$UpdateProfileStateInitCopyWithImpl(_$UpdateProfileStateInit _value,
      $Res Function(_$UpdateProfileStateInit) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = null,
    Object? fullName = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? errorMessage = null,
    Object? pageState = null,
  }) {
    return _then(_$UpdateProfileStateInit(
      currentUser: null == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
      pageState: null == pageState
          ? _value.pageState
          : pageState // ignore: cast_nullable_to_non_nullable
              as PageState,
    ));
  }
}

/// @nodoc

class _$UpdateProfileStateInit implements UpdateProfileStateInit {
  const _$UpdateProfileStateInit(
      {required this.currentUser,
      this.fullName = "",
      this.email = "",
      this.phoneNumber = "",
      this.errorMessage = "",
      this.pageState = PageState.init});

  @override
  final User currentUser;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final String errorMessage;
  @override
  @JsonKey()
  final PageState pageState;

  @override
  String toString() {
    return 'UpdateProfileState.init(currentUser: $currentUser, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, errorMessage: $errorMessage, pageState: $pageState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProfileStateInit &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.pageState, pageState) ||
                other.pageState == pageState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentUser, fullName, email,
      phoneNumber, errorMessage, pageState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProfileStateInitCopyWith<_$UpdateProfileStateInit> get copyWith =>
      __$$UpdateProfileStateInitCopyWithImpl<_$UpdateProfileStateInit>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)
        init,
  }) {
    return init(
        currentUser, fullName, email, phoneNumber, errorMessage, pageState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)?
        init,
  }) {
    return init?.call(
        currentUser, fullName, email, phoneNumber, errorMessage, pageState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User currentUser, String fullName, String email,
            String phoneNumber, String errorMessage, PageState pageState)?
        init,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(
          currentUser, fullName, email, phoneNumber, errorMessage, pageState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UpdateProfileStateInit value) init,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UpdateProfileStateInit value)? init,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UpdateProfileStateInit value)? init,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class UpdateProfileStateInit implements UpdateProfileState {
  const factory UpdateProfileStateInit(
      {required final User currentUser,
      final String fullName,
      final String email,
      final String phoneNumber,
      final String errorMessage,
      final PageState pageState}) = _$UpdateProfileStateInit;

  @override
  User get currentUser;
  @override
  String get fullName;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  String get errorMessage;
  @override
  PageState get pageState;
  @override
  @JsonKey(ignore: true)
  _$$UpdateProfileStateInitCopyWith<_$UpdateProfileStateInit> get copyWith =>
      throw _privateConstructorUsedError;
}
