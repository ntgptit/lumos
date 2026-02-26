# Layout Guide

This project follows a centralized layout system for Flutter UI.

## Rules

- Do not hard-code spacing, size, radius, or icon dimensions in widgets.
- Use tokens from `lib/core/constants/dimensions.dart`.
- Use `Theme.of(context).colorScheme` and `Theme.of(context).textTheme`.
- Keep UI render-only; state and business logic stay in providers/notifiers.

## Spacing and Sizing

- Spacing tokens: `Insets.spacing4 ... Insets.spacing64`
- Semantic spacing: `Insets.paddingScreen`, `Insets.gapBetweenItems`, `Insets.gapBetweenSections`
- Radius tokens: `Radius.radiusSmall ... Radius.radiusXLarge`
- Widget size tokens: `WidgetSizes.*`
- Icon tokens: `IconSizes.*`

## Responsive

- Breakpoints:
  - Mobile: `<= Breakpoints.kMobileMaxWidth`
  - Tablet: `> Breakpoints.kMobileMaxWidth` and `<= Breakpoints.kTabletMaxWidth`
  - Desktop: `> Breakpoints.kTabletMaxWidth`
- Prefer `LayoutBuilder`, `Expanded`, `Flexible`, and `ConstrainedBox`.
- Use `ResponsiveBuilder` from `lib/presentation/shared/widgets/responsive_builder.dart` for screen-level branching.

## Accessibility

- Keep touch targets at least `WidgetSizes.minTouchTarget`.
- Add semantic labels for meaningful cards/buttons/sections.
- Handle text overflow using `maxLines` and `TextOverflow.ellipsis` where needed.

## Testing

- Add widget tests for mobile/tablet/desktop breakpoints.
- Verify overflow-safe rendering on small screens.
- Keep smoke tests for root render paths.
