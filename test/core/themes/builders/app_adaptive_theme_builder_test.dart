import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/extensions/dimension_theme_ext.dart';
import 'package:lumos/core/theme/responsive/responsive_theme_factory.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';

void main() {
  group('ResponsiveThemeFactory', () {
    test('creates a dimension extension for each screen class', () {
      final compact = ResponsiveThemeFactory.create(ScreenClass.compact);
      final medium = ResponsiveThemeFactory.create(ScreenClass.medium);
      final expanded = ResponsiveThemeFactory.create(ScreenClass.expanded);
      final large = ResponsiveThemeFactory.create(ScreenClass.large);

      expect(compact, isA<DimensionThemeExt>());
      expect(medium, isA<DimensionThemeExt>());
      expect(expanded, isA<DimensionThemeExt>());
      expect(large, isA<DimensionThemeExt>());
    });

    test('scales typography and component sizes up with larger screen classes', () {
      final compact = ResponsiveThemeFactory.create(ScreenClass.compact);
      final large = ResponsiveThemeFactory.create(ScreenClass.large);

      expect(compact.typography.headline, lessThan(large.typography.headline));
      expect(compact.typography.title, lessThan(large.typography.title));
      expect(
        compact.componentSize.inputHeight,
        lessThan(large.componentSize.inputHeight),
      );
      expect(
        compact.componentSize.cardMinHeight,
        lessThan(large.componentSize.cardMinHeight),
      );
    });

    test('maps shape roles from the responsive radius scale', () {
      final compact = ResponsiveThemeFactory.create(ScreenClass.compact);

      expect(compact.shapes.control.topLeft.x, compact.radius.sm);
      expect(compact.shapes.card.topLeft.x, compact.radius.md);
      expect(compact.shapes.hero.topLeft.x, compact.radius.lg);
      expect(compact.shapes.pill.topLeft.x, compact.radius.pill);
    });

    test('exposes dimensions through theme extensions', () {
      final dimensions = ResponsiveThemeFactory.create(ScreenClass.medium);
      final extensions = ResponsiveThemeFactory.extensions(
        dimensions: dimensions,
        brightness: Brightness.dark,
      );

      expect(
        extensions.whereType<DimensionThemeExt>().single,
        same(dimensions),
      );
    });
  });
}
