import 'package:flutter/material.dart';

abstract final class ColorUtils {
  static Color withOpacityPercent(Color color, double opacityPercent) {
    final normalized = opacityPercent.clamp(0, 100) / 100;
    return color.withAlpha((normalized * 255).round());
  }

  static Color fromHex(String hex) {
    final sanitized = hex.replaceAll('#', '');
    final normalized = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
    return Color(int.parse(normalized, radix: 16));
  }

  static String toHex(Color color, {bool includeAlpha = false}) {
    final argb = color.toARGB32();
    final alpha = ((argb >> 24) & 0xFF).toRadixString(16).padLeft(2, '0');
    final red = ((argb >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
    final green = ((argb >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
    final blue = (argb & 0xFF).toRadixString(16).padLeft(2, '0');

    return includeAlpha ? '#$alpha$red$green$blue' : '#$red$green$blue';
  }

  static bool isDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  static Color contrastColor(
    Color color, {
    Color light = Colors.white,
    Color dark = Colors.black,
  }) {
    return isDark(color) ? light : dark;
  }
}
