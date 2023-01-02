abstract class CompleteAccountRepository {
  Future<bool> completeAccount(int grade, String firstName, String lastName, String phoneNumber);
}

class UserRepositoryImp extends CompleteAccountRepository {
  @override
  Future<bool> completeAccount(int grade, String firstName, String lastName, String phoneNumber) {
    // TODO: implement completeAccount
    throw UnimplementedError();
  }
}
