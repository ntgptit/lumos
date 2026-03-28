import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';

class LumosDangerButton extends LumosButton {
  LumosDangerButton({
    super.key,
    required super.text,
    super.onPressed,
    super.expand,
    super.isLoading,
    Widget? leading,
    super.trailing,
    super.style,
    IconData? icon,
    super.size,
  }) : super(
         leading: leading ?? _icon(icon),
         variant: AppButtonVariant.danger,
       );

  static Widget? _icon(IconData? icon) {
    if (icon == null) {
      return null;
    }
    return Icon(icon);
  }
}
