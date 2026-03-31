import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';

class LumosPrimaryButton extends LumosButton {
  LumosPrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.expand,
    super.isLoading,
    Widget? leading,
    super.trailing,
    IconData? icon,
    super.size,
  }) : super(leading: leading ?? _icon(icon));

  static Widget? _icon(IconData? icon) {
    if (icon == null) {
      return null;
    }
    return Icon(icon);
  }
}
