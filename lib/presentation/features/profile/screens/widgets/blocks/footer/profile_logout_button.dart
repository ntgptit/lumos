import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

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
    return LumosDangerButton(
      onPressed: onPressed,
      label: label,
      icon: Icons.logout_rounded,
      size: buttonSize,
    );
  }
}
