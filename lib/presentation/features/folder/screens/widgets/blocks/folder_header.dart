import 'package:flutter/material.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../domain/entities/folder_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderHeaderConst {
  const FolderHeaderConst._();

  static const double headerBannerPadding = Insets.spacing12;
  static const double headerBannerBorderWidth = WidgetSizes.borderWidthRegular;
  static const double headerIconBoxSize = Insets.spacing32;
  static const double headerIconSize = IconSizes.iconMedium;
  static const double headerTitleSpacing = Insets.spacing12;
  static const double headerSubtitleSpacing = Insets.spacing4;
  static const double sectionSpacing = Insets.spacing12;
}

class FolderHeader extends StatelessWidget {
  const FolderHeader({
    required this.breadcrumbItems,
    required this.currentParentId,
    required this.onOpenRoot,
    required this.onOpenBreadcrumb,
    super.key,
  });

  final List<BreadcrumbNode> breadcrumbItems;
  final int? currentParentId;
  final Future<void> Function() onOpenRoot;
  final Future<void> Function(int?) onOpenBreadcrumb;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeaderBanner(context: context, l10n: l10n),
          const SizedBox(height: FolderHeaderConst.sectionSpacing),
          LumosBreadcrumb<int>(
            rootLabel: l10n.folderRoot,
            items: breadcrumbItems
                .map(_toBreadcrumbItem)
                .toList(growable: false),
            currentValue: currentParentId,
            onSelected: (int? value) {
              if (value == null) {
                onOpenRoot();
                return;
              }
              onOpenBreadcrumb(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner({
    required BuildContext context,
    required AppLocalizations l10n,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FolderHeaderConst.headerBannerPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadii.large,
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: FolderHeaderConst.headerBannerBorderWidth,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: FolderHeaderConst.headerIconBoxSize,
            height: FolderHeaderConst.headerIconBoxSize,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadii.medium,
            ),
            child: Icon(
              Icons.folder_copy_rounded,
              size: FolderHeaderConst.headerIconSize,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: FolderHeaderConst.headerTitleSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  l10n.folderManagerTitle,
                  style: LumosTextStyle.headlineSmall,
                ),
                const SizedBox(height: FolderHeaderConst.headerSubtitleSpacing),
                LumosText(
                  l10n.folderManagerSubtitle,
                  style: LumosTextStyle.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LumosBreadcrumbItem<int> _toBreadcrumbItem(BreadcrumbNode node) {
    return LumosBreadcrumbItem<int>(
      label: node.name,
      value: node.id,
      icon: Icons.folder_open_rounded,
    );
  }
}
