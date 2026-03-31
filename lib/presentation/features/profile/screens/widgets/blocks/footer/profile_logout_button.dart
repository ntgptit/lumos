import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final LumosButtonSize buttonSize = context.deviceType == DeviceType.mobile
        ? LumosButtonSize.medium
        : LumosButtonSize.large;
    return LumosButton.outline(
      onPressed: onPressed,
      text: label,
      leading: const LumosIcon(Icons.logout_rounded),
      expand: true,
      size: buttonSize,
    );
  }
}
