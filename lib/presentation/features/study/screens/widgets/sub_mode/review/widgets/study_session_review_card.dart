import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
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

class StudySessionReviewCard extends StatelessWidget {
  const StudySessionReviewCard({
    required this.content,
    required this.trailing,
    this.textStyle,
    super.key,
  });

  final String content;
  final Widget trailing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets cardPadding = ResponsiveDimensions.compactInsets(
          context: context,
          baseInsets: EdgeInsets.fromLTRB(
            constraints.maxHeight < 260 ? LumosSpacing.lg : LumosSpacing.xl,
            LumosSpacing.lg,
            constraints.maxHeight < 260 ? LumosSpacing.lg : LumosSpacing.xl,
            constraints.maxHeight < 260 ? LumosSpacing.lg : LumosSpacing.xl,
          ),
        );
        final double horizontalInset = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: constraints.maxWidth < 360 ? LumosSpacing.sm : LumosSpacing.md,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        return LumosCard(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(alignment: Alignment.topRight, child: trailing),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalInset,
                        ),
                        child: LumosInlineText(
                          content,
                          align: TextAlign.center,
                          style: textStyle?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

