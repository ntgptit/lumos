import 'package:flutter/material.dart';

abstract final class AppMouseCursors {
  AppMouseCursors._();

  static const MouseCursor clickable = SystemMouseCursors.click;

  static MouseCursor resolve({required bool isInteractive}) {
    if (!isInteractive) {
      return MouseCursor.defer;
    }
    return clickable;
  }
}
