import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.padding,
    this.indicatorPadding,
    this.tabAlignment,
    this.dividerHeight,
    this.dividerColor,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final ValueChanged<int>? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? indicatorPadding;
  final TabAlignment? tabAlignment;
  final double? dividerHeight;
  final Color? dividerColor;

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      onTap: onTap,
      padding: padding,
      indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
      tabAlignment: tabAlignment,
      dividerHeight: dividerHeight,
      dividerColor: dividerColor ?? context.colorScheme.outlineVariant,
      tabs: tabs,
    );
  }
}
