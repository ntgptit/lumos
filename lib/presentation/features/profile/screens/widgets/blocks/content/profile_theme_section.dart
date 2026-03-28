import 'package:flutter/material.dart';
import 'package:lumos/core/enums/app_theme_type.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';

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
              text: _quickToggleLabel(l10n: l10n, mode: themeMode),
              icon: Icons.brightness_6_outlined,
              expand: true,
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

