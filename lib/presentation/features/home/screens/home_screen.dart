import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../shared/widgets/lumos_widgets.dart';

class HomeScreenText {
  const HomeScreenText._();

  static const String title = 'Lumos';
  static const String body = 'Home';
  static const String subtitle =
      'Build faster with a scalable Flutter foundation.';
  static const String sectionTitle = 'Layout System';
  static const String sectionBody =
      'Using centralized spacing, typography, and responsive breakpoints.';
  static const String actionLabel = 'Start Session';
}

class HomeScreenSemantics {
  const HomeScreenSemantics._();

  static const String heroCard = 'home-hero-card';
  static const String sectionCard = 'home-section-card';
}

class HomeScreenKeys {
  const HomeScreenKeys._();

  static const ValueKey<String> mobileLayout = ValueKey<String>(
    'home-layout-mobile',
  );
  static const ValueKey<String> tabletLayout = ValueKey<String>(
    'home-layout-tablet',
  );
  static const ValueKey<String> desktopLayout = ValueKey<String>(
    'home-layout-desktop',
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(HomeScreenText.title)),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (BuildContext context, DeviceType deviceType) {
            return _HomeContent(deviceType: deviceType);
          },
          tabletBuilder: (BuildContext context, DeviceType deviceType) {
            return _HomeContent(deviceType: deviceType);
          },
          desktopBuilder: (BuildContext context, DeviceType deviceType) {
            return _HomeContent(deviceType: deviceType);
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.deviceType});

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = ResponsiveDimensions.adaptive(
      context: context,
      baseValue: Insets.paddingScreen,
    );
    final bool isMobile = deviceType == DeviceType.mobile;
    return SingleChildScrollView(
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
                _buildTitleSection(),
                const SizedBox(height: Insets.gapBetweenSections),
                _buildCardsSection(context: context, isMobile: isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(
            HomeScreenText.body,
            style: LumosTextStyle.headlineSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosText(
            HomeScreenText.subtitle,
            style: LumosTextStyle.bodyLarge,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection({
    required BuildContext context,
    required bool isMobile,
  }) {
    if (isMobile) {
      return Column(
        key: HomeScreenKeys.mobileLayout,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _HomeHeroCard(),
          const SizedBox(height: Insets.gapBetweenItems),
          const _HomeInfoCard(),
          const SizedBox(height: Insets.gapBetweenSections),
          LumosButton(label: HomeScreenText.actionLabel, onPressed: () {}),
        ],
      );
    }
    if (deviceType == DeviceType.tablet) {
      return Row(
        key: HomeScreenKeys.tabletLayout,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Expanded(child: _HomeHeroCard()),
          const SizedBox(width: Insets.gapBetweenSections),
          const Expanded(child: _HomeInfoCard()),
        ],
      );
    }
    return Row(
      key: HomeScreenKeys.desktopLayout,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Expanded(child: _HomeHeroCard()),
        const SizedBox(width: Insets.gapBetweenSections),
        const Expanded(child: _HomeInfoCard()),
      ],
    );
  }
}

class _HomeHeroCard extends StatelessWidget {
  const _HomeHeroCard();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: HomeScreenSemantics.heroCard,
      child: LumosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.auto_awesome, size: IconSizes.iconXLarge),
            const SizedBox(height: Insets.gapBetweenItems),
            LumosText(HomeScreenText.title, style: LumosTextStyle.titleLarge),
            const SizedBox(height: Insets.spacing8),
            LumosText(
              HomeScreenText.subtitle,
              style: LumosTextStyle.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeInfoCard extends StatelessWidget {
  const _HomeInfoCard();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: HomeScreenSemantics.sectionCard,
      child: LumosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              HomeScreenText.sectionTitle,
              style: LumosTextStyle.titleMedium,
            ),
            const SizedBox(height: Insets.gapBetweenItems),
            LumosText(
              HomeScreenText.sectionBody,
              style: LumosTextStyle.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Insets.gapBetweenItems),
            const LumosProgressBar(value: ResponsiveDimensions.maxPercentage),
          ],
        ),
      ),
    );
  }
}
