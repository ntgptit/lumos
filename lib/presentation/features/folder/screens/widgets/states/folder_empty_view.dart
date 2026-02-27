import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class FolderEmptyView extends StatelessWidget {
  const FolderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosEmptyState(
      title: l10n.folderEmptyTitle,
      message: l10n.folderEmptySubtitle,
      icon: Icons.folder_copy_outlined,
    );
  }
}
