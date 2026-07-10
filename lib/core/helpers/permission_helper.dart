import 'package:photo_manager/photo_manager.dart';

class PermissionHelper {
  PermissionHelper._();

  static Future<bool> requestGalleryPermission() async {
    final PermissionState state =
        await PhotoManager.requestPermissionExtend();

    return state.isAuth;
  }

  static Future<void> openSettings() async {
    await PhotoManager.openSetting();
  }
}