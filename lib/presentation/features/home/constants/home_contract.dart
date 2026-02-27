import 'package:flutter/material.dart';

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
