import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../buttons/lumos_primary_button.dart';
import '../misc/lumos_misc_widgets.dart';
import '../navigation/lumos_navigation_widgets.dart';
import '../typography/lumos_text.dart';
import 'lumos_dialog_widgets.dart';

abstract final class _LumosSortBottomSheetConst {
  _LumosSortBottomSheetConst._();

  static const EdgeInsetsGeometry contentPadding = EdgeInsets.only(
    top: AppSpacing.xs,
  );
  static const EdgeInsetsGeometry sectionPadding = EdgeInsets.all(
    AppSpacing.none,
  );
  static const EdgeInsetsGeometry sectionHeaderPadding = EdgeInsets.only(
    left: AppSpacing.xs,
    bottom: AppSpacing.sm,
  );
  static const EdgeInsetsGeometry optionPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );
  static const double sectionSpacing = AppSpacing.md;
  static const double subtitleSpacing = AppSpacing.xs;
  static const double buttonSpacing = AppSpacing.lg;
  static const double optionMinHeight = WidgetSizes.minTouchTarget;
  static const double optionIconSize = IconSizes.iconSmall;
  static const double optionIconContainerSize = WidgetSizes.avatarSmall;
  static const double optionCheckSize = IconSizes.iconSmall;
  static const double optionCheckContainerSize = WidgetSizes.avatarSmall;
}

Future<void> showLumosSortBottomSheet<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  required String optionSectionTitle,
  required List<({T value, String label, IconData? icon})> options,
  required T initialValue,
  required String directionSectionTitle,
  required int initialDirectionIndex,
  required String Function(T selectedValue, int directionIndex)
  directionLabelBuilder,
  required String applyLabel,
  required void Function(T selectedValue, int directionIndex) onApply,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colorScheme.surface.withValues(
      alpha: AppOpacity.transparent,
    ),
    builder: (BuildContext _) {
      return LumosSortBottomSheet<T>(
        title: title,
        subtitle: subtitle,
        optionSectionTitle: optionSectionTitle,
        options: options,
        initialValue: initialValue,
        directionSectionTitle: directionSectionTitle,
        initialDirectionIndex: initialDirectionIndex,
        directionLabelBuilder: directionLabelBuilder,
        applyLabel: applyLabel,
        onApply: onApply,
      );
    },
  );
}

class LumosSortBottomSheet<T> extends StatefulWidget {
  const LumosSortBottomSheet({
    required this.title,
    required this.optionSectionTitle,
    required this.options,
    required this.initialValue,
    required this.directionSectionTitle,
    required this.initialDirectionIndex,
    required this.directionLabelBuilder,
    required this.applyLabel,
    required this.onApply,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String optionSectionTitle;
  final List<({T value, String label, IconData? icon})> options;
  final T initialValue;
  final String directionSectionTitle;
  final int initialDirectionIndex;
  final String Function(T selectedValue, int directionIndex)
  directionLabelBuilder;
  final String applyLabel;
  final void Function(T selectedValue, int directionIndex) onApply;

  @override
  State<LumosSortBottomSheet<T>> createState() => _LumosSortBottomSheetState<T>();
}

class _LumosSortBottomSheetState<T> extends State<LumosSortBottomSheet<T>> {
  late final ValueNotifier<T> _selectedValueNotifier;
  late final ValueNotifier<int> _selectedDirectionIndexNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValueNotifier = ValueNotifier<T>(widget.initialValue);
    _selectedDirectionIndexNotifier = ValueNotifier<int>(
      widget.initialDirectionIndex,
    );
  }

  @override
  void dispose() {
    _selectedValueNotifier.dispose();
    _selectedDirectionIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LumosBottomSheet(
      child: ValueListenableBuilder<T>(
        valueListenable: _selectedValueNotifier,
        builder: (BuildContext context, T selectedValue, Widget? child) {
          return ValueListenableBuilder<int>(
            valueListenable: _selectedDirectionIndexNotifier,
            builder: (
              BuildContext context,
              int selectedDirectionIndex,
              Widget? child,
            ) {
              return SingleChildScrollView(
                child: Padding(
                  padding: _LumosSortBottomSheetConst.contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildHeader(context: context),
                      const SizedBox(
                        height: _LumosSortBottomSheetConst.sectionSpacing,
                      ),
                      _LumosSortSheetSection(
                        title: widget.optionSectionTitle,
                        child: _buildOptionList(
                          context: context,
                          selectedValue: selectedValue,
                        ),
                      ),
                      const SizedBox(
                        height: _LumosSortBottomSheetConst.sectionSpacing,
                      ),
                      _LumosSortSheetSection(
                        title: widget.directionSectionTitle,
                        child: LumosSegmentedControl(
                          options: <String>[
                            widget.directionLabelBuilder(selectedValue, 0),
                            widget.directionLabelBuilder(selectedValue, 1),
                          ],
                          selectedIndex: selectedDirectionIndex,
                          expandToAvailableWidth: true,
                          onChanged: (int nextIndex) {
                            _selectedDirectionIndexNotifier.value = nextIndex;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: _LumosSortBottomSheetConst.buttonSpacing,
                      ),
                      LumosPrimaryButton(
                        onPressed: _apply,
                        label: widget.applyLabel,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader({required BuildContext context}) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;
    final String? subtitle = widget.subtitle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(widget.title, style: LumosTextStyle.titleLarge),
        if (subtitle != null && subtitle.isNotEmpty) ...<Widget>[
          const SizedBox(
            height: _LumosSortBottomSheetConst.subtitleSpacing,
          ),
          LumosInlineText(
            subtitle,
            style: textTheme.bodyMedium.withResolvedColor(
              colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOptionList({
    required BuildContext context,
    required T selectedValue,
  }) {
    return ClipRRect(
      borderRadius: BorderRadii.large,
      child: Column(
        children: widget.options
            .asMap()
            .entries
            .expand((MapEntry<int, ({T value, String label, IconData? icon})> entry) sync* {
              if (entry.key > 0) {
                yield const Divider(
                  height: AppStroke.thin,
                  thickness: AppStroke.thin,
                );
              }
              final ({T value, String label, IconData? icon}) option =
                  entry.value;
              yield _LumosSortSheetOptionTile(
                label: option.label,
                icon: option.icon,
                isSelected: option.value == selectedValue,
                onTap: () {
                  _selectedValueNotifier.value = option.value;
                },
              );
            })
            .toList(growable: false),
      ),
    );
  }

  void _apply() {
    widget.onApply(
      _selectedValueNotifier.value,
      _selectedDirectionIndexNotifier.value,
    );
    context.pop();
  }
}

class _LumosSortSheetSection extends StatelessWidget {
  const _LumosSortSheetSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: _LumosSortBottomSheetConst.sectionHeaderPadding,
          child: LumosInlineText(
            title,
            style: textTheme.titleSmall.withResolvedColor(
              colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadii.large,
          ),
          child: Padding(
            padding: _LumosSortBottomSheetConst.sectionPadding,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _LumosSortSheetOptionTile extends StatelessWidget {
  const _LumosSortSheetOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;
    final ColorScheme colorScheme = context.colorScheme;
    final Color backgroundColor = isSelected
        ? colorScheme.secondaryContainer
        : colorScheme.surface.withValues(alpha: AppOpacity.transparent);
    final Color foregroundColor = isSelected
        ? colorScheme.onSecondaryContainer
        : colorScheme.onSurface;
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadii.large,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _LumosSortBottomSheetConst.optionMinHeight,
          ),
          child: Padding(
            padding: _LumosSortBottomSheetConst.optionPadding,
            child: Row(
              children: <Widget>[
                if (icon case final IconData leadingIcon) ...<Widget>[
                  _buildLeading(
                    colorScheme: colorScheme,
                    foregroundColor: foregroundColor,
                    icon: leadingIcon,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: LumosInlineText(
                    label,
                    style: textTheme.titleSmall.withResolvedColor(
                      foregroundColor,
                    ),
                  ),
                ),
                if (isSelected) ...<Widget>[
                  const SizedBox(width: AppSpacing.sm),
                  _buildTrailing(colorScheme: colorScheme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading({
    required ColorScheme colorScheme,
    required Color foregroundColor,
    required IconData icon,
  }) {
    final Color iconContainerColor = isSelected
        ? colorScheme.secondary.withValues(alpha: AppOpacity.stateHover)
        : colorScheme.surfaceContainerHigh;
    return Container(
      width: _LumosSortBottomSheetConst.optionIconContainerSize,
      height: _LumosSortBottomSheetConst.optionIconContainerSize,
      decoration: BoxDecoration(
        color: iconContainerColor,
        borderRadius: BorderRadii.medium,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: foregroundColor,
          size: _LumosSortBottomSheetConst.optionIconSize,
        ),
        child: LumosIcon(icon),
      ),
    );
  }

  Widget _buildTrailing({required ColorScheme colorScheme}) {
    return Container(
      width: _LumosSortBottomSheetConst.optionCheckContainerSize,
      height: _LumosSortBottomSheetConst.optionCheckContainerSize,
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadii.pill,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: colorScheme.onSecondary,
          size: _LumosSortBottomSheetConst.optionCheckSize,
        ),
        child: const LumosIcon(Icons.check_rounded),
      ),
    );
  }
}
