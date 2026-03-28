import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_form_field_label.dart';

class LumosScoreInput extends StatelessWidget {
  const LumosScoreInput({
    super.key,
    this.score,
    this.onChanged,
    this.minScore = 1,
    this.maxScore = 5,
    this.label,
    this.supportingText,
    this.labelTrailing,
    this.isRequired = false,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.allowClear = false,
    this.scoreLabelBuilder,
  });

  final int? score;
  final ValueChanged<int?>? onChanged;
  final int minScore;
  final int maxScore;
  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final bool allowClear;
  final String Function(int score)? scoreLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    for (var value = minScore; value <= maxScore; value++) {
      final selected = value == score;
      chips.add(
        ChoiceChip(
          label: Text(_labelFor(value)),
          selected: selected,
          onSelected: enabled
              ? (isSelected) {
                  if (isSelected) {
                    onChanged?.call(value);
                    return;
                  }
                  if (allowClear) {
                    onChanged?.call(null);
                  }
                }
              : null,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          LumosFormFieldLabel(
            label: label!,
            supportingText: supportingText,
            trailing: labelTrailing,
            isRequired: isRequired,
          ),
          SizedBox(height: context.spacing.sm),
        ],
        Wrap(
          spacing: context.spacing.sm,
          runSpacing: context.spacing.sm,
          children: chips,
        ),
        if (helperText != null || errorText != null) ...[
          SizedBox(height: context.spacing.xs),
          Text(
            errorText ?? helperText!,
            style: context.textTheme.bodySmall?.copyWith(
              color: errorText != null
                  ? context.colorScheme.error
                  : context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  String _labelFor(int value) {
    return scoreLabelBuilder?.call(value) ?? value.toString();
  }
}
