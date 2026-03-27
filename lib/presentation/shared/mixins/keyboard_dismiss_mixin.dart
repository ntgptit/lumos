import 'package:flutter/material.dart';
import 'package:lumos/core/utils/keyboard_utils.dart';

mixin KeyboardDismissMixin<T extends StatefulWidget> on State<T> {
  void dismissKeyboard() {
    KeyboardUtils.dismiss(context);
  }

  Widget withKeyboardDismiss({
    required Widget child,
    HitTestBehavior behavior = HitTestBehavior.translucent,
  }) {
    return GestureDetector(
      behavior: behavior,
      onTap: dismissKeyboard,
      child: child,
    );
  }
}
