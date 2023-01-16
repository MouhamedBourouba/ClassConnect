import 'package:hive/hive.dart';
import 'package:school_app/data/data_source/user_data_source.dart';
import 'package:school_app/data/model/user.dart';

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
    final user = hiveBox.get("user") as User;
    final updateFirstName = userDataSource.updateUser(
      user.id,
      "firstName",
      firstName,
    );
    final updateLastName = userDataSource.updateUser(
      user.id,
      "lastName",
      lastName,
    );
    final updateGrade = userDataSource.updateUser(
      user.id,
      "grade",
      grade.toString(),
    );
    final updatePhoneNumber = userDataSource.updateUser(
      user.id,
      "parentPhone",
      phoneNumber,
    );

    await updateFirstName;
    await updateLastName;
    await updateGrade;
    await updatePhoneNumber;

    user
      ..firstName = firstName
      ..lastName = lastName
      ..grade = grade
      ..parentPhone = phoneNumber;

    await hiveBox.put("isAccountCompleted", true);
    await user.save();
  }
}
