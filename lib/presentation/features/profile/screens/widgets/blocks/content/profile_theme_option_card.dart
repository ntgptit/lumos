import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/primitives/selections/lumos_radio.dart';

class ProfileThemeOptionCard extends StatelessWidget {
  const ProfileThemeOptionCard({
    required this.label,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      onTap: onPressed,
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.outlined,
      isSelected: selected,
      minHeight: context.component.buttonHeight,
      child: Row(
        children: <Widget>[
          ExcludeFocus(
            child: IgnorePointer(
              child: LumosRadio<bool>(
                value: true,
                groupValue: selected,
                onChanged: (_) {},
              ),
            ),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: LumosText(
              label,
              style: LumosTextStyle.bodyMedium,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
