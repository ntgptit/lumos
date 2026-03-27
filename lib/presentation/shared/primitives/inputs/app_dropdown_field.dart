import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_form_field_label.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.supportingText,
    this.labelTrailing,
    this.isRequired = false,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
    this.autovalidateMode,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          AppFormFieldLabel(
            label: label!,
            supportingText: supportingText,
            trailing: labelTrailing,
            isRequired: isRequired,
          ),
          SizedBox(height: context.spacing.xs),
        ],
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.component.inputHeight),
          child: DropdownButtonFormField<T>(
            key: ValueKey<T?>(value),
            initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            validator: validator,
            autovalidateMode: autovalidateMode,
            isExpanded: true,
            icon: Icon(Icons.expand_more_rounded, size: context.iconSize.lg),
            decoration: InputDecoration(
              hintText: hintText,
              helperText: helperText,
              errorText: errorText,
              prefixIcon: prefixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
