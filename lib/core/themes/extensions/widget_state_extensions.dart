import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

abstract final class WidgetStatePriorities {
  static const List<WidgetState> interaction = <WidgetState>[
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
  ];
}

extension WidgetStateSetExtension on Set<WidgetState> {
  bool get isDisabled {
    return contains(WidgetState.disabled);
  }

  bool get isSelected {
    return contains(WidgetState.selected);
  }

  bool get isPressed {
    return contains(WidgetState.pressed);
  }

  bool get isHovered {
    return contains(WidgetState.hovered);
  }

  bool get isFocused {
    return contains(WidgetState.focused);
  }

  bool get isError {
    return contains(WidgetState.error);
  }

  T resolveWithPriority<T>({
    required List<WidgetState> priority,
    required Map<WidgetState, T> values,
    required T fallback,
  }) {
    for (final WidgetState state in priority) {
      if (!contains(state)) {
        continue;
      }
      if (!values.containsKey(state)) {
        continue;
      }
      return values[state] as T;
    }
    return fallback;
  }
}

extension InteractiveOverlayColorExtension on Color {
  Color? resolveInteractiveOverlay(Set<WidgetState> states) {
    return states.resolveWithPriority<Color?>(
      priority: WidgetStatePriorities.interaction,
      values: <WidgetState, Color?>{
        WidgetState.pressed: withValues(alpha: WidgetOpacities.statePress),
        WidgetState.hovered: withValues(alpha: WidgetOpacities.stateHover),
        WidgetState.focused: withValues(alpha: WidgetOpacities.stateFocus),
      },
      fallback: null,
    );
  }

  WidgetStateProperty<Color?> asInteractiveOverlayProperty() {
    return WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) => resolveInteractiveOverlay(states),
    );
  }
}
