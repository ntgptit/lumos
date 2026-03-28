import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/config/app_debounce.dart';
import 'package:lumos/core/utils/string_utils.dart';
import 'package:lumos/presentation/shared/controllers/app_debounce_controller.dart';

class AppSearchController {
  AppSearchController({
    String initialQuery = '',
    Duration debounceDuration = AppDebounce.search,
  }) : _query = initialQuery,
       _submittedQuery = initialQuery,
       _debounceDuration = debounceDuration,
       textController = TextEditingController(text: initialQuery) {
    textController.addListener(_handleTextChanged);
  }

  final TextEditingController textController;
  final AppDebounceController _debouncer = AppDebounceController();
  final Duration _debounceDuration;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  String _query;
  String _submittedQuery;

  ValueListenable<int> get changes => _revision;
  String get query => _query;
  String get submittedQuery => _submittedQuery;
  bool get hasQuery => StringUtils.hasText(_query);

  void updateQuery(String value, {bool debounced = false}) {
    if (debounced) {
      _debouncer.run(() => _commitQuery(value), duration: _debounceDuration);
      return;
    }
    _commitQuery(value);
  }

  void submit() {
    _submittedQuery = _query;
    _notify();
  }

  void clear({bool submit = true}) {
    if (textController.text.isEmpty && _query.isEmpty) {
      return;
    }
    textController.clear();
    _commitQuery('');
    if (submit) {
      _submittedQuery = '';
      _notify();
    }
  }

  void dispose() {
    _debouncer.dispose();
    _revision.dispose();
    textController
      ..removeListener(_handleTextChanged)
      ..dispose();
  }

  void _handleTextChanged() {
    final next = textController.text;
    if (next == _query) {
      return;
    }
    _query = next;
    _notify();
  }

  void _commitQuery(String value) {
    if (_query == value && textController.text == value) {
      return;
    }
    _query = value;
    if (textController.text != value) {
      textController.value = textController.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
    _notify();
  }

  void _notify() {
    _revision.value += 1;
  }
}
