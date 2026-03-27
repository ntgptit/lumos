import 'package:flutter/material.dart';

@immutable
class UiMenuItem<T> {
  const UiMenuItem({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.enabled = true,
    this.destructive = false,
  });

  final String label;
  final T value;
  final String? subtitle;
  final IconData? icon;
  final bool enabled;
  final bool destructive;

  UiMenuItem<T> copyWith({
    String? label,
    T? value,
    String? subtitle,
    IconData? icon,
    bool? enabled,
    bool? destructive,
  }) {
    return UiMenuItem<T>(
      label: label ?? this.label,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      enabled: enabled ?? this.enabled,
      destructive: destructive ?? this.destructive,
    );
  }
}
