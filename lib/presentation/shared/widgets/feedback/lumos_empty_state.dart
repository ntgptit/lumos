import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../typography/lumos_text.dart';

class LumosEmptyStateConst {
  const LumosEmptyStateConst._();

  static const IconData defaultIcon = Icons.inbox_rounded;
}

class LumosEmptyState extends StatelessWidget {
  const LumosEmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon = LumosEmptyStateConst.defaultIcon,
    this.buttonLabel,
    this.onButtonPressed,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: Insets.screenPadding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: WidgetSizes.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: IconSizes.iconXLarge,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: Insets.gapBetweenItems),
              LumosText(
                title,
                style: LumosTextStyle.titleLarge,
                align: TextAlign.center,
              ),
              ..._buildOptionalMessage(),
              ..._buildOptionalButton(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptionalMessage() {
    if (message == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing8),
      LumosText(
        message!,
        style: LumosTextStyle.bodyMedium,
        align: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ];
  }

  List<Widget> _buildOptionalButton() {
    if (buttonLabel == null) {
      return const <Widget>[];
    }
    if (onButtonPressed == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenSections),
      LumosButton(
        label: buttonLabel!,
        onPressed: onButtonPressed,
        expanded: true,
      ),
    ];
  }
}
