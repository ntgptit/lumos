import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_search_field.dart';

class LumosSearchBar extends StatelessWidget {
  const LumosSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.autoFocus = false,
    this.hintText,
    this.hint,
    this.label,
    this.supportingText,
    this.onChanged,
    this.onSearch,
    this.onSubmitted,
    this.onClear,
    this.clearTooltip,
    this.onFilterPressed,
    this.onSortPressed,
    this.actions = const [],
    this.spacing,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool autoFocus;
  final String? hintText;
  final String? hint;
  final String? label;
  final String? supportingText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? clearTooltip;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSortPressed;
  final List<Widget> actions;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final actionWidgets = <Widget>[
      if (onFilterPressed != null)
        LumosIconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: context.l10n.filterTooltip,
          onPressed: onFilterPressed,
        ),
      if (onSortPressed != null)
        LumosIconButton(
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
          child: LumosSearchField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus || autoFocus,
            hintText: hintText ?? hint,
            label: label,
            supportingText: supportingText,
            onChanged: onChanged ?? onSearch,
            onSubmitted: onSubmitted,
            onClear: onClear,
            clearTooltip: clearTooltip,
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
