import 'package:gsheets/gsheets.dart';
import 'package:school_app/data/extension.dart';
import 'package:school_app/data/model/unknown_exception.dart';
import 'package:school_app/data/model/user.dart';

abstract class UserDataSource {
  Future<void> init();

  // returns 0 if error if not returns user row
  Future<void> appendUser(User user);

  Future<User> findUserByEmail(String value);

  Future<bool> updateUser(String userId, String columnKey, String value);

  Future<User?> fetchUserById(String id);
}

class GoogleSheetsDataSource extends UserDataSource {
  final String spreadSheetCredentials = r''' 
  {
  "type": "service_account",
  "project_id": "school-app-369018",
  "private_key_id": "ec7af375eea3db8df2551ad501672bd3875d928a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCvv2xOSB5wmkkM\nCClLt53DO/iAnvFQW+yPjvYHbmPjPvy+1Wc5h+ow/rR5dJ+5lo3ZpTGVO7TibVIu\nIOcIFTcI0fNvgA1zdzFbXj9WkGmKF28WvoYVyJo0YiBPUphx+7s2qO1u3dVkLh8j\n9InrBBsUImkaJN/4eQRMSQeOMMZ6Jb5QETZP9+lkPkwhRC/eO19DzGYHwdMWZuJ/\ngc/IQleuuwTDI0RQ74t5E5lnkh/T1ZGWmpC7RVkTlR3jxQ4ag3Zz3qxlS3V4vhMe\n2dn3zuMUqlEYAMAnyMSDmyhF4g/J80cwbWEFs/1g5NLLZmKXmomf5r7JzUAZeF5R\ni7azSBjTAgMBAAECggEACU0Gd1IbwkvNUoSwDXYciZ4yiuQJKKk6E2g2dF2O4xI3\nSrDSiK89C/YUKQVXWqQGwnOanyeMwsWUVCVLn22NVGXVY0Y8mqq+gvOxmGwwxFfJ\nz5iqUfF5hQzYYY+hH7nPG5fEZln5FsHWG2Sv/oRgxn0CYO7TUjwH/TLe4n3e/cx2\nYGVFm8FRGDaNJpE/xClhb/kKMBNwJM1Ohu542OVNg/MxHJTikPY78Fp5dmBfHCrL\ne7Hf89JM7eKcCd/2MgdgFLCS9iRtu8HF3eMN9lv9ysyHLPVLXUZhkt1yEtv7jvpJ\ngGmQnoo8dw+ArdxFJoZKExz6mDyr8Mn3eTDeXU79mQKBgQDkZyY7p80jSM0e+91I\n6OyFwnNM95bZa9hZ/f9xt0lysaQWbxNnJVbmK8zAetHaTv57wdDW1/x0XNEguYgh\nDApVhXQN4wg3knA6PL3uj6HxXMR1CPeaRzaitoqoe+MZRlEeZGy4zEdoaJyl5pyf\nqoeREtQVBtYhJwX833WrNQSqvwKBgQDE+5GYF9LTxbNCXsXGAiPllYl05lH689eU\n3ShVstP1dFC+qdSIqxtMRHZ4Bbxlwk6PtKdn1TFdv+1zmGmma6EZ8GkFZbGZEROw\nBGmHwa/MobTZ6C03soghKvNABMtWpKmtYg4Dt5oS0dqDDZvy5MAP2HRJeNCtUYWT\noBHL9Cl67QKBgATbtNJ8BT8E42gPT2unmLBXrIAsnAbP5nAzmOVgUq2f3a+keTMu\ndiS7NcW6VxBfscYMH1cSjQokl0Ys7BpX2ThseEV7WMdl1AFJHXkfkQBDSuJ6aFnd\nvenEHDrtN61n833EARQFNFeiMgLNXvN+exe44M35sUBPRi9UyXn0zL6dAoGAXudx\nixyXR86tgiGVGcQ4NUmpkzfQcZ7/08oFv9xLwKuMp3+9VSdTHJizlzn0Pfay0QvR\nx/XwNeHdbl8VL8gVMyEgCCipuzx+BsTpby3DHE0gjAgPmREcAxblYYetzA3DbjSa\n2fGgesa+h3uMEidh3YCE7k0WBRsMx0ZMrL3zKjUCgYB03zpDd83LlDFA0Bsvold/\nI3TJ/6HrLdWpCRqmK5pmlPAFKIsdSlOG09p4t0MAShuZgs+sE/rwFqAegNyMI8vo\nFzixRlKQ/VTNJr1B2lpKBhexWyiBpuGeo/XYeUKWqQok4jtBNJ4l6AUtxXIzECPf\nS5tuMTO9/u2+XmhX2od2Bg==\n-----END PRIVATE KEY-----\n",
  "client_email": "app-db@school-app-369018.iam.gserviceaccount.com",
  "client_id": "117162500380889619597",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/app-db%40school-app-369018.iam.gserviceaccount.com"
}
''';
  final String appSpreadSheetId = "1GvxPl2xXmgNP2LNhkr6EebgTQl-AieL1_NIYMTyLJnU";
  late Worksheet usersWorkSheet;

  @override
  Future<GoogleSheetsDataSource> init() async {
    final gsheets = GSheets(spreadSheetCredentials);
    final spreadSheet = await gsheets.spreadsheet(appSpreadSheetId);
    usersWorkSheet = spreadSheet.worksheetByTitle("Users")!;
    return this;
  }

  @override
  Future<void> appendUser(User user) async {
    try {
      final userInDB = await usersWorkSheet.cells.findByValue(user.email);
      if (userInDB.isNotEmpty) {
        return Future.error("user already exist, login");
      }
      final userFromDB = user.toMap();
      if (userFromDB == null) {
        throw UnknownException();
      }
      final appendTask = await usersWorkSheet.values.map.appendRow(userFromDB);
      return;
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<User> findUserByEmail(String value) async {
    try {
      final userCellLocation = await usersWorkSheet.cells.findByValue(value);

      if (userCellLocation.isEmpty) {
        return Future.error("user dose not exist, did try registering");
      }

      final userJson = await usersWorkSheet.values.map.row(userCellLocation.first.row);

      if (userJson.isNotEmpty) {
        return userJson.toUser();
      } else {
        return Future.error("unknown error please try again later");
      }
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<bool> updateUser(String userId, String columnKey, String value) async {
    try {
      return usersWorkSheet.values.insertValueByKeys(value, columnKey: columnKey, rowKey: userId);
    } on Exception {
      throw UnknownException();
    }
  }

  @override
  Future<User?> fetchUserById(String id) async {
    try {
      final userMap = await usersWorkSheet.values.map.rowByKey(id);
      if (userMap == null) {
        throw Future.error("user dose not exist!");
      }
      return userMap.toUser();
    } on Exception {
      throw UnknownException();
    }
  }
}
