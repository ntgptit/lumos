import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/layouts/lumos_split_view_layout.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_responsive_container.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

class LumosSessionLayout extends StatelessWidget {
  const LumosSessionLayout({
    super.key,
    this.header,
    required this.primaryContent,
    this.controls,
    this.sidePanel,
    this.footer,
  });

  final Widget? header;
  final Widget primaryContent;
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
        if (resolvedHeader != null) const LumosSpacing(size: AppSpacingSize.lg),
        LumosResponsiveContainer(
          maxWidth: context.layout.flashcardMaxWidth,
          child: primaryContent,
        ),
        if (controls != null) ...[
          const LumosSpacing(size: AppSpacingSize.lg),
          controls!,
        ],
      ],
    );

    return LumosScaffold(
      body: sidePanel == null
          ? centerContent
          : LumosSplitViewLayout(primary: centerContent, secondary: sidePanel!),
      footer: footer,
    );
  }
}
