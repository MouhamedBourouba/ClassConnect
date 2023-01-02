import 'package:gsheets/gsheets.dart';
import 'package:school_app/data/extentions.dart';
import 'package:school_app/data/model/user.dart';

class GoogleSheets {
  final String _spreadSheetCredentials = r''' 
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

  static int row = 0;
  final String _usersSpreadSheetId =
      "1GvxPl2xXmgNP2LNhkr6EebgTQl-AieL1_NIYMTyLJnU";
  late Spreadsheet spreadSheet;
  late Worksheet usersWorkSheet;

  Future<void> init() async {
    final gsheets = GSheets(_spreadSheetCredentials);
    spreadSheet = await gsheets
        .spreadsheet(_usersSpreadSheetId)
        .timeout(const Duration(seconds: 20));
    usersWorkSheet = spreadSheet.worksheetByTitle("Users")!;
  }

  Future<bool> insertUser(User user) async {
    final userList = await usersWorkSheet.cells.findByValue(user.email);
    if (userList.isNotEmpty) {
      return Future.error("User Already Exist, try Login in");
    }
    return usersWorkSheet.values
        .appendRow(user.toList())
        .timeout(const Duration(seconds: 20));
  }

  Future<User> getUserByEmail(String email) async {
    final userLocation = await usersWorkSheet.cells
        .findByValue(email)
        .timeout(const Duration(seconds: 20));
    row = userLocation.first.row;
    final userList = await usersWorkSheet.values.row(userLocation.first.row);
    return userList.toUser();
  }

  Future<bool> updateUser(String value, FieldType field) async {
    return false;
  }
}

enum FieldType {
  firstName,
  lastName,
  email,
  password,
  username,
  parentPhone,
  grade
}
