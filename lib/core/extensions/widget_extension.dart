import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget withPadding([double value = 16]) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget centered() {
    return Center(child: this);
  }
}