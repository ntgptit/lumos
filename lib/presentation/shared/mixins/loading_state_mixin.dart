import 'package:flutter/material.dart';

mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @protected
  void setLoading(bool value) {
    if (_isLoading == value || !mounted) {
      return;
    }
    setState(() {
      _isLoading = value;
    });
  }

  @protected
  Future<R> runWithLoading<R>(Future<R> Function() action) async {
    setLoading(true);
    try {
      return await action();
    } finally {
      if (mounted) {
        setLoading(false);
      }
    }
  }
}
