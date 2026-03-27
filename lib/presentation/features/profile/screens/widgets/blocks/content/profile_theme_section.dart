import 'package:flutter/material.dart';

import '../../../../../../../core/theme/app_theme_mode.dart';
import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

class ProfileThemeSection extends StatelessWidget {
  const ProfileThemeSection({
    required this.themeMode,
    required this.onPreferenceChanged,
    required this.onQuickTogglePressed,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<AppThemeModeOption> onPreferenceChanged;
  final VoidCallback onQuickTogglePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppThemeModeOption selectedPreference =
        AppThemeModeOption.fromThemeMode(themeMode);
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.sm,
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
            const SizedBox(height: AppSpacing.sm),
            LumosText(
              l10n.profileThemeSectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            SizedBox(height: sectionGap),
            LumosRadioGroup<AppThemeModeOption>(
              options: AppThemeModeOption.values,
              value: selectedPreference,
              onChanged: (AppThemeModeOption? value) {
                if (value == null) {
                  return;
                }
                onPreferenceChanged(value);
              },
              labelBuilder: (AppThemeModeOption preference) {
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
  required AppThemeModeOption preference,
}) {
  return switch (preference) {
    AppThemeModeOption.system => l10n.profileThemeSystem,
    AppThemeModeOption.light => l10n.profileThemeLight,
    AppThemeModeOption.dark => l10n.profileThemeDark,
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
