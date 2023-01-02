import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_app/data/model/user_entity.dart';

Future<void> setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserEntityAdapter());
}
