import 'dart:convert';
import 'package:crypto/crypto.dart';

class Hashing {
  String hash(value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }
  bool verify(value, hashedValue) => hashedValue == hash(value);
}
