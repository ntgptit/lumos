import 'package:flutter/material.dart';

@immutable
class UiFilterItem<T> {
  const UiFilterItem({
    required this.label,
    required this.value,
    this.selected = false,
    this.enabled = true,
    this.count,
    this.icon,
    this.trailing,
  });

  final String label;
  final T value;
  final bool selected;
  final bool enabled;
  final int? count;
  final IconData? icon;
  final Widget? trailing;

  UiFilterItem<T> copyWith({
    String? label,
    T? value,
    bool? selected,
    bool? enabled,
    int? count,
    IconData? icon,
    Widget? trailing,
  }) {
    return UiFilterItem<T>(
      label: label ?? this.label,
      value: value ?? this.value,
      selected: selected ?? this.selected,
      enabled: enabled ?? this.enabled,
      count: count ?? this.count,
      icon: icon ?? this.icon,
      trailing: trailing ?? this.trailing,
    );
  }
}
