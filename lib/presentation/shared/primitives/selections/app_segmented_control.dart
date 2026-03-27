import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.enabled = true,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.showSelectedIcon = false,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;
  final bool enabled;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final bool showSelectedIcon;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: enabled ? onSelectionChanged : null,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      showSelectedIcon: showSelectedIcon,
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge),
        iconSize: WidgetStatePropertyAll(context.iconSize.md),
        minimumSize: WidgetStatePropertyAll(
          Size.fromHeight(context.component.buttonHeight),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radius.md),
          ),
        ),
      ),
    );
  }
}
