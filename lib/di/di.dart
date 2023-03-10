import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ClassConnect/di/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: "init",
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() => getIt.init();

Future<void> init() async {
  await configureDependencies();
}
