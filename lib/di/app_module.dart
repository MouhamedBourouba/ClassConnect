import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:school_app/data/repository/user_repository.dart';
import 'package:school_app/ui/pages/complete_account_page.dart';
import 'package:school_app/ui/pages/home_page.dart';
import 'package:school_app/ui/pages/login_page.dart';
import 'package:uuid/uuid.dart';

@module
abstract class AppModule {
  @lazySingleton
  Uuid get uuid => const Uuid();
}
