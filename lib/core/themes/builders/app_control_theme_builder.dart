import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';
import '../extensions/theme_extensions.dart';

abstract final class AppControlThemeBuilder {
  static SwitchThemeData switchTheme({required ColorScheme colorScheme}) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContentColor;
        }
        if (states.isSelected) {
          return colorScheme.onPrimary;
        }
        return colorScheme.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContainerColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
    );
  }

  static CheckboxThemeData checkboxTheme({required ColorScheme colorScheme}) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContainerColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.transparentSurfaceColor;
      }),
      checkColor: WidgetStatePropertyAll<Color>(colorScheme.onPrimary),
      side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
        if (states.isDisabled) {
          return BorderSide(
            color: colorScheme.disabledContainerColor,
            width: WidgetSizes.borderWidthRegular,
          );
        }
        return BorderSide(
          color: colorScheme.outline,
          width: WidgetSizes.borderWidthRegular,
        );
      }),
    );
  }

  static RadioThemeData radioTheme({required ColorScheme colorScheme}) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.isDisabled) {
          return colorScheme.disabledContentColor;
        }
        if (states.isSelected) {
          return colorScheme.primary;
        }
        return colorScheme.onSurfaceVariant;
      }),
    );
  }

  static SliderThemeData sliderTheme({required ColorScheme colorScheme}) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.secondaryContainer,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(
        alpha: WidgetOpacities.statePress,
      ),
      trackHeight: WidgetSizes.sliderTrackHeight,
    );
  }
}
