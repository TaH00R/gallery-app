import 'package:flutter/widgets.dart';

class MediaQueryUtils {
  MediaQueryUtils._();

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation ==
        Orientation.landscape;
  }
}