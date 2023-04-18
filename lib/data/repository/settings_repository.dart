import 'package:ClassConnect/data/data_source/cloud_data_source.dart';
import 'package:ClassConnect/data/data_source/local_data_source.dart';
import 'package:injectable/injectable.dart';

abstract class SettingsRepository {
  bool isAuthenticated();

  bool isEmailVerified();

  void setIsEmailVerified({required bool isEmailVerified});

}

@Singleton(as: SettingsRepository)
class SettingsRepositoryImp extends SettingsRepository {
  final CloudDataSource cloudDataSource;
  final LocalDataSource localDataSource;

  SettingsRepositoryImp(this.cloudDataSource, this.localDataSource);

  @override
  bool isAuthenticated() => localDataSource.getCurrentUser() != null;

  @override
  bool isEmailVerified() => localDataSource.getValueFromAppBox("isEmailVerified", defaultValue: false) as bool;

  @override
  void setIsEmailVerified({required bool isEmailVerified}) =>
      localDataSource.setValueToAppBox("isEmailVerified", isEmailVerified);
}
