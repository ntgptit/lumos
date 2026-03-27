import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/appbars/app_top_bar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/app_search_field.dart';

class AppSearchTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppSearchTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.controller,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.autofocus = false,
    this.searchField,
    this.searchPadding,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final bool autofocus;
  final Widget? searchField;
  final EdgeInsetsGeometry? searchPadding;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 72);

  @override
  Widget build(BuildContext context) {
    final field =
        searchField ??
        AppSearchField(
          controller: controller,
          focusNode: focusNode,
          hintText: hintText,
          enabled: enabled,
          autofocus: autofocus,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onClear: onClear,
        );

    return AppTopBar(
      title: title,
      subtitle: subtitle,
      leading: leading,
      actions: actions,
      toolbarHeight: kToolbarHeight,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Padding(
          padding:
              searchPadding ??
              EdgeInsets.fromLTRB(
                context.spacing.md,
                0,
                context.spacing.md,
                context.spacing.md,
              ),
          child: field,
        ),
      ),
    );
  }
}
