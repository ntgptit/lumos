import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_form_field_label.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.supportingText,
    this.labelTrailing,
    this.isRequired = false,
    this.controller,
    this.focusNode,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.expands = false,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
  });

  final String? label;
  final String? supportingText;
  final Widget? labelTrailing;
  final bool isRequired;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool obscureText;
  final bool expands;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final isSingleLine =
        !expands &&
        (maxLines == null || maxLines == 1) &&
        (minLines == null || minLines == 1);
    final field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      minLines: expands ? null : minLines,
      maxLines: expands ? null : maxLines,
      expands: expands,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        counterText: '',
      ),
    );

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
        if (isSingleLine)
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.component.inputHeight,
            ),
            child: field,
          )
        else
          field,
      ],
    );
  }
}
