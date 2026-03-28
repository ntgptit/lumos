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
    Widget? trailing,
    ButtonStyle? style,
    IconData? icon,
    LumosButtonSize size = LumosButtonSize.large,
  }) : super(
         text: text ?? label ?? '',
         leading: leading ?? _icon(icon),
         trailing: trailing,
         expand: expand || expanded,
         style: style,
         size: size,
       );

  static Widget? _icon(IconData? icon) {
    if (icon == null) {
      return null;
    }
    return Icon(icon);
  }
}
