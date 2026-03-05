import 'package:flutter/material.dart';

import 'lumos_button.dart';

class LumosSecondaryButton extends StatelessWidget {
  const LumosSecondaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.size = LumosButtonConst.defaultSize,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final LumosButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return LumosButton(
      label: label,
      onPressed: onPressed,
      type: LumosButtonType.secondary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      expanded: expanded,
    );
  }
}
