import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/layouts/app_split_view_layout.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_responsive_container.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';

class AppStudyLayout extends StatelessWidget {
  const AppStudyLayout({
    super.key,
    this.header,
    required this.flashcard,
    this.controls,
    this.sidePanel,
    this.footer,
  });

  final Widget? header;
  final Widget flashcard;
  final Widget? controls;
  final Widget? sidePanel;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final resolvedHeader = header;
    final centerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?resolvedHeader,
        if (resolvedHeader != null) const AppSpacing(size: AppSpacingSize.lg),
        AppResponsiveContainer(
          maxWidth: context.layout.flashcardMaxWidth,
          child: flashcard,
        ),
        if (controls != null) ...[
          const AppSpacing(size: AppSpacingSize.lg),
          controls!,
        ],
      ],
    );

    return AppScaffold(
      body: sidePanel == null
          ? centerContent
          : AppSplitViewLayout(primary: centerContent, secondary: sidePanel!),
      footer: footer,
    );
  }
}
