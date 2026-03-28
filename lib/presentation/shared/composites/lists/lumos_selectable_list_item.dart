import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_list_item.dart';
import 'package:lumos/presentation/shared/primitives/selections/lumos_checkbox.dart';

enum AppSelectionControlPlacement { leading, trailing }

class LumosSelectableListItem extends StatelessWidget {
  const LumosSelectableListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.onChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.controlPlacement = AppSelectionControlPlacement.leading,
    this.compact = false,
  });

  final Widget title;
  final Widget? subtitle;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final bool enabled;
  final AppSelectionControlPlacement controlPlacement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final control = LumosCheckbox(
      value: selected,
      onChanged: enabled ? (value) => onChanged?.call(value ?? false) : null,
    );

    return LumosListItem(
      title: title,
      subtitle: subtitle,
      leading: controlPlacement == AppSelectionControlPlacement.leading
          ? _composeLeading(context, control)
          : leading,
      trailing: controlPlacement == AppSelectionControlPlacement.trailing
          ? _composeTrailing(context, control)
          : trailing,
      selected: selected,
      compact: compact,
      onTap: enabled ? () => onChanged?.call(!selected) : null,
    );
  }

  Widget _composeLeading(BuildContext context, Widget control) {
    if (leading == null) {
      return control;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        control,
        SizedBox(width: context.spacing.xs),
        leading!,
      ],
    );
  }

  Widget _composeTrailing(BuildContext context, Widget control) {
    if (trailing == null) {
      return control;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        trailing!,
        SizedBox(width: context.spacing.xs),
        control,
      ],
    );
  }
}
