import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../folder_content_support.dart';

class FolderCreateButton extends StatelessWidget {
  const FolderCreateButton({
    required this.l10n,
    required this.horizontalInset,
    required this.actions,
    required this.isMutating,
    required this.onOpenActionSheet,
    super.key,
  });

  final AppLocalizations l10n;
  final double horizontalInset;
  final List<FolderContentSupportCreateAction> actions;
  final bool isMutating;
  final VoidCallback onOpenActionSheet;

  @override
  Widget build(BuildContext context) {
    if (isMutating) {
      return const SizedBox.shrink();
    }
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    final bool isSingleAction = actions.length == 1;
    final FolderContentSupportCreateAction singleAction = actions.first;
    final double bottomInset = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.xxl,
      minScale: ResponsiveDimensions.compactVerticalInsetScale,
    );
    return Positioned(
      right: horizontalInset,
      bottom: bottomInset,
      child: LumosFloatingActionButton(
        onPressed: () {
          if (isSingleAction) {
            singleAction.onPressed();
            return;
          }
          onOpenActionSheet();
        },
        icon: isSingleAction
            ? singleAction.icon
            : Icons.add_circle_outline_rounded,
        label: isSingleAction ? singleAction.label : l10n.commonCreate,
      ),
    );
  }
}
