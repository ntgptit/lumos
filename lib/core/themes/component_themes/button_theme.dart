import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../shape.dart';

class ButtonThemes {
  const ButtonThemes._();

  static ElevatedButtonThemeData elevated({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: textTheme.labelLarge,
        elevation: WidgetSizes.none,
        shape: AppShape.buttonShape(),
      ),
    );
  }

  static FilledButtonThemeData filled({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        textStyle: textTheme.labelLarge,
        shape: AppShape.buttonShape(),
      ),
    );
  }

  static OutlinedButtonThemeData outlined({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: textTheme.labelLarge,
        shape: AppShape.buttonShape(),
        side: BorderSide(
          color: colorScheme.outline,
          width: WidgetSizes.borderWidthRegular,
        ),
      ),
    );
  }

  static TextButtonThemeData text({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        textStyle: textTheme.labelLarge,
        shape: AppShape.buttonShape(),
      ),
    );
  }
}
