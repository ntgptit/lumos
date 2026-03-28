import 'package:flutter/material.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/l10n.dart';

abstract final class DeckListScreenConst {
  DeckListScreenConst._();

  static const double sectionSpacing = LumosSpacing.xl;
}

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: DeckListScreenConst.sectionSpacing,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return ColoredBox(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          child: LumosScreenFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: sectionSpacing),
                LumosSectionCard(
                  variant: LumosCardVariant.filled,
                  child: LumosEmptyState(
                    icon: Icons.folder_copy_outlined,
                    title: context.l10n.deckLibraryEntryTitle,
                    message: context.l10n.deckLibraryEntryMessage,
                    buttonLabel: context.l10n.deckLibraryEntryAction,
                    onButtonPressed: () {
                      const FoldersRouteData().go(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
