# Widget Responsive Audit

## Scope

- Rooted at `lib/presentation/features/**`
- Shared UI under `lib/presentation/shared/widgets/**`
- Audit date: `2026-03-14`

## Method

Responsive-aware direct usage was detected by scanning widget files for one of:

- `MediaQuery`
- `ResponsiveDimensions`
- `ResponsiveBuilder`
- `LumosScreenFrame`
- `LayoutBuilder`
- `context.deviceType` / `constraints.deviceType`
- `% width` / `% height` helpers

This report classifies the files that do **not** use those APIs directly.

## Summary

- Total widget files scanned: `149`
- Direct responsive-aware files: `55`
- Files without direct responsive signal: `94`

Classification:

- `OK_PARENT_THEME`
  - Safe to keep render-only for now.
  - These widgets are mostly leaf widgets, state widgets, wrappers, or shared primitives that inherit adaptive sizing from parent layout or theme tokens.
- `ADD_WHEN_TOUCHED`
  - Not urgent, but should adopt responsive helpers if the file is already being modified.
  - Usually section widgets with local spacing or layout rhythm.
- `PRIORITY_REVIEW`
  - Structural widgets that own screen composition, mode composition, scrolling shells, or complex card/pager layout.
  - These are the most likely to still feel oversized on smaller phones even when parent/theme already adapts.

## Direct Responsive-Aware Files

These files already use responsive APIs directly and are not part of the backlog below.

- `lib/presentation/features/auth/screens/auth_screen.dart`
- `lib/presentation/features/auth/screens/widgets/blocks/content/auth_form_card.dart`
- `lib/presentation/features/deck/screens/deck_content.dart`
- `lib/presentation/features/deck/screens/widgets/blocks/content/deck_list_tile.dart`
- `lib/presentation/features/deck/screens/widgets/blocks/footer/deck_create_button.dart`
- `lib/presentation/features/flashcard/screens/flashcard_content.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/content/flashcard_list_card.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/content/flashcard_list_content.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/header/flashcard_preview_carousel.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/header/flashcard_set_metadata_section.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/header/flashcard_study_progress_section.dart`
- `lib/presentation/features/flashcard/screens/widgets/states/flashcard_loading_shell.dart`
- `lib/presentation/features/folder/screens/folder_content.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/content/folder_browser_content.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/footer/folder_create_button.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/header/folder_header_banner.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/header/folder_header_navigation_section.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_mutating_overlay.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_skeleton_view.dart`
- `lib/presentation/features/home/screens/home_content.dart`
- `lib/presentation/features/home/screens/home_screen.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/dashboard/home_hero_card.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/dashboard/home_stat_grid.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/shell/home_placeholder_tab.dart`
- `lib/presentation/features/home/screens/widgets/blocks/header/home_app_bar.dart`
- `lib/presentation/features/profile/screens/profile_content.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/content/profile_account_card.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/content/profile_speech_section.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/content/profile_study_section.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/content/profile_theme_section.dart`
- `lib/presentation/features/progress/screens/study_progress_screen.dart`
- `lib/presentation/features/progress/screens/widgets/blocks/content/study_progress_distribution_card.dart`
- `lib/presentation/features/progress/screens/widgets/blocks/content/study_progress_momentum_card.dart`
- `lib/presentation/features/progress/screens/widgets/blocks/content/study_progress_recommendation_card.dart`
- `lib/presentation/features/study/screens/flashcard_flip_study_screen.dart`
- `lib/presentation/features/study/screens/widgets/blocks/flashcard_study_bottom_bar.dart`
- `lib/presentation/features/study/screens/widgets/blocks/flashcard_study_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/guess/study_session_guess_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/guess/widgets/study_session_guess_choice_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/guess/widgets/study_session_guess_prompt_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/match/widgets/study_session_match_pair_row.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/recall/widgets/study_session_recall_answer_panel.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_action_row_layout.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_progress_row.dart`
- `lib/presentation/shared/widgets/cards/lumos_card.dart`
- `lib/presentation/shared/widgets/cards/lumos_deck_card.dart`
- `lib/presentation/shared/widgets/cards/lumos_entity_list_item_card.dart`
- `lib/presentation/shared/widgets/dialogs/lumos_dialog_widgets.dart`
- `lib/presentation/shared/widgets/feedback/lumos_progress_bar.dart`
- `lib/presentation/shared/widgets/gamification/lumos_gamification_widgets.dart`
- `lib/presentation/shared/widgets/layout/lumos_screen_frame.dart`
- `lib/presentation/shared/widgets/learning/lumos_learning_widgets.dart`
- `lib/presentation/shared/widgets/navigation/lumos_navigation_widgets.dart`
- `lib/presentation/shared/widgets/onboarding/lumos_onboarding_widgets.dart`
- `lib/presentation/shared/widgets/responsive_builder.dart`

## Backlog

### PRIORITY_REVIEW

- `lib/presentation/features/deck/screens/widgets/blocks/content/deck_list_content.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/header/flashcard_study_action_section.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/content/folder_deck_list_content.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/content/folder_list_content.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/dashboard/home_split_section.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/shell/home_adaptive_body.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/shell/home_navigation_scaffold.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/content/profile_speech_preview_panel.dart`
- `lib/presentation/features/study/screens/study_session_screen.dart`
- `lib/presentation/features/study/screens/widgets/blocks/study_session_resolved_body_content.dart`
- `lib/presentation/features/study/screens/widgets/blocks/study_session_screen_body.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/study_session_fill_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_action_row.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_answer_panel.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_body_panel.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_input_panel.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_prompt_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/match/study_session_match_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/match/widgets/study_session_match_pair_button.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/match/widgets/study_session_match_pairs.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/recall/study_session_recall_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/recall/widgets/study_session_recall_action_button.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/recall/widgets/study_session_recall_action_row.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/recall/widgets/study_session_recall_prompt_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/study_session_review_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/widgets/study_session_review_answer_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/widgets/study_session_review_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/widgets/study_session_review_card_deck.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/widgets/study_session_review_card_viewport.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/review/widgets/study_session_review_prompt_card.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/study_session_mode_content.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_action_bar.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_choice_list.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_content_card.dart`
- `lib/presentation/shared/widgets/cards/lumos_action_list_item_card.dart`
- `lib/presentation/shared/widgets/cards/lumos_clickable_card.dart`
- `lib/presentation/shared/widgets/cards/lumos_section_card.dart`
- `lib/presentation/shared/widgets/dialogs/lumos_sort_bottom_sheet.dart`
- `lib/presentation/shared/widgets/layout/lumos_horizontal_pager.dart`
- `lib/presentation/shared/widgets/layout/lumos_paged_sliver_list.dart`
- `lib/presentation/shared/widgets/layout/lumos_swipe_action_surface.dart`

### ADD_WHEN_TOUCHED

- `lib/presentation/features/auth/screens/launch_screen.dart`
- `lib/presentation/features/auth/screens/widgets/blocks/content/auth_form_fields.dart`
- `lib/presentation/features/flashcard/screens/widgets/blocks/header/flashcard_list_header.dart`
- `lib/presentation/features/flashcard/screens/widgets/states/flashcard_loading_mask.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/content/folder_list_tile.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/header/folder_header.dart`
- `lib/presentation/features/folder/screens/widgets/blocks/header/folder_header_meta_pill.dart`
- `lib/presentation/features/home/screens/widgets/blocks/footer/home_bottom_nav.dart`
- `lib/presentation/features/profile/screens/widgets/blocks/footer/profile_logout_button.dart`
- `lib/presentation/features/study/screens/widgets/blocks/study_session_screen_app_bar.dart`
- `lib/presentation/features/study/screens/widgets/blocks/study_session_screen_menu_action_button.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/guess/widgets/study_session_guess_choice_list.dart`
- `lib/presentation/features/study/screens/widgets/sub_mode/widgets/study_session_action_button.dart`
- `lib/presentation/shared/widgets/cards/lumos_flashcard_widgets.dart`
- `lib/presentation/shared/widgets/cards/lumos_outlined_card.dart`
- `lib/presentation/shared/widgets/exercises/lumos_exercise_widgets.dart`
- `lib/presentation/shared/widgets/inputs/lumos_form_widgets.dart`
- `lib/presentation/shared/widgets/layout/lumos_decorative_background.dart`
- `lib/presentation/shared/widgets/misc/lumos_misc_widgets.dart`
- `lib/presentation/shared/widgets/misc/lumos_social_widgets.dart`
- `lib/presentation/shared/widgets/navigation/lumos_menu_widgets.dart`
- `lib/presentation/shared/widgets/skill/lumos_skill_widgets.dart`

### OK_PARENT_THEME

- `lib/presentation/features/deck/screens/deck_screen.dart`
- `lib/presentation/features/deck/screens/widgets/states/deck_empty_view.dart`
- `lib/presentation/features/deck/screens/widgets/states/deck_error_banner.dart`
- `lib/presentation/features/flashcard/screens/flashcard_screen.dart`
- `lib/presentation/features/flashcard/screens/widgets/states/flashcard_empty_view.dart`
- `lib/presentation/features/flashcard/screens/widgets/states/flashcard_error_banner.dart`
- `lib/presentation/features/flashcard/screens/widgets/states/flashcard_mutating_overlay.dart`
- `lib/presentation/features/folder/screens/folder_screen.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_content_mutating_overlay.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_deck_loading.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_empty_view.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_error_banner.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_failure_view.dart`
- `lib/presentation/features/folder/screens/widgets/states/folder_load_more_indicator.dart`
- `lib/presentation/features/home/screens/widgets/blocks/content/dashboard/home_animated_reveal.dart`
- `lib/presentation/features/profile/screens/widgets/states/profile_error_view.dart`
- `lib/presentation/features/progress/screens/widgets/states/study_progress_error_view.dart`
- `lib/presentation/features/progress/screens/widgets/states/study_progress_loading_view.dart`
- `lib/presentation/shared/widgets/buttons/lumos_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_danger_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_floating_action_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_icon_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_outline_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_primary_button.dart`
- `lib/presentation/shared/widgets/buttons/lumos_secondary_button.dart`
- `lib/presentation/shared/widgets/feedback/lumos_empty_state.dart`
- `lib/presentation/shared/widgets/feedback/lumos_error_state.dart`
- `lib/presentation/shared/widgets/feedback/lumos_feedback_widgets.dart`
- `lib/presentation/shared/widgets/feedback/lumos_loading_indicator.dart`
- `lib/presentation/shared/widgets/feedback/lumos_shimmer.dart`
- `lib/presentation/shared/widgets/typography/lumos_text.dart`

## Notes

`OK_PARENT_THEME` does not mean “never improve”. It means the file is currently acceptable because it is mostly leaf rendering and already inherits sizing from parent layout or adaptive theme.

`PRIORITY_REVIEW` should be the first backlog if the goal is to make the app feel tighter on narrow phones.

`study` still has the highest number of structural widgets that are not responsive-aware directly.
