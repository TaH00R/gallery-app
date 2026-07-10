import 'dart:io';

class DeviceUtils {
  DeviceUtils._();

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isDesktop =>
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS;
}