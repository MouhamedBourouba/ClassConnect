import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'class_message.freezed.dart';

@freezed
class ClassMessage with _$ClassMessage {
  const factory ClassMessage({
    @Default("") String content,
    @Default("") String senderId,
    @Default("") String senderName,
    @Default("") String classId,
    @Default(0) int sentTimeMS,
  }) = _ClassMessage;
}
