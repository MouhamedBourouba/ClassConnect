import 'package:gsheets/gsheets.dart';
import 'package:injectable/injectable.dart';

enum MTable { usersTable, classesTable }

abstract class CloudDataSource {
  Future<Map<String, String>?> getRow(MTable table, {required String rowKey});

  Future<List<Map<String, String>>?> getAllRows(MTable table);

  Future<List<Map<String, String>>?> getRowsByValue(dynamic value, MTable table);

  Future<bool> appendRow(Map<String, String> data, MTable table);

  Future<bool> updateValue(dynamic newValue, MTable table, {required String rowKey, required String columnKey});

  Future<bool> deleteRow(MTable table, {required String rowKey});
}

@LazySingleton(as: CloudDataSource)
class GoogleSheetsCloudDataSource implements CloudDataSource {
  Worksheet? usersWorkSheet;
  Worksheet? classesWorkSheet;
  late Worksheet currentWorkSheet;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await connectToGoogleSheets();
  }

  Future<void> connectToGoogleSheets() async {
    final gSheets = GSheets(GSHEETS_CREDINTIONS);
    final gSheetsClient = await gSheets.client(SPREAD_SHEET_ID);
    usersWorkSheet = await gSheetsClient.worksheetByTitle("users");
  }

  void changeCurrentWorkSheet(MTable table) {
    switch (table) {
      case MTable.usersTable:
        currentWorkSheet = usersWorkSheet!;
        break;
      case MTable.classesTable:
        currentWorkSheet = classesWorkSheet!;
        break;
    }
  }

  @override
  Future<bool> appendRow(Map<String, String> data, MTable table) {
    changeCurrentWorkSheet(table);
    return currentWorkSheet.values.map.appendRow(data, appendMissing: true);
  }

  @override
  Future<bool> deleteRow(MTable table, {required String rowKey}) {
    changeCurrentWorkSheet(table);
    return currentWorkSheet.values.map.insertRowByKey(rowKey, {});
  }

  @override
  Future<List<Map<String, String>>?> getAllRows(MTable table) {
    changeCurrentWorkSheet(table);
    return currentWorkSheet.values.map.allRows();
  }

  @override
  Future<Map<String, String>?> getRow(MTable table, {required String rowKey}) {
    changeCurrentWorkSheet(table);
    return currentWorkSheet.values.map.rowByKey(rowKey);
  }

  @override
  Future<bool> updateValue(dynamic newValue, MTable table, {required String rowKey, required String columnKey}) {
    changeCurrentWorkSheet(table);
    return currentWorkSheet.values.insertValueByKeys(newValue.toString(), columnKey: columnKey, rowKey: rowKey);
  }

  @override
  Future<List<Map<String, String>>?> getRowsByValue(dynamic value, MTable table) async {
    changeCurrentWorkSheet(table);
    final cellsList = await currentWorkSheet.cells.findByValue(value.toString());
    final List<Future<Map<String, String>>> fetchTasks = [];
    final List<Map<String, String>> valuesMaps = [];
    for (final cell in cellsList) {
      fetchTasks.add(currentWorkSheet.values.map.row(cell.row));
    }
    for (final task in fetchTasks) {
      final data = await task;
      valuesMaps.add(data);
    }
    return valuesMaps;
  }
}
