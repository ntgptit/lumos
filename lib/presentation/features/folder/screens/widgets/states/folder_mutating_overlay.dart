import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';

class FolderMutatingOverlay extends StatelessWidget {
  const FolderMutatingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final double overlayWidth = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.canvas * 2,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double overlayPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double skeletonSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.page,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double labelGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return Center(
      child: Container(
        width: overlayWidth,
        padding: EdgeInsets.all(overlayPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadii.large,
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LumosSkeletonBox(
              width: skeletonSize,
              height: skeletonSize,
              borderRadius: BorderRadii.large,
            ),
            SizedBox(height: labelGap),
            LumosSkeletonBox(height: labelGap),
          ],
        ),
      ),
    );
  }
}

