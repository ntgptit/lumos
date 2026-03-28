import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosTextInput extends StatelessWidget {
  const LumosTextInput({
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
    return LumosTextField(
      label: label,
      supportingText: supportingText,
      labelTrailing: labelTrailing,
      isRequired: isRequired,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onTap: onTap,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
    );
  }
}
