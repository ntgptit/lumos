import 'package:flutter/foundation.dart';

class AppSelectionController<T> {
  AppSelectionController([Iterable<T> initialSelection = const []])
    : _selected = <T>{...initialSelection};

  final Set<T> _selected;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  ValueListenable<int> get changes => _revision;
  Set<T> get selected => Set<T>.unmodifiable(_selected);
  int get count => _selected.length;
  bool get isEmpty => _selected.isEmpty;
  bool get isNotEmpty => _selected.isNotEmpty;

  bool isSelected(T value) => _selected.contains(value);

  void toggle(T value) {
    final removed = _selected.remove(value);
    if (!removed) {
      _selected.add(value);
    }
    _notify();
  }

  void select(T value) {
    if (_selected.add(value)) {
      _notify();
    }
  }

  void deselect(T value) {
    if (_selected.remove(value)) {
      _notify();
    }
  }

  void replaceAll(Iterable<T> values) {
    _selected
      ..clear()
      ..addAll(values);
    _notify();
  }

  void selectAll(Iterable<T> values) {
    final before = _selected.length;
    _selected.addAll(values);
    if (_selected.length != before) {
      _notify();
    }
  }

  void clear() {
    if (_selected.isEmpty) {
      return;
    }
    _selected.clear();
    _notify();
  }

  void dispose() {
    _revision.dispose();
  }

  void _notify() {
    _revision.value += 1;
  }
}
