import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashingService {
  String hash(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  bool verify(String value, String hashedValue) => hashedValue == hash(value);
}
