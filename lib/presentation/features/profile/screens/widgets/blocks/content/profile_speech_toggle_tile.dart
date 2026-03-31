import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/primitives/selections/lumos_switch.dart';

class ProfileSpeechToggleTile extends StatelessWidget {
  const ProfileSpeechToggleTile({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: () => onChanged(!value),
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.outlined,
      minHeight: context.component.buttonHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: LumosText(
              label,
              style: LumosTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: context.spacing.sm),
          ExcludeFocus(
            child: IgnorePointer(
              child: LumosSwitch(value: value, onChanged: (_) {}),
            ),
          ),
        ],
      ),
    );
  }
}
