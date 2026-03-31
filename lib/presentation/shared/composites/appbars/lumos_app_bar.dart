import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/core/theme/tokens/layout/size_tokens.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_top_bar.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

abstract final class LumosAppBarConst {
  static const double expandedToolbarHeight =
      AppSizeTokens.expandedToolbarHeight;
}

class LumosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LumosAppBar({
    super.key,
    this.title,
    this.eyebrow,
    this.subtitle,
    this.actions = const [],
    this.leading,
    this.centerTitle = false,
    this.wrapActions = true,
    this.titleLeading,
    this.titleLeadingSize,
    this.titleTrailing,
  });

  final String? title;
  final String? eyebrow;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;
  final bool centerTitle;
  final bool wrapActions;
  final Widget? titleLeading;
  final double? titleLeadingSize;
  final Widget? titleTrailing;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final titleWidget = _buildTitle(context);
    return LumosTopBar(
      title: titleWidget,
      subtitle: subtitle == null ? null : LumosInlineText(subtitle!),
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (title == null &&
        eyebrow == null &&
        titleLeading == null &&
        titleTrailing == null) {
      return null;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleLeading != null) ...[
          SizedBox.square(
            dimension: titleLeadingSize,
            child: FittedBox(child: titleLeading!),
          ),
          SizedBox(width: context.spacing.sm),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (eyebrow != null)
                LumosInlineText(eyebrow!, style: context.textTheme.labelSmall),
              if (title != null)
                LumosText(title!, style: LumosTextStyle.titleLarge),
            ],
          ),
        ),
        if (titleTrailing != null) ...[
          SizedBox(width: context.spacing.sm),
          titleTrailing!,
        ],
      ],
    );
  }
}
