import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lumos/core/config/app_debounce.dart';

class AppDebounceController {
  AppDebounceController({this.defaultDuration = AppDebounce.typing});

  final Duration defaultDuration;
  Timer? _timer;

  bool get isActive => _timer?.isActive ?? false;

  void run(VoidCallback action, {Duration? duration}) {
    cancel();
    _timer = Timer(duration ?? defaultDuration, action);
  }

  void flush(VoidCallback action) {
    cancel();
    action();
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    cancel();
  }
}
