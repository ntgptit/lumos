import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_form_field_label.dart';

class LumosSliderInput extends StatelessWidget {
  const LumosSliderInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    this.supportingText,
    this.labelTrailing,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.valueFormatter,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final String Function(double value)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          LumosFormFieldLabel(
            label: label!,
            supportingText: supportingText,
            trailing:
                labelTrailing ??
                Text(
                  _displayValue(safeValue),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            isRequired: isRequired,
          ),
        Slider(
          value: safeValue,
          min: min,
          max: max,
          divisions: divisions,
          label: _displayValue(safeValue),
          onChanged: enabled ? onChanged : null,
        ),
        if (helperText != null || errorText != null)
          Padding(
            padding: EdgeInsets.only(
              left: context.spacing.md,
              right: context.spacing.md,
            ),
            child: Text(
              errorText ?? helperText!,
              style: context.textTheme.bodySmall?.copyWith(
                color: errorText != null
                    ? context.colorScheme.error
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  String _displayValue(double value) {
    return valueFormatter?.call(value) ??
        (divisions == null
            ? value.toStringAsFixed(1)
            : value.round().toString());
  }
}
