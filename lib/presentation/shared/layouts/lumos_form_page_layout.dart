import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_submit_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_section_list.dart';
import 'package:lumos/presentation/shared/composites/navigation/lumos_page_header.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';

class LumosFormPageLayout extends StatelessWidget {
  const LumosFormPageLayout({
    super.key,
    this.title,
    this.subtitle,
    this.breadcrumb,
    this.header,
    required this.sections,
    this.submitBar,
    this.floatingActionButton,
  });

  final Widget? title;
  final Widget? subtitle;
  final Widget? breadcrumb;
  final Widget? header;
  final List<Widget> sections;
  final LumosSubmitBar? submitBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return LumosScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || subtitle != null || breadcrumb != null)
            LumosPageHeader(
              breadcrumb: breadcrumb,
              title: title,
              subtitle: subtitle,
            ),
          if (header != null) ...[
            const LumosSpacing(size: AppSpacingSize.lg),
            header!,
          ],
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              header != null)
            const LumosSpacing(size: AppSpacingSize.lg),
          Expanded(child: LumosSectionList(sections: sections, scrollable: true)),
        ],
      ),
      footer: submitBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
