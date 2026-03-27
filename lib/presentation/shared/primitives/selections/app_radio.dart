// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.enabled = true,
    this.toggleable = false,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.visualDensity,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final bool toggleable;
  final bool autofocus;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      toggleable: toggleable,
      autofocus: autofocus,
      materialTapTargetSize:
          materialTapTargetSize ?? MaterialTapTargetSize.padded,
      visualDensity: visualDensity ?? VisualDensity.standard,
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colorScheme.primary;
        }
        return context.colorScheme.onSurfaceVariant;
      }),
    );
  }
}
