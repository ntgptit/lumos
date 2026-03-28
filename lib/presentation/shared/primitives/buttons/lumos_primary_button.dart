import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';

class LumosPrimaryButton extends LumosButton {
  LumosPrimaryButton({
    super.key,
    String? text,
    String? label,
    super.onPressed,
    bool expand = false,
    bool expanded = false,
    super.isLoading,
    Widget? leading,
    super.trailing,
    super.style,
    IconData? icon,
    super.size,
  }) : super(
         text: text ?? label ?? '',
         leading: leading ?? _icon(icon),
         expand: expand || expanded,
       );

  static Widget? _icon(IconData? icon) {
    if (icon == null) {
      return null;
    }
    return Icon(icon);
  }
}
