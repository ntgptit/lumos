import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_responsive_container.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.bottom,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.elevation,
    this.scrolledUnderElevation,
    this.backgroundColor,
    this.foregroundColor,
    this.surfaceTintColor,
    this.toolbarHeight,
    this.padding,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? surfaceTintColor;
  final double? toolbarHeight;
  final EdgeInsetsGeometry? padding;

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight((toolbarHeight ?? kToolbarHeight) + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title == null
        ? null
        : AppResponsiveContainer(
            constrainWidth: false,
            padding: padding ?? EdgeInsets.zero,
            child: _TitleColumn(
              title: title!,
              subtitle: subtitle,
              centerTitle: centerTitle,
            ),
          );

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: resolvedTitle,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      foregroundColor: foregroundColor ?? context.colorScheme.onSurface,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      toolbarHeight: toolbarHeight,
      bottom: bottom,
    );
  }
}

class _TitleColumn extends StatelessWidget {
  const _TitleColumn({
    required this.title,
    this.subtitle,
    this.centerTitle = false,
  });

  final Widget title;
  final Widget? subtitle;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    if (subtitle == null) {
      return Align(
        alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
        child: title,
      );
    }

    return Column(
      crossAxisAlignment: centerTitle
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title,
        SizedBox(height: context.spacing.xxs),
        subtitle!,
      ],
    );
  }
}
