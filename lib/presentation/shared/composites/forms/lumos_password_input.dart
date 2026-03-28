import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_password_field.dart';

class LumosPasswordInput extends StatelessWidget {
  const LumosPasswordInput({
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
    this.enabled = true,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autovalidateMode,
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
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return LumosPasswordField(
      label: label,
      supportingText: supportingText,
      labelTrailing: labelTrailing,
      isRequired: isRequired,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }
}
