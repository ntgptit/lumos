import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/layouts/app_split_view_layout.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';

class AppDashboardLayout extends StatelessWidget {
  const AppDashboardLayout({
    super.key,
    this.header,
    this.summary,
    required this.content,
    this.sidebar,
    this.footer,
    this.floatingActionButton,
  });

  final Widget? header;
  final Widget? summary;
  final Widget content;
  final Widget? sidebar;
  final Widget? footer;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final resolvedHeader = header;
    final resolvedSummary = summary;
    final mainContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?resolvedHeader,
        if (resolvedHeader != null && resolvedSummary != null)
          const AppSpacing(size: AppSpacingSize.lg),
        ?resolvedSummary,
        if (resolvedHeader != null || resolvedSummary != null)
          const AppSpacing(size: AppSpacingSize.lg),
        content,
      ],
    );

    return AppScaffold(
      body: sidebar == null
          ? mainContent
          : AppSplitViewLayout(primary: mainContent, secondary: sidebar!),
      footer: footer,
      floatingActionButton: floatingActionButton,
    );
  }
}
