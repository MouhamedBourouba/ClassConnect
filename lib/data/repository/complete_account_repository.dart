import 'package:hive/hive.dart';
import 'package:school_app/data/model/user.dart';
import 'package:school_app/data/user_data_source.dart';

abstract class CompleteAccountRepository {
  Future<void> completeAccount(
    int grade,
    String firstName,
    String lastName,
    String phoneNumber,
  );
}

class CompleteAccountRepositoryImpl extends CompleteAccountRepository {
  final Box hiveBox;
  final UserDataSource userDataSource;

  CompleteAccountRepositoryImpl({
    required this.hiveBox,
    required this.userDataSource,
  });

  @override
  Future<void> completeAccount(
    int grade,
    String firstName,
    String lastName,
    String phoneNumber,
  ) async {
    final userId = (hiveBox.get("user") as User).id;
    final updateFirstName =
        userDataSource.updateUser(userId, "firstName", firstName);
    final updateLastName =
        userDataSource.updateUser(userId, "lastName", lastName);
    final updateGrade =
        userDataSource.updateUser(userId, "grade", grade.toString());
    final updatePhoneNumber =
        userDataSource.updateUser(userId, "parentPhone", phoneNumber);

    await updateFirstName;
    await updateLastName;
    await updateGrade;
    await updatePhoneNumber;

    final localUser = hiveBox.get("user") as User;
    localUser
      ..firstName = firstName
      ..lastName = lastName
      ..grade = grade
      ..parentPhone = phoneNumber;
    await hiveBox.put("isAccountCompleted", true);
    await localUser.save();
  }
}
