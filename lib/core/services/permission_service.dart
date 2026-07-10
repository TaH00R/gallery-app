import 'package:photo_manager/photo_manager.dart';

class PermissionService {
  PermissionService._();

  static Future<bool> request() async {
    final permission =
        await PhotoManager.requestPermissionExtend();

    return permission.isAuth;
  }

  static Future<void> openSettings() async {
    await PhotoManager.openSetting();
  }
}