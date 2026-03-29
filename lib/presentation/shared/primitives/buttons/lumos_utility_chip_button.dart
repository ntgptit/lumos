import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/foundation/app_cursor.dart';

class LumosUtilityChipButton extends StatelessWidget {
  const LumosUtilityChipButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = onPressed != null;
    final ColorScheme colorScheme = context.colorScheme;
    final Color foregroundColor = isInteractive
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);
    final ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: context.shapes.control,
      side: BorderSide(color: colorScheme.outlineVariant),
    );

    return SizedBox(
      height: context.component.buttonHeight,
      child: Material(
        color: colorScheme.surfaceContainerHigh,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          mouseCursor: AppMouseCursors.resolve(isInteractive: isInteractive),
          borderRadius: context.shapes.control,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            child: IconTheme(
              data: IconThemeData(color: foregroundColor),
              child: DefaultTextStyle.merge(
                style: context.textTheme.labelLarge ?? const TextStyle(),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: foregroundColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        leading!,
                        SizedBox(width: context.spacing.xs),
                      ],
                      Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (trailing != null) ...<Widget>[
                        SizedBox(width: context.spacing.xs),
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
