import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';

class LumosNumberField extends StatelessWidget {
  const LumosNumberField({
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
    this.allowDecimal = true,
    this.allowSigned = false,
    this.onChanged,
    this.onNumberChanged,
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
  final bool allowDecimal;
  final bool allowSigned;
  final ValueChanged<String>? onChanged;
  final ValueChanged<double?>? onNumberChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

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
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.numberWithOptions(
        decimal: allowDecimal,
        signed: allowSigned,
      ),
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.allow(_allowedPattern())],
      onChanged: (value) {
        onChanged?.call(value);
        onNumberChanged?.call(double.tryParse(value));
      },
      validator: validator,
      autovalidateMode: autovalidateMode,
    );
  }

  RegExp _allowedPattern() {
    if (allowDecimal && allowSigned) {
      return RegExp(r'[\d\.\-]');
    }
    if (allowDecimal) {
      return RegExp(r'[\d\.]');
    }
    if (allowSigned) {
      return RegExp(r'[\d\-]');
    }
    return RegExp(r'\d');
  }
}
