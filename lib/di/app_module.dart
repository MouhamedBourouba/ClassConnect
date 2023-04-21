import 'package:ClassConnect/utils/utils.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class AppModule {
  @lazySingleton
  Uuid get uuid => const Uuid();
  @lazySingleton
  RandomColorGenerator get randomColorGenerator => RandomColorGenerator();
}
