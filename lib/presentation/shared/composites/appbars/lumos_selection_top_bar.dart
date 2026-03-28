import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_top_bar.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosSelectionTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const LumosSelectionTopBar({
    super.key,
    required this.selectedCount,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.onClearSelection,
    this.selectedCountLabelBuilder,
  });

  final int selectedCount;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final VoidCallback? onClearSelection;
  final String Function(int selectedCount)? selectedCountLabelBuilder;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final resolvedTitle =
        title ??
        LumosTitleText(
          text: _labelFor(context, selectedCount),
          style: context.textTheme.titleMedium,
        );
    return LumosTopBar(
      leading:
          leading ??
          (onClearSelection == null
              ? null
              : LumosIconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: context.l10n.clearSelectionTooltip,
                  onPressed: onClearSelection,
                )),
      title: resolvedTitle,
      subtitle: subtitle,
      actions: actions,
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
    );
  }

  String _labelFor(BuildContext context, int count) {
    return selectedCountLabelBuilder?.call(count) ??
        context.l10n.selectionCountLabel(count);
  }
}
