import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/data/repository/complete_account_repository.dart';
import 'package:school_app/data/user_data_source.dart';
import 'package:school_app/domain/services/hashing_service.dart';
import 'package:uuid/uuid.dart';

Future<void> setupDi() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  GetIt.I.registerLazySingletonAsync<UserDataSource>(() async {
    try {
      final googleSheets = GoogleSheetsDataSource();
      return googleSheets.init();
    } on Exception {
      throw UnknownException();
    }
  });
  GetIt.I.registerLazySingleton(() => HashingService());
  GetIt.I.registerLazySingleton(() => const Uuid());
  GetIt.I.registerSingletonAsync<Box>(() async {
    final box = await Hive.openBox("app_data");
    return box;
  });
  GetIt.I.registerFactoryAsync<User>(() async {
    final hiveBox = await GetIt.I.getAsync<Box>();
    final user = await hiveBox.get("user") as User?;
    return user ?? User.defaultUser();
  });
  GetIt.I.registerLazySingletonAsync<AuthRepository>(() async {
    final AuthRepository authRepository = AuthRepositoryImp(
      uuid: GetIt.I.get(),
      hashingService: GetIt.I.get(),
      dataSource: await GetIt.I.getAsync(),
      hiveBox: await GetIt.I.getAsync(),
    );
    return authRepository;
  });
  GetIt.I.registerLazySingletonAsync<CompleteAccountRepository>(() async {
    final completeAccountRepository = CompleteAccountRepositoryImpl(
      hiveBox: await GetIt.I.getAsync<Box>(),
      userDataSource: await GetIt.I.getAsync<UserDataSource>(),
    );
    return completeAccountRepository;
  });
}
