import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/foundation/app_cursor.dart';

enum LumosPopupMenuItemTone { standard, critical }

class LumosPopupMenuButton<T> extends StatelessWidget {
  const LumosPopupMenuButton({
    super.key,
    required this.itemBuilder,
    this.onSelected,
    this.tooltip,
    this.icon,
  });

  final PopupMenuItemBuilder<T> itemBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final String? tooltip;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final double anchorSize = context.component.buttonHeight;

    return MouseRegion(
      cursor: AppMouseCursors.clickable,
      child: PopupMenuButton<T>(
        padding: EdgeInsets.zero,
        splashRadius: anchorSize / 2,
        constraints: BoxConstraints.tightFor(
          width: anchorSize,
          height: anchorSize,
        ),
        borderRadius: context.shapes.control,
        itemBuilder: itemBuilder,
        onSelected: onSelected,
        tooltip: tooltip,
        icon: icon ?? Icon(Icons.more_vert_rounded, size: context.iconSize.md),
      ),
    );
  }
}

class LumosPopupMenuActionItem<T> extends PopupMenuItem<T> {
  LumosPopupMenuActionItem({
    super.key,
    required super.value,
    required String label,
    required IconData icon,
    String? supportingText,
    LumosPopupMenuItemTone tone = LumosPopupMenuItemTone.standard,
  }) : super(
         padding: EdgeInsets.zero,
         child: _LumosPopupMenuActionContent(
           label: label,
           icon: icon,
           supportingText: supportingText,
           tone: tone,
         ),
       );
}

class _LumosPopupMenuActionContent extends StatelessWidget {
  const _LumosPopupMenuActionContent({
    required this.label,
    required this.icon,
    required this.supportingText,
    required this.tone,
  });

  final String label;
  final IconData icon;
  final String? supportingText;
  final LumosPopupMenuItemTone tone;

  @override
  Widget build(BuildContext context) {
    final bool isCritical = tone == LumosPopupMenuItemTone.critical;
    final Color foregroundColor = isCritical
        ? context.colorScheme.error
        : context.colorScheme.onSurface;
    final Color supportingColor = isCritical
        ? context.colorScheme.error.withValues(alpha: 0.78)
        : context.colorScheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.sm,
      ),
      child: IconTheme(
        data: IconThemeData(color: foregroundColor, size: context.iconSize.sm),
        child: Row(
          children: <Widget>[
            Icon(icon),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle.merge(
                    style: context.textTheme.labelLarge ?? const TextStyle(),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(color: foregroundColor),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (supportingText != null) ...<Widget>[
                    SizedBox(height: context.spacing.xxs),
                    DefaultTextStyle.merge(
                      style: context.textTheme.bodySmall ?? const TextStyle(),
                      child: DefaultTextStyle.merge(
                        style: TextStyle(color: supportingColor),
                        child: Text(
                          supportingText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
