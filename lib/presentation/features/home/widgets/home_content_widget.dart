import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../screens/home_screen.dart';
import 'home_sections_widget.dart';

class HomeContentConst {
  const HomeContentConst._();

  static const double heroMinHeightMobile = 280;
  static const double heroMinHeightLarge = 250;
}

class HomeContent extends StatelessWidget {
  const HomeContent({required this.deviceType, super.key});

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
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
                      child: const HomeHeaderBlock(),
                    ),
                    const SizedBox(height: Insets.gapBetweenSections),
                    _buildAnimatedReveal(
                      order: 1,
                      child: HomeHeroCard(deviceType: deviceType),
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
                color: colorScheme.primary.withValues(alpha: 0.14),
                size: Insets.spacing64 * 3,
              ),
            ),
            Positioned(
              left: -Insets.spacing48,
              top: Insets.spacing64 * 2,
              child: HomeGlowBlob(
                color: colorScheme.tertiary.withValues(alpha: 0.1),
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
  const HomeHeaderBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              LumosText(
                HomeScreenText.greeting,
                style: LumosTextStyle.headlineSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: Insets.spacing4),
              LumosText(
                'You are 78% closer to your weekly goal.',
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
  const HomeHeroCard({required this.deviceType, super.key});

  final DeviceType deviceType;

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
              _buildHeroBadge(),
              const SizedBox(height: Insets.spacing16),
              const LumosText(
                HomeScreenText.heroTitle,
                style: LumosTextStyle.headlineMedium,
                color: Colors.white,
              ),
              const SizedBox(height: Insets.spacing8),
              const LumosText(
                HomeScreenText.heroBody,
                style: LumosTextStyle.bodyMedium,
                color: Colors.white,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Insets.spacing16),
              _buildActionButtons(),
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
          color: colorScheme.primary.withValues(alpha: 0.24),
          blurRadius: Insets.spacing24,
          offset: const Offset(Insets.spacing0, Insets.spacing12),
        ),
      ],
    );
  }

  Widget _buildHeroBadge() {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.auto_awesome_rounded,
          size: IconSizes.iconMedium,
          color: Colors.white,
        ),
        const SizedBox(width: Insets.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Insets.spacing8,
            vertical: Insets.spacing4,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadii.medium,
          ),
          child: const LumosText(
            'AI Learning Path',
            style: LumosTextStyle.labelSmall,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: Insets.spacing8,
      runSpacing: Insets.spacing8,
      children: <Widget>[
        LumosButton(
          label: HomeScreenText.primaryAction,
          onPressed: () {},
          icon: Icons.play_arrow_rounded,
        ),
        LumosButton(
          label: HomeScreenText.secondaryAction,
          onPressed: () {},
          type: LumosButtonType.text,
          customColor: Colors.white,
        ),
      ],
    );
  }
}
