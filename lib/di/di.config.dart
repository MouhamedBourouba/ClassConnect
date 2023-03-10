// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:ClassConnect/data/data_source/cloud_data_source.dart' as _i3;
import 'package:ClassConnect/data/data_source/local_data_source.dart' as _i6;
import 'package:ClassConnect/data/repository/settings_repository.dart' as _i7;
import 'package:ClassConnect/data/repository/user_repository.dart' as _i9;
import 'package:ClassConnect/data/services/hashing_service.dart' as _i5;
import 'package:ClassConnect/utils/error_logger.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:uuid/uuid.dart' as _i8;

import 'app_module.dart' as _i10;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.singletonAsync<_i3.CloudDataSource>(
      () {
        final i = _i3.GoogleSheetsCloudDataSource();
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.lazySingleton<_i4.ErrorLogger>(() => _i4.ErrorLogger());
    gh.lazySingleton<_i5.HashingService>(() => _i5.HashingService());
    await gh.singletonAsync<_i6.LocalDataSource>(
      () {
        final i = _i6.HiveLocalDataBase();
        return i.init().then((_) => i);
      },
      preResolve: true,
    );
    gh.singleton<_i7.SettingsRepository>(_i7.SettingsRepositoryImp(
      gh<_i3.CloudDataSource>(),
      gh<_i6.LocalDataSource>(),
    ));
    gh.lazySingleton<_i8.Uuid>(() => appModule.uuid);
    gh.lazySingleton<_i9.UserRepository>(() => _i9.UserRepositoryImp(
          gh<_i5.HashingService>(),
          gh<_i8.Uuid>(),
          gh<_i6.LocalDataSource>(),
          gh<_i3.CloudDataSource>(),
        ));
    return this;
  }
}

class _$AppModule extends _i10.AppModule {}