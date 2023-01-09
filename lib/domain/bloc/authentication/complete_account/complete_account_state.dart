part of 'complete_account_cubit.dart';

class CompleteAccountState extends Equatable {
  String firstName = "";
  String lastName = "";
  String parentPhone = "";
  int? grade = 1;
  ScreenStatus screenStatus = ScreenStatus.initial;
  String error = "";
  String? dialCode = "";

  CompleteAccountState copyWith({
    String? firstName,
    String? lastName,
    String? parentPhone,
    String? conformPassword,
    ScreenStatus? screenStatus,
    String? error,
    int? grade,
  }) {
    return CompleteAccountState()
      ..firstName = firstName ?? this.firstName
      ..lastName = lastName ?? this.lastName
      ..parentPhone = parentPhone ?? this.parentPhone
      ..dialCode = dialCode
      ..screenStatus = screenStatus ?? this.screenStatus
      ..error = error ?? this.error
      ..grade = grade ?? this.grade;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [firstName, lastName, parentPhone, grade, screenStatus, error, dialCode];
}
