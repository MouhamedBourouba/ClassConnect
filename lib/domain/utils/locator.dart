import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_app/data/data_source/classes_data_source.dart';
import 'package:school_app/data/data_source/google_sheets.dart';
import 'package:school_app/data/data_source/user_data_source.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/data/repository/complete_account_repository.dart';
import 'package:school_app/domain/services/hashing_service.dart';
import 'package:uuid/uuid.dart';

Future<void> setupDi() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  GetIt.I.registerLazySingletonAsync<GoogleSheets>(() async {
    final googleSheets = GoogleSheets();
    await googleSheets.init();
    return googleSheets;
  });
  GetIt.I.registerLazySingletonAsync<UserDataSource>(() async {
    try {
      final googleSheets = GoogleSheetsUserDataSource(await GetIt.I.getAsync());
      return googleSheets;
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
      userDataSource: await GetIt.I.getAsync(),
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
  GetIt.I.registerLazySingletonAsync<ClassesDataSource>(
    () async => GoogleSheetsClassesDataSource(await GetIt.I.getAsync()),
  );
}
