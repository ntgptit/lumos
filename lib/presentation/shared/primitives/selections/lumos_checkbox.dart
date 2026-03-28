import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class LumosCheckbox extends StatelessWidget {
  const LumosCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.enabled = true,
    this.autofocus = false,
    this.semanticLabel,
    this.side,
    this.shape,
    this.materialTapTargetSize,
    this.visualDensity,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final bool enabled;
  final bool autofocus;
  final String? semanticLabel;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      tristate: tristate,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      side: side,
      shape: shape,
      materialTapTargetSize:
          materialTapTargetSize ?? MaterialTapTargetSize.padded,
      visualDensity: visualDensity ?? VisualDensity.standard,
      activeColor: context.colorScheme.primary,
      checkColor: context.colorScheme.onPrimary,
    );
  }
}
