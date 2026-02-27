import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../constants/home_contract.dart';
import 'widgets/blocks/home_sections_block.dart';

class HomeContentConst {
  const HomeContentConst._();

  static const double heroMinHeightMobile = 280;
  static const double heroMinHeightLarge = 250;
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final DeviceType deviceType = context.deviceType;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double horizontalPadding = ResponsiveDimensions.adaptive(
      context: context,
      baseValue: Insets.paddingScreen,
    );
    return Stack(
      children: <Widget>[
        const HomeBackground(),
        SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: WidgetSizes.maxContentWidth,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: Insets.gapBetweenSections,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildAnimatedReveal(
                      order: 0,
                      child: HomeHeaderBlock(l10n: l10n),
                    ),
                    const SizedBox(height: Insets.gapBetweenSections),
                    _buildAnimatedReveal(
                      order: 1,
                      child: HomeHeroCard(deviceType: deviceType, l10n: l10n),
                    ),
                    const SizedBox(height: Insets.gapBetweenSections),
                    _buildAnimatedReveal(order: 2, child: const HomeStatGrid()),
                    const SizedBox(height: Insets.gapBetweenSections),
                    _buildAnimatedReveal(
                      order: 3,
                      child: HomeSplitSection(deviceType: deviceType),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedReveal({required int order, required Widget child}) {
    final int durationMs = 420 + (order * 120);
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: durationMs),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (BuildContext context, double value, Widget? animatedChild) {
        final double dy = Insets.spacing16 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(Insets.spacing0, dy),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colorScheme.surface,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -Insets.spacing64,
              right: -Insets.spacing64,
              child: HomeGlowBlob(
                color: colorScheme.primary.withValues(
                  alpha: WidgetOpacities.elevationLevel5,
                ),
                size: Insets.spacing64 * 3,
              ),
            ),
            Positioned(
              left: -Insets.spacing48,
              top: Insets.spacing64 * 2,
              child: HomeGlowBlob(
                color: colorScheme.tertiary.withValues(
                  alpha: WidgetOpacities.elevationLevel3,
                ),
                size: Insets.spacing64 * 2.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeGlowBlob extends StatelessWidget {
  const HomeGlowBlob({required this.color, required this.size, super.key});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class HomeHeaderBlock extends StatelessWidget {
  const HomeHeaderBlock({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LumosText(
                l10n.homeGreeting,
                style: LumosTextStyle.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Insets.spacing4),
              LumosText(
                l10n.homeGoalProgress,
                style: LumosTextStyle.bodyMedium,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Insets.spacing4),
          decoration: BoxDecoration(
            borderRadius: BorderRadii.large,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: CircleAvatar(
            radius: Insets.spacing16,
            backgroundColor: colorScheme.secondaryContainer,
            child: const Text('L'),
          ),
        ),
      ],
    );
  }
}

class HomeHeroCard extends StatelessWidget {
  const HomeHeroCard({required this.deviceType, required this.l10n, super.key});

  final DeviceType deviceType;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isMobile = deviceType == DeviceType.mobile;
    return Semantics(
      label: HomeScreenSemantics.heroCard,
      container: true,
      excludeSemantics: true,
      child: _buildContainer(colorScheme: colorScheme, isMobile: isMobile),
    );
  }

  Widget _buildContainer({
    required ColorScheme colorScheme,
    required bool isMobile,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isMobile
            ? HomeContentConst.heroMinHeightMobile
            : HomeContentConst.heroMinHeightLarge,
      ),
      decoration: _buildDecoration(colorScheme: colorScheme),
      child: ClipRRect(
        borderRadius: BorderRadii.large,
        child: Padding(
          padding: const EdgeInsets.all(Insets.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeroBadge(colorScheme: colorScheme),
              const SizedBox(height: Insets.spacing16),
              LumosText(
                l10n.homeHeroTitle,
                style: LumosTextStyle.headlineMedium,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(height: Insets.spacing8),
              LumosText(
                l10n.homeHeroBody,
                style: LumosTextStyle.bodyMedium,
                color: colorScheme.onPrimary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Insets.spacing16),
              _buildActionButtons(l10n: l10n, colorScheme: colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration({required ColorScheme colorScheme}) {
    return BoxDecoration(
      borderRadius: BorderRadii.large,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          colorScheme.primary,
          colorScheme.primaryContainer,
          colorScheme.tertiaryContainer,
        ],
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: colorScheme.primary.withValues(
            alpha: WidgetOpacities.elevationLevel5,
          ),
          blurRadius: Insets.spacing24,
          offset: const Offset(Insets.spacing0, Insets.spacing12),
        ),
      ],
    );
  }

  Widget _buildHeroBadge({required ColorScheme colorScheme}) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.auto_awesome_rounded,
          size: IconSizes.iconMedium,
          color: colorScheme.onPrimary,
        ),
        const SizedBox(width: Insets.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.spacing8,
            vertical: Insets.spacing4,
          ),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withValues(
              alpha: WidgetOpacities.elevationLevel4,
            ),
            borderRadius: BorderRadii.medium,
          ),
          child: LumosText(
            l10n.homeAiLearningPath,
            style: LumosTextStyle.labelSmall,
            color: colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons({
    required AppLocalizations l10n,
    required ColorScheme colorScheme,
  }) {
    return Wrap(
      spacing: Insets.spacing8,
      runSpacing: Insets.spacing8,
      children: <Widget>[
        LumosButton(
          label: l10n.homePrimaryAction,
          onPressed: () {},
          icon: Icons.play_arrow_rounded,
        ),
        LumosButton(
          label: l10n.homeSecondaryAction,
          onPressed: () {},
          type: LumosButtonType.text,
          customColor: colorScheme.onPrimary,
        ),
      ],
    );
  }
}
