import 'package:flutter/material.dart';

import '../../../../../../../core/providers/theme_provider.dart';
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
  final ValueChanged<AppThemePreference> onPreferenceChanged;
  final VoidCallback onQuickTogglePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AppThemePreference selectedPreference = _themePreferenceFromMode(
      mode: themeMode,
    );
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
            LumosRadioGroup<AppThemePreference>(
              options: AppThemePreference.values,
              value: selectedPreference,
              onChanged: (AppThemePreference? value) {
                if (value == null) {
                  return;
                }
                onPreferenceChanged(value);
              },
              labelBuilder: (AppThemePreference preference) {
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

AppThemePreference _themePreferenceFromMode({required ThemeMode mode}) {
  return switch (mode) {
    ThemeMode.light => AppThemePreference.light,
    ThemeMode.dark => AppThemePreference.dark,
    _ => AppThemePreference.system,
  };
}

String _themeLabel({
  required AppLocalizations l10n,
  required AppThemePreference preference,
}) {
  return switch (preference) {
    AppThemePreference.system => l10n.profileThemeSystem,
    AppThemePreference.light => l10n.profileThemeLight,
    AppThemePreference.dark => l10n.profileThemeDark,
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
