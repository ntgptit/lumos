import 'package:lumos/core/utils/list_utils.dart';

extension ListExt<T> on List<T> {
  T? safeElementAt(int index) => ListUtils.safeElementAt(this, index);

  List<T> replacingAt(int index, T value) {
    return ListUtils.replaceAt(this, index, value);
  }

  List<T> toggled(T value) {
    return ListUtils.toggle(this, value);
  }

  List<T> get unique => ListUtils.unique(this);
}
