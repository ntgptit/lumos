import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';

class LumosFloatingActionButton extends StatelessWidget {
  const LumosFloatingActionButton({
    required this.onPressed,
    super.key,
    this.icon = Icons.add,
    this.label,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon, size: IconSizes.iconMedium),
      );
    }
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(icon, size: IconSizes.iconMedium),
      label: Text(label!, overflow: TextOverflow.ellipsis),
    );
  }
}
