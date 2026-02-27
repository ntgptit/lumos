import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/themes/constants/dimensions.dart';
import '../../../../../../core/themes/providers/theme_provider.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class HomeProfileTabConst {
  const HomeProfileTabConst._();

  static const double maxWidth = 560;
}

class HomeProfileTab extends ConsumerWidget {
  const HomeProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeMode themeMode = ref.watch(appThemeModeProvider);
    final AppThemePreference selectedPreference = _toPreference(
      mode: themeMode,
    );
    final Widget content = _buildContent(
      ref: ref,
      l10n: l10n,
      themeMode: themeMode,
      selectedPreference: selectedPreference,
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: HomeProfileTabConst.maxWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.spacing16),
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
    required AppThemePreference selectedPreference,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildThemeCard(
          ref: ref,
          l10n: l10n,
          themeMode: themeMode,
          selectedPreference: selectedPreference,
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
    required AppThemePreference selectedPreference,
  }) {
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(Insets.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileThemeSectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: Insets.spacing8),
            LumosText(
              l10n.profileThemeSectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: Insets.spacing16),
            _buildThemePreferenceSelector(
              ref: ref,
              l10n: l10n,
              selectedPreference: selectedPreference,
            ),
            const SizedBox(height: Insets.spacing8),
            _buildQuickToggleButton(ref: ref, l10n: l10n, themeMode: themeMode),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreferenceSelector({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AppThemePreference selectedPreference,
  }) {
    return LumosRadioGroup<AppThemePreference>(
      options: AppThemePreference.values,
      value: selectedPreference,
      onChanged: (AppThemePreference? value) {
        if (value == null) {
          return;
        }
        ref.read(appThemeModeProvider.notifier).setPreference(value);
      },
      labelBuilder: (AppThemePreference preference) {
        return _themeLabel(l10n: l10n, preference: preference);
      },
    );
  }

  Widget _buildQuickToggleButton({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
  }) {
    return LumosButton(
      label: _quickToggleLabel(l10n: l10n, mode: themeMode),
      icon: Icons.brightness_6_outlined,
      type: LumosButtonType.outline,
      expanded: true,
      onPressed: () {
        ref.read(appThemeModeProvider.notifier).toggleTheme();
      },
    );
  }

  AppThemePreference _toPreference({required ThemeMode mode}) {
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
}
