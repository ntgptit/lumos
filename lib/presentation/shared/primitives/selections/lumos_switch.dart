import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosSwitch extends StatelessWidget {
  const LumosSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final bool autofocus;
  final DragStartBehavior dragStartBehavior;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      autofocus: autofocus,
      dragStartBehavior: dragStartBehavior,
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colorScheme.onPrimary;
        }
        return context.colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return context.colorScheme.primary;
        }
        return context.colorScheme.surfaceContainerHighest;
      }),
    );
  }
}
