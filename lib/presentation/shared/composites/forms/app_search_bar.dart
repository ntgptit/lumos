import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_search_field.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.label,
    this.supportingText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilterPressed,
    this.onSortPressed,
    this.actions = const [],
    this.spacing,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? label;
  final String? supportingText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSortPressed;
  final List<Widget> actions;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final actionWidgets = <Widget>[
      if (onFilterPressed != null)
        AppIconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: context.l10n.filterTooltip,
          onPressed: onFilterPressed,
        ),
      if (onSortPressed != null)
        AppIconButton(
          icon: const Icon(Icons.swap_vert_rounded),
          tooltip: context.l10n.sortTooltip,
          onPressed: onSortPressed,
        ),
      ...actions,
    ];

    final gap = spacing ?? context.spacing.sm;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppSearchField(
            controller: controller,
            focusNode: focusNode,
            hintText: hintText,
            label: label,
            supportingText: supportingText,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            onClear: onClear,
          ),
        ),
        if (actionWidgets.isNotEmpty) ...[
          SizedBox(width: gap),
          Wrap(
            spacing: gap,
            runSpacing: gap,
            alignment: WrapAlignment.end,
            children: actionWidgets,
          ),
        ],
      ],
    );
  }
}
