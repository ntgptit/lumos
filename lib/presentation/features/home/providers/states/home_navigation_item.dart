import 'package:flutter/material.dart';

import 'enums/home_tab_id.dart';

class HomeNavigationItem {
  const HomeNavigationItem({
    required this.tabId,
    required this.icon,
    required this.selectedIcon,
  });

  final HomeTabId tabId;
  final IconData icon;
  final IconData selectedIcon;
}
