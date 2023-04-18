// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ClassMessage {
  String get content => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String get classId => throw _privateConstructorUsedError;
  int get sentTimeMS => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClassMessageCopyWith<ClassMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClassMessageCopyWith<$Res> {
  factory $ClassMessageCopyWith(
          ClassMessage value, $Res Function(ClassMessage) then) =
      _$ClassMessageCopyWithImpl<$Res, ClassMessage>;
  @useResult
  $Res call(
      {String content,
      String senderId,
      String senderName,
      String classId,
      int sentTimeMS});
}

/// @nodoc
class _$ClassMessageCopyWithImpl<$Res, $Val extends ClassMessage>
    implements $ClassMessageCopyWith<$Res> {
  _$ClassMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? classId = null,
    Object? sentTimeMS = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      classId: null == classId
          ? _value.classId
          : classId // ignore: cast_nullable_to_non_nullable
              as String,
      sentTimeMS: null == sentTimeMS
          ? _value.sentTimeMS
          : sentTimeMS // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ClassMessageCopyWith<$Res>
    implements $ClassMessageCopyWith<$Res> {
  factory _$$_ClassMessageCopyWith(
          _$_ClassMessage value, $Res Function(_$_ClassMessage) then) =
      __$$_ClassMessageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      String senderId,
      String senderName,
      String classId,
      int sentTimeMS});
}

/// @nodoc
class __$$_ClassMessageCopyWithImpl<$Res>
    extends _$ClassMessageCopyWithImpl<$Res, _$_ClassMessage>
    implements _$$_ClassMessageCopyWith<$Res> {
  __$$_ClassMessageCopyWithImpl(
      _$_ClassMessage _value, $Res Function(_$_ClassMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? classId = null,
    Object? sentTimeMS = null,
  }) {
    return _then(_$_ClassMessage(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _value.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      classId: null == classId
          ? _value.classId
          : classId // ignore: cast_nullable_to_non_nullable
              as String,
      sentTimeMS: null == sentTimeMS
          ? _value.sentTimeMS
          : sentTimeMS // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_ClassMessage with DiagnosticableTreeMixin implements _ClassMessage {
  const _$_ClassMessage(
      {this.content = "",
      this.senderId = "",
      this.senderName = "",
      this.classId = "",
      this.sentTimeMS = 0});

  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String senderId;
  @override
  @JsonKey()
  final String senderName;
  @override
  @JsonKey()
  final String classId;
  @override
  @JsonKey()
  final int sentTimeMS;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ClassMessage(content: $content, senderId: $senderId, senderName: $senderName, classId: $classId, sentTimeMS: $sentTimeMS)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ClassMessage'))
      ..add(DiagnosticsProperty('content', content))
      ..add(DiagnosticsProperty('senderId', senderId))
      ..add(DiagnosticsProperty('senderName', senderName))
      ..add(DiagnosticsProperty('classId', classId))
      ..add(DiagnosticsProperty('sentTimeMS', sentTimeMS));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ClassMessage &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.classId, classId) || other.classId == classId) &&
            (identical(other.sentTimeMS, sentTimeMS) ||
                other.sentTimeMS == sentTimeMS));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, content, senderId, senderName, classId, sentTimeMS);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ClassMessageCopyWith<_$_ClassMessage> get copyWith =>
      __$$_ClassMessageCopyWithImpl<_$_ClassMessage>(this, _$identity);
}

abstract class _ClassMessage implements ClassMessage {
  const factory _ClassMessage(
      {final String content,
      final String senderId,
      final String senderName,
      final String classId,
      final int sentTimeMS}) = _$_ClassMessage;

  @override
  String get content;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String get classId;
  @override
  int get sentTimeMS;
  @override
  @JsonKey(ignore: true)
  _$$_ClassMessageCopyWith<_$_ClassMessage> get copyWith =>
      throw _privateConstructorUsedError;
}
