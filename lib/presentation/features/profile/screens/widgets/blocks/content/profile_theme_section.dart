import 'package:flutter/material.dart';
import 'package:lumos/core/enums/app_theme_type.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
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

class ProfileThemeSection extends StatelessWidget {
  const ProfileThemeSection({
    required this.themeType,
    required this.themeMode,
    required this.onPreferenceChanged,
    required this.onQuickTogglePressed,
    super.key,
  });

  final AppThemeType themeType;
  final ThemeMode themeMode;
  final ValueChanged<AppThemeType> onPreferenceChanged;
  final VoidCallback onQuickTogglePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileThemeSectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: LumosSpacing.sm),
            LumosText(
              l10n.profileThemeSectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            SizedBox(height: sectionGap),
            LumosRadioGroup<AppThemeType>(
              options: AppThemeType.values,
              value: themeType,
              onChanged: (AppThemeType? value) {
                if (value == null) {
                  return;
                }
                onPreferenceChanged(value);
              },
              labelBuilder: (AppThemeType preference) {
                return _themeLabel(l10n: l10n, preference: preference);
              },
            ),
            SizedBox(height: actionGap),
            LumosOutlineButton(
              label: _quickToggleLabel(l10n: l10n, mode: themeMode),
              icon: Icons.brightness_6_outlined,
              expanded: true,
              onPressed: onQuickTogglePressed,
            ),
          ],
        ),
      ),
    );
  }
}

String _themeLabel({
  required AppLocalizations l10n,
  required AppThemeType preference,
}) {
  return switch (preference) {
    AppThemeType.system => l10n.profileThemeSystem,
    AppThemeType.light => l10n.profileThemeLight,
    AppThemeType.dark => l10n.profileThemeDark,
  };
}

String _quickToggleLabel({
  required AppLocalizations l10n,
  required ThemeMode mode,
}) {
  return switch (mode) {
    ThemeMode.dark => l10n.profileThemeToggleToLight,
    _ => l10n.profileThemeToggleToDark,
  };
}

