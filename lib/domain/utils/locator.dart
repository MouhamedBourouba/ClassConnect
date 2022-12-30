import 'package:school_app/data/google_sheets.dart';
import 'package:school_app/data/repository/auth_repository.dart';
import 'package:school_app/domain/utils/hashing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:get_it/get_it.dart';

Future<void> setupDi() async {
  final GoogleSheets googleSheets = GoogleSheets();
  final Hashing hashing = Hashing();
  const Uuid uuid = Uuid();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final AuthRepository authRepositoryImp = AuthRepositoryImp(uuid, hashing, googleSheets, sharedPreferences);

  GetIt.I.registerLazySingleton<AuthRepository>(() => authRepositoryImp);
  GetIt.I.registerLazySingleton(() => googleSheets);
  GetIt.I.registerLazySingleton(() => hashing);
  GetIt.I.registerLazySingleton(() => sharedPreferences);
  GetIt.I.registerLazySingleton(() => uuid);
}
