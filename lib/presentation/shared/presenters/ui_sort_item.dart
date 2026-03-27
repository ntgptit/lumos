import 'package:flutter/foundation.dart';
import 'package:lumos/core/enums/sort_direction.dart';

@immutable
class UiSortItem<T> {
  const UiSortItem({
    required this.label,
    required this.value,
    this.direction = SortDirection.asc,
    this.selected = false,
    this.enabled = true,
  });

  final String label;
  final T value;
  final SortDirection direction;
  final bool selected;
  final bool enabled;

  UiSortItem<T> copyWith({
    String? label,
    T? value,
    SortDirection? direction,
    bool? selected,
    bool? enabled,
  }) {
    return UiSortItem<T>(
      label: label ?? this.label,
      value: value ?? this.value,
      direction: direction ?? this.direction,
      selected: selected ?? this.selected,
      enabled: enabled ?? this.enabled,
    );
  }
}
