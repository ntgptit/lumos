import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/app_section_list.dart';
import 'package:lumos/presentation/shared/composites/navigation/app_page_header.dart';
import 'package:lumos/presentation/shared/layouts/app_scaffold.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';

class AppFormPageLayout extends StatelessWidget {
  const AppFormPageLayout({
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
  final AppSubmitBar? submitBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || subtitle != null || breadcrumb != null)
            AppPageHeader(
              breadcrumb: breadcrumb,
              title: title,
              subtitle: subtitle,
            ),
          if (header != null) ...[
            const AppSpacing(size: AppSpacingSize.lg),
            header!,
          ],
          if (title != null ||
              subtitle != null ||
              breadcrumb != null ||
              header != null)
            const AppSpacing(size: AppSpacingSize.lg),
          Expanded(child: AppSectionList(sections: sections, scrollable: true)),
        ],
      ),
      footer: submitBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
