import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/composites/navigation/app_page_header.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';

class AppListPageLayout extends StatelessWidget {
  const AppListPageLayout({
    super.key,
    this.title,
    this.subtitle,
    this.breadcrumb,
    this.header,
    this.filters,
    this.actions = const [],
    required this.body,
    this.emptyState,
    this.bottomBar,
    this.floatingActionButton,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? breadcrumb;
  final Widget? header;
  final Widget? filters;
  final List<Widget> actions;
  final Widget body;
  final Widget? emptyState;
  final Widget? bottomBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              actions.isNotEmpty)
            AppPageHeader(
              breadcrumb: breadcrumb,
              title: title,
              subtitle: subtitle,
              actions: actions,
            ),
          if (header != null) ...[
            const AppSpacing(size: AppSpacingSize.lg),
            header!,
          ],
          if (filters != null) ...[
            const AppSpacing(size: AppSpacingSize.lg),
            filters!,
          ],
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              actions.isNotEmpty ||
              header != null ||
              filters != null)
            const AppSpacing(size: AppSpacingSize.lg),
          Expanded(child: emptyState ?? body),
        ],
      ),
      footer: bottomBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
