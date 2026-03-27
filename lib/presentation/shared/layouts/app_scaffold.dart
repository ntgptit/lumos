import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/composites/appbars/app_top_bar.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_responsive_container.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    this.appBar,
    required this.body,
    this.header,
    this.footer,
    this.actions,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.bodyPadding,
    this.maxBodyWidth,
    this.constrainBody = false,
    this.useSafeArea = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });

  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? header;
  final Widget? footer;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? bodyPadding;
  final double? maxBodyWidth;
  final bool constrainBody;
  final bool useSafeArea;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final resolvedAppBar =
        appBar ??
        (title == null
            ? null
            : AppTopBar(
                title: AppTitleText(text: title!),
                actions: actions ?? const [],
              ));
    final resolvedPadding =
        bodyPadding ??
        EdgeInsets.symmetric(
          horizontal: context.layout.pageHorizontalPadding,
          vertical: context.layout.pageVerticalPadding,
        );
    final content = AppResponsiveContainer(
      maxWidth: maxBodyWidth,
      constrainWidth: constrainBody || maxBodyWidth != null,
      padding: resolvedPadding,
      child: header == null && footer == null
          ? body
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?header,
                if (header != null) SizedBox(height: context.spacing.lg),
                Expanded(child: body),
                if (footer != null) ...[
                  SizedBox(height: context.spacing.lg),
                  footer!,
                ],
              ],
            ),
    );

    return Scaffold(
      appBar: resolvedAppBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      bottomSheet: bottomSheet,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: useSafeArea ? SafeArea(child: content) : content,
    );
  }
}
