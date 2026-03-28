import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/composites/navigation/lumos_page_header.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/layouts/lumos_split_view_layout.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

class LumosDetailPageLayout extends StatelessWidget {
  const LumosDetailPageLayout({
    super.key,
    this.title,
    this.subtitle,
    this.breadcrumb,
    this.header,
    this.actions = const [],
    required this.body,
    this.sidePanel,
    this.footer,
    this.floatingActionButton,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? breadcrumb;
  final Widget? header;
  final List<Widget> actions;
  final Widget body;
  final Widget? sidePanel;
  final Widget? footer;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final content = sidePanel == null
        ? body
        : LumosSplitViewLayout(primary: body, secondary: sidePanel!);

    return LumosScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              actions.isNotEmpty)
            LumosPageHeader(
              breadcrumb: breadcrumb,
              title: title,
              subtitle: subtitle,
              actions: actions,
            ),
          if (header != null) ...[
            const LumosSpacing(size: AppSpacingSize.lg),
            header!,
          ],
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              actions.isNotEmpty ||
              header != null)
            const LumosSpacing(size: AppSpacingSize.lg),
          Expanded(child: content),
        ],
      ),
      footer: footer,
      floatingActionButton: floatingActionButton,
    );
  }
}
