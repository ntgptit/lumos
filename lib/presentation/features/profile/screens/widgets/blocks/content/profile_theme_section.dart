import 'package:flutter/material.dart';
import 'package:lumos/core/enums/app_theme_type.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'profile_section_card.dart';
import 'profile_theme_option_card.dart';

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
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double actionGap = context.compactValue(
      baseValue: context.spacing.sm,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ProfileSectionCard(
      title: l10n.profileThemeSectionTitle,
      subtitle: l10n.profileThemeSectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final AppThemeType preference
              in AppThemeType.values) ...<Widget>[
            ProfileThemeOptionCard(
              label: _themeLabel(l10n: l10n, preference: preference),
              selected: themeType == preference,
              onPressed: () => onPreferenceChanged(preference),
            ),
            if (preference != AppThemeType.values.last)
              SizedBox(height: sectionGap),
          ],
          SizedBox(height: actionGap),
          LumosButton.secondary(
            text: _quickToggleLabel(l10n: l10n, mode: themeMode),
            leading: const LumosIcon(Icons.brightness_6_outlined),
            expand: true,
            size: LumosButtonSize.medium,
            onPressed: onQuickTogglePressed,
          ),
        ],
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
