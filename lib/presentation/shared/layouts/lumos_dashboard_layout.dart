import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/layouts/lumos_split_view_layout.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

class LumosDashboardLayout extends StatelessWidget {
  const LumosDashboardLayout({
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
          const LumosSpacing(size: AppSpacingSize.lg),
        ?resolvedSummary,
        if (resolvedHeader != null || resolvedSummary != null)
          const LumosSpacing(size: AppSpacingSize.lg),
        content,
      ],
    );

    return LumosScaffold(
      body: sidebar == null
          ? mainContent
          : LumosSplitViewLayout(primary: mainContent, secondary: sidebar!),
      footer: footer,
      floatingActionButton: floatingActionButton,
    );
  }
}
