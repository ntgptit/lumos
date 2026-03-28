import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
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
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(sheetContext.spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: sheetContext.textTheme.titleLarge),
                  if (subtitle != null) ...[
                    SizedBox(height: sheetContext.spacing.xs),
                    Text(subtitle, style: sheetContext.textTheme.bodyMedium),
                  ],
                  SizedBox(height: sheetContext.spacing.md),
                  Text(
                    optionSectionTitle,
                    style: sheetContext.textTheme.titleMedium,
                  ),
                  RadioGroup<T>(
                    groupValue: selectedValue,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    child: Column(
                      children: options
                          .map((option) {
                            return RadioListTile<T>(
                              value: option.value,
                              title: Text(option.label),
                              secondary: option.icon == null
                                  ? null
                                  : Icon(option.icon),
                            );
                          })
                          .toList(growable: false),
                    ),
                  ),
                  SizedBox(height: sheetContext.spacing.sm),
                  Text(
                    directionSectionTitle,
                    style: sheetContext.textTheme.titleMedium,
                  ),
                  RadioGroup<int>(
                    groupValue: selectedDirection,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        selectedDirection = value;
                      });
                    },
                    child: Column(
                      children: [
                        RadioListTile<int>(
                          value: 0,
                          title: Text(directionLabelBuilder(selectedValue, 0)),
                        ),
                        RadioListTile<int>(
                          value: 1,
                          title: Text(directionLabelBuilder(selectedValue, 1)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sheetContext.spacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        onApply(selectedValue, selectedDirection);
                      },
                      child: Text(applyLabel),
                    ),
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
