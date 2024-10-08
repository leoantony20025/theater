import 'package:flutter/material.dart';

class NoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  @override
  bool get shouldAcceptUserOffset => false; // Disable manual scrolling
}
