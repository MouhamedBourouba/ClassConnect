import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_app/data/google_sheets.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/domain/services/hashing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> setupDi() async {
  GetIt.I.registerLazySingleton(() async {
    final googleSheets = GoogleSheets();
    await googleSheets.init();
    return googleSheets;
  });
  GetIt.I.registerLazySingleton(() => HashingService());
  GetIt.I.registerLazySingleton(() => const Uuid());
  GetIt.I.registerLazySingleton(() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref;
  });
  GetIt.I.registerLazySingleton(() async {
    final box = await Hive.openBox("app_data");
    return box;
  });
  GetIt.I.registerLazySingleton<AuthRepository>(() {
    final AuthRepository authRepository = AuthRepositoryImp(
      uuid: GetIt.I.get(),
      googleSheets: GetIt.I.get<GoogleSheets>(),
      hash: GetIt.I.get(),
      hiveBox: GetIt.I.get(),
    );
    return authRepository;
  });
}
