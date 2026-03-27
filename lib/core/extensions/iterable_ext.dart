import 'package:lumos/core/utils/list_utils.dart';

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  List<T> get unique => ListUtils.unique(this);

  Iterable<T> separatedBy(T separator) sync* {
    var index = 0;
    for (final item in this) {
      if (index > 0) {
        yield separator;
      }
      yield item;
      index++;
    }
  }
}

extension NullableIterableExt<T> on Iterable<T?> {
  Iterable<T> get whereNotNull sync* {
    for (final item in this) {
      if (item != null) {
        yield item;
      }
    }
  }
}
