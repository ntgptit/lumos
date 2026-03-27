import 'package:flutter/material.dart';

@immutable
class UiAction {
  const UiAction({
    required this.label,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.enabled = true,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;
  final bool destructive;

  bool get isEnabled => enabled && onPressed != null;

  UiAction copyWith({
    String? label,
    VoidCallback? onPressed,
    IconData? icon,
    String? tooltip,
    bool? enabled,
    bool? destructive,
  }) {
    return UiAction(
      label: label ?? this.label,
      onPressed: onPressed ?? this.onPressed,
      icon: icon ?? this.icon,
      tooltip: tooltip ?? this.tooltip,
      enabled: enabled ?? this.enabled,
      destructive: destructive ?? this.destructive,
    );
  }
}
