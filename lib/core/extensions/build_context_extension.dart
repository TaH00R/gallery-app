import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);

  double get width => screenSize.width;

  double get height => screenSize.height;

  void pop<T extends Object?>([T? result]) => Navigator.pop(this, result);
}