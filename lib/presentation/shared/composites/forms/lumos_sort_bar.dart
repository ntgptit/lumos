import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_surface.dart';

class LumosSortBar extends StatelessWidget {
  const LumosSortBar({
    super.key,
    required this.sortOptions,
    this.title,
    this.leading,
    this.trailing,
    this.directionToggle,
    this.padding,
    this.spacing,
    this.runSpacing,
    this.backgroundColor,
  });

  final List<Widget> sortOptions;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? directionToggle;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? runSpacing;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? context.spacing.sm;
    final lineGap = runSpacing ?? context.spacing.sm;
    final hasHeader =
        title != null ||
        leading != null ||
        trailing != null ||
        directionToggle != null;

    return LumosSurface(
      color: backgroundColor ?? context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: context.shapes.card),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasHeader) ...[
              Row(
                children: [
                  if (leading != null) ...[leading!, SizedBox(width: gap)],
                  if (title != null) Expanded(child: title!),
                  if (trailing != null) ...[SizedBox(width: gap), trailing!],
                  if (directionToggle != null) ...[
                    SizedBox(width: gap),
                    directionToggle!,
                  ],
                ],
              ),
              SizedBox(height: lineGap),
            ],
            Wrap(spacing: gap, runSpacing: lineGap, children: sortOptions),
          ],
        ),
      ),
    );
  }
}

Future<void> showLumosSortBottomSheet<T>({
  required BuildContext context,
  required String title,
  required String? subtitle,
  required String optionSectionTitle,
  required List<({T value, String label, IconData? icon})> options,
  required T initialValue,
  required String directionSectionTitle,
  required int initialDirectionIndex,
  required String Function(T selectedSortBy, int directionIndex)
  directionLabelBuilder,
  required String applyLabel,
  required void Function(T selectedSortBy, int directionIndex) onApply,
}) async {
  T selectedValue = initialValue;
  int selectedDirection = initialDirectionIndex;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return LumosBottomSheet(
            title: title,
            subtitle: subtitle,
            maxHeightFactor: 0.82,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSortSectionHeader(
                    context: sheetContext,
                    title: optionSectionTitle,
                  ),
                  SizedBox(height: sheetContext.spacing.xs),
                  ...options.map((option) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: sheetContext.spacing.xs),
                      child: _buildSortOptionTile(
                        context: sheetContext,
                        title: option.label,
                        icon: option.icon,
                        isSelected: option.value == selectedValue,
                        onTap: () {
                          setState(() {
                            selectedValue = option.value;
                          });
                        },
                      ),
                    );
                  }),
                  SizedBox(height: sheetContext.spacing.sm),
                  _buildSortSectionHeader(
                    context: sheetContext,
                    title: directionSectionTitle,
                  ),
                  SizedBox(height: sheetContext.spacing.xs),
                  Padding(
                    padding: EdgeInsets.only(bottom: sheetContext.spacing.xs),
                    child: _buildSortOptionTile(
                      context: sheetContext,
                      title: directionLabelBuilder(selectedValue, 0),
                      isSelected: selectedDirection == 0,
                      onTap: () {
                        setState(() {
                          selectedDirection = 0;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: sheetContext.spacing.md),
                    child: _buildSortOptionTile(
                      context: sheetContext,
                      title: directionLabelBuilder(selectedValue, 1),
                      isSelected: selectedDirection == 1,
                      onTap: () {
                        setState(() {
                          selectedDirection = 1;
                        });
                      },
                    ),
                  ),
                  LumosButton.primary(
                    text: applyLabel,
                    expand: true,
                    onPressed: () {
                      sheetContext.pop();
                      onApply(selectedValue, selectedDirection);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildSortSectionHeader({
  required BuildContext context,
  required String title,
}) {
  return LumosText(
    title,
    style: LumosTextStyle.labelLarge,
    tone: LumosTextTone.secondary,
    fontWeight: FontWeight.w700,
  );
}

Widget _buildSortOptionTile({
  required BuildContext context,
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
  IconData? icon,
}) {
  final ColorScheme colorScheme = context.colorScheme;
  final Color backgroundColor = isSelected
      ? colorScheme.secondaryContainer
      : colorScheme.surfaceContainerHighest;
  final Color foregroundColor = isSelected
      ? colorScheme.onSecondaryContainer
      : colorScheme.onSurface;
  final Color borderColor = isSelected
      ? colorScheme.secondary
      : colorScheme.outlineVariant;

  return LumosSurface(
    color: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: context.shapes.card,
      side: BorderSide(color: borderColor),
    ),
    clipBehavior: Clip.antiAlias,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: context.shapes.card,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: context.component.buttonHeight,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.md,
              vertical: context.spacing.sm,
            ),
            child: Row(
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(color: foregroundColor),
                  child: LumosIcon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: context.iconSize.md,
                  ),
                ),
                SizedBox(width: context.spacing.sm),
                Expanded(
                  child: LumosText(
                    title,
                    style: LumosTextStyle.bodyMedium,
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (icon != null) ...<Widget>[
                  SizedBox(width: context.spacing.sm),
                  IconTheme(
                    data: IconThemeData(color: foregroundColor),
                    child: LumosIcon(icon, size: context.iconSize.md),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
