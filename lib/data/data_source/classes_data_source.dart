import 'package:school_app/data/data_source/google_sheets.dart';
import 'package:school_app/data/model/class.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';

abstract class ClassesDataSource {
  Future<void> createClass({required Class classAdded, required User currentUser});

  Future<void> joinClass(String classId, String currentUserId, List<String> joinedClasses);
}

class GoogleSheetsClassesDataSource extends ClassesDataSource {
  final GoogleSheets googleSheets;

  GoogleSheetsClassesDataSource(this.googleSheets);

  @override
  Future<void> createClass({required Class classAdded, required User currentUser}) async {
    final addClassTask = googleSheets.classesWorkSheet.values.map.appendRow(classAdded.toMap());
    if(currentUser.teachingClasses == null) {
      currentUser.teachingClasses = [classAdded.id];
      currentUser.save();
    }
    else {
      currentUser.teachingClasses?.add(classAdded.id);
      currentUser.save();
    }
    final updateUserTask = googleSheets.userWorkSheet.values.insertValueByKeys(
      currentUser.teachingClasses.toString(),
      columnKey: "teachingClasses",
      rowKey: currentUser.id,
    );
    if (await addClassTask && await updateUserTask) {
      return;
    } else {
      throw UnknownException();
    }
  }

  @override
  Future<void> joinClass(String classId, String currentUserId, List<String> joinedClasses) async {
    joinedClasses.add(classId);
    final success = await googleSheets.userWorkSheet.values.insertValueByKeys(
      joinedClasses,
      columnKey: "classes",
      rowKey: currentUserId,
    );
    if (success) {
      return;
    } else {
      throw UnknownException();
    }
  }
}
