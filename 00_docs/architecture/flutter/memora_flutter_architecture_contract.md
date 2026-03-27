# lumos Flutter Architecture Contract

This file is the repo-local source of truth for Flutter folder placement, theme and responsive foundation, shared presentation boundaries, feature structure, and architecture rollout order in `lumos`.

## Metadata

- Project type: Flutter full app
- Scope: Repository-wide target structure
- Intent: target structure
- Notes: Repo-local clean-architecture contract for lumos in `lumos`, using Riverpod Annotation + DI, app-wide `domain` and `data` roots, and shared presentation split into `primitives` and `composites`.

## Folder tree

```text
lib/
├─ main.dart                                              // Entry point
│
├─ app/                                                   // App bootstrap cấp cao
│  ├─ app.dart                                            // MaterialApp / ProviderScope / root widget
│  ├─ app_router.dart                                     // Router config
│  ├─ app_routes.dart                                     // Route name/path constants
│  ├─ app_providers.dart                                  // Provider toàn app
│  ├─ app_initializer.dart                                // Khởi tạo service trước khi run app
│  └─ app_lifecycle_handler.dart                          // Theo dõi app lifecycle
│
├─ core/                                                  // Nền tảng hệ thống, không chứa feature UI
│  │
│  ├─ config/                                             // Cấu hình hệ thống
│  │  ├─ env_config.dart                                  // Env, flavor, base url
│  │  ├─ app_constants.dart                               // Constant toàn app
│  │  ├─ app_assets.dart                                  // Đường dẫn asset
│  │  ├─ app_strings.dart                                 // String system
│  │  ├─ app_keys.dart                                    // Global keys / storage keys
│  │  ├─ app_limits.dart                                  // Giới hạn số lượng / độ dài
│  │  ├─ app_duration.dart                                // Duration chuẩn
│  │  ├─ app_debounce.dart                                // Debounce / throttle
│  │  └─ app_icons.dart                                   // Mapping icon nếu cần
│  │
│  ├─ theme/                                              // Design system + responsive foundation
│  │  │
│  │  ├─ tokens/                                          // Base token cố định
│  │  │  ├─ color_tokens.dart                             // Màu sắc chuẩn
│  │  │  ├─ spacing_tokens.dart                           // Base spacing
│  │  │  ├─ radius_tokens.dart                            // Base border radius
│  │  │  ├─ elevation_tokens.dart                         // Base elevation
│  │  │  ├─ typography_tokens.dart                        // Base typography
│  │  │  ├─ icon_tokens.dart                              // Base icon size
│  │  │  ├─ size_tokens.dart                              // Base component size
│  │  │  ├─ border_tokens.dart                            // Border width/style
│  │  │  ├─ opacity_tokens.dart                           // Opacity chuẩn
│  │  │  ├─ motion_tokens.dart                            // Duration / curve animation
│  │  │  └─ shadow_tokens.dart                            // Shadow preset
│  │  │
│  │  ├─ responsive/                                      // Phần thích ứng đa màn hình
│  │  │  ├─ breakpoints.dart                              // Breakpoint mobile/tablet/desktop
│  │  │  ├─ screen_class.dart                             // Enum compact/medium/expanded/large
│  │  │  ├─ screen_info.dart                              // Model thông tin màn hình
│  │  │  ├─ responsive_scale.dart                         // Logic scale có giới hạn
│  │  │  ├─ adaptive_spacing.dart                         // Spacing sau scale
│  │  │  ├─ adaptive_radius.dart                          // Radius sau scale
│  │  │  ├─ adaptive_typography.dart                      // Typography sau scale
│  │  │  ├─ adaptive_icon_size.dart                       // Icon size sau scale
│  │  │  ├─ adaptive_component_size.dart                  // Button/input/card/dialog size
│  │  │  ├─ adaptive_layout.dart                          // Max width, gutter, columns, split view
│  │  │  └─ responsive_theme_factory.dart                 // Tạo responsive theme extension
│  │  │
│  │  ├─ extensions/                                      // ThemeExtension + context access
│  │  │  ├─ color_scheme_ext.dart                         // Custom color extension
│  │  │  ├─ text_theme_ext.dart                           // Custom text extension
│  │  │  ├─ component_theme_ext.dart                      // Component custom theme extension
│  │  │  ├─ dimension_theme_ext.dart                      // Adaptive spacing/radius/layout/theme ext
│  │  │  ├─ theme_context_ext.dart                        // context.spacing / context.radius / context.layout
│  │  │  └─ screen_context_ext.dart                       // context.screenClass / context.screenInfo
│  │  │
│  │  ├─ component_themes/                                // Apply token + adaptive size vào ThemeData
│  │  │  ├─ button_theme.dart                             // Elevated/Outlined/Text button theme
│  │  │  ├─ input_theme.dart                              // InputDecoration theme
│  │  │  ├─ card_theme.dart                               // Card theme
│  │  │  ├─ dialog_theme.dart                             // Dialog theme
│  │  │  ├─ chip_theme.dart                               // Chip/badge theme
│  │  │  ├─ app_bar_theme.dart                            // AppBar theme
│  │  │  ├─ divider_theme.dart                            // Divider theme
│  │  │  ├─ checkbox_theme.dart                           // Checkbox theme
│  │  │  ├─ radio_theme.dart                              // Radio theme
│  │  │  ├─ switch_theme.dart                             // Switch theme
│  │  │  ├─ slider_theme.dart                             // Slider theme
│  │  │  ├─ progress_indicator_theme.dart                 // Progress theme
│  │  │  └─ bottom_sheet_theme.dart                       // Bottom sheet theme
│  │  │
│  │  ├─ app_color_scheme.dart                            // ColorScheme mapping
│  │  ├─ app_text_theme.dart                              // TextTheme mapping
│  │  ├─ app_theme_mode.dart                              // Theme mode enum/helper
│  │  ├─ theme_helpers.dart                               // Helper build theme
│  │  └─ app_theme.dart                                   // Assemble ThemeData light/dark
│  │
│  ├─ utils/                                              // Utility thuần
│  │  ├─ string_utils.dart                                // Chuỗi
│  │  ├─ date_time_utils.dart                             // Ngày giờ
│  │  ├─ duration_utils.dart                              // Duration format
│  │  ├─ number_utils.dart                                // Số
│  │  ├─ list_utils.dart                                  // List helper
│  │  ├─ map_utils.dart                                   // Map helper
│  │  ├─ object_utils.dart                                // Null-safe helper
│  │  ├─ validation_utils.dart                            // Validate chung
│  │  ├─ file_utils.dart                                  // File helper
│  │  ├─ url_utils.dart                                   // URL helper
│  │  ├─ clipboard_utils.dart                             // Clipboard
│  │  ├─ device_utils.dart                                // Device helper
│  │  ├─ keyboard_utils.dart                              // Keyboard helper
│  │  ├─ focus_utils.dart                                 // Focus helper
│  │  ├─ color_utils.dart                                 // Màu helper
│  │  ├─ context_utils.dart                               // BuildContext helper
│  │  ├─ route_utils.dart                                 // Navigation helper
│  │  ├─ permission_utils.dart                            // Permission helper
│  │  ├─ haptic_utils.dart                                // Haptic helper
│  │  └─ logger.dart                                      // Logger wrapper
│  │
│  ├─ extensions/                                         // Extension dùng toàn app
│  │  ├─ build_context_ext.dart                           // context helper chung
│  │  ├─ string_ext.dart                                  // String extension
│  │  ├─ iterable_ext.dart                                // Iterable extension
│  │  ├─ list_ext.dart                                    // List extension
│  │  ├─ date_time_ext.dart                               // DateTime extension
│  │  ├─ duration_ext.dart                                // Duration extension
│  │  ├─ num_ext.dart                                     // num extension
│  │  └─ widget_ref_ext.dart                              // Riverpod helper
│  │
│  ├─ enums/                                              // Enum toàn app
│  │  ├─ app_locale.dart                                  // Locale enum
│  │  ├─ app_language.dart                                // Language enum
│  │  ├─ app_theme_type.dart                              // Light/dark/system
│  │  ├─ loading_status.dart                              // idle/loading/success/error
│  │  ├─ snackbar_type.dart                               // success/error/info/warning
│  │  ├─ dialog_type.dart                                 // dialog type
│  │  ├─ sort_direction.dart                              // asc/desc
│  │  └─ filter_operator.dart                             // filter operator
│  │
│  ├─ errors/                                             // Error chuẩn hệ thống
│  │  ├─ app_exception.dart                               // Base exception
│  │  ├─ failure.dart                                     // Base failure
│  │  ├─ network_failure.dart                             // Lỗi mạng
│  │  ├─ validation_failure.dart                          // Lỗi validate
│  │  ├─ storage_failure.dart                             // Lỗi storage
│  │  ├─ auth_failure.dart                                // Lỗi auth
│  │  └─ error_mapper.dart                                // Map exception -> UI error
│  │
│  ├─ network/                                            // HTTP nền tảng
│  │  ├─ api_client.dart                                  // HTTP client wrapper
│  │  ├─ api_response.dart                                // Base API response
│  │  ├─ api_error_response.dart                          // API error response
│  │  ├─ network_info.dart                                // Online/offline checker
│  │  └─ interceptors/
│  │     ├─ auth_interceptor.dart                         // Gắn token
│  │     ├─ logging_interceptor.dart                      // Log request/response
│  │     ├─ retry_interceptor.dart                        // Retry nếu cần
│  │     └─ connectivity_interceptor.dart                 // Kiểm tra mạng
│  │
│  ├─ storage/                                            // Local persistence
│  │  ├─ local_storage.dart                               // Storage wrapper
│  │  ├─ secure_storage.dart                              // Secure storage wrapper
│  │  ├─ preferences_storage.dart                         // SharedPreferences wrapper
│  │  ├─ cache_manager.dart                               // Cache helper
│  │  └─ storage_keys.dart                                // Storage key constants
│  │
│  ├─ services/                                           // Service toàn app
│  │  ├─ navigation_service.dart                          // Điều hướng toàn app
│  │  ├─ dialog_service.dart                              // Show dialog toàn app
│  │  ├─ snackbar_service.dart                            // Show snackbar toàn app
│  │  ├─ bottom_sheet_service.dart                        // Show bottom sheet
│  │  ├─ analytics_service.dart                           // Analytics
│  │  ├─ crashlytics_service.dart                         // Crash reporting
│  │  ├─ connectivity_service.dart                        // Theo dõi mạng
│  │  ├─ notification_service.dart                        // Notification base
│  │  ├─ local_notification_service.dart                  // Local notification
│  │  ├─ audio_service.dart                               // Audio helper base
│  │  ├─ text_to_speech_service.dart                      // TTS service
│  │  ├─ vibration_service.dart                           // Vibration/haptic
│  │  ├─ permission_service.dart                          // Permission service
│  │  ├─ file_picker_service.dart                         // Pick/import/export file
│  │  ├─ share_service.dart                               // Share nội dung
│  │  ├─ review_service.dart                              // In-app review
│  │  └─ clock_service.dart                               // Time source dễ test
│  │
│  ├─ database/                                           // Local db nếu có
│  │  ├─ app_database.dart                                // DB root
│  │  ├─ database_provider.dart                           // Provider DB
│  │  ├─ table_names.dart                                 // Tên bảng
│  │  └─ migrations/
│  │     ├─ migration_v1.dart                             // Migration v1
│  │     └─ migration_v2.dart                             // Migration v2
│  │
│  └─ di/                                                 // Dependency injection nền tảng
│     ├─ core_providers.dart                              // Provider cho core
│     ├─ service_providers.dart                           // Provider cho service
│     ├─ repository_providers.dart                        // Provider repository base
│     └─ datasource_providers.dart                        // Provider datasource base
│
├─ presentation/                                          // Presentation layer
│  │
│  ├─ shared/                                             // Shared UI, provider-free and reusable across app
│  │  │
│  │  ├─ primitives/                                      // Wrapper raw Material widget
│  │  │  │
│  │  │  ├─ buttons/
│  │  │  │  ├─ app_button.dart                            // Button base
│  │  │  │  ├─ app_primary_button.dart                    // Nút chính
│  │  │  │  ├─ app_secondary_button.dart                  // Nút phụ
│  │  │  │  ├─ app_outline_button.dart                    // Nút viền
│  │  │  │  ├─ app_text_button.dart                       // Nút text
│  │  │  │  ├─ app_icon_button.dart                       // Nút icon
│  │  │  │  ├─ app_fab_button.dart                        // FAB
│  │  │  │  └─ app_danger_button.dart                     // Nút destructive
│  │  │  │
│  │  │  ├─ inputs/
│  │  │  │  ├─ app_text_field.dart                        // Text field base
│  │  │  │  ├─ app_password_field.dart                    // Password input
│  │  │  │  ├─ app_search_field.dart                      // Search input
│  │  │  │  ├─ app_number_field.dart                      // Number input
│  │  │  │  ├─ app_multiline_field.dart                   // Text area
│  │  │  │  ├─ app_dropdown_field.dart                    // Dropdown/select
│  │  │  │  ├─ app_date_field.dart                        // Date field
│  │  │  │  ├─ app_time_field.dart                        // Time field
│  │  │  │  ├─ app_slider_input.dart                      // Slider input
│  │  │  │  ├─ app_score_input.dart                       // Input điểm review
│  │  │  │  └─ app_form_field_label.dart                  // Label chuẩn cho field
│  │  │  │
│  │  │  ├─ displays/
│  │  │  │  ├─ app_card.dart                              // Card base
│  │  │  │  ├─ app_outlined_card.dart                     // Card viền
│  │  │  │  ├─ app_surface.dart                           // Surface wrapper
│  │  │  │  ├─ app_icon.dart                              // Icon wrapper
│  │  │  │  ├─ app_image.dart                             // Image wrapper
│  │  │  │  ├─ app_network_image.dart                     // Ảnh mạng
│  │  │  │  ├─ app_avatar.dart                            // Avatar
│  │  │  │  ├─ app_badge.dart                             // Badge
│  │  │  │  ├─ app_chip.dart                              // Chip
│  │  │  │  ├─ app_tag.dart                               // Tag
│  │  │  │  ├─ app_pill.dart                              // Capsule style
│  │  │  │  ├─ app_divider.dart                           // Divider ngang
│  │  │  │  ├─ app_vertical_divider.dart                  // Divider dọc
│  │  │  │  ├─ app_label.dart                             // Label text
│  │  │  │  ├─ app_value_text.dart                        // Value text
│  │  │  │  ├─ app_counter_badge.dart                     // Badge số lượng
│  │  │  │  └─ app_progress_bar.dart                      // Progress bar
│  │  │  │
│  │  │  ├─ feedback/
│  │  │  │  ├─ app_loader.dart                            // Loader base
│  │  │  │  ├─ app_circular_loader.dart                   // Loader tròn
│  │  │  │  ├─ app_linear_loader.dart                     // Loader ngang
│  │  │  │  ├─ app_shimmer.dart                           // Shimmer
│  │  │  │  ├─ app_tooltip.dart                           // Tooltip
│  │  │  │  ├─ app_snackbar.dart                          // Snackbar view
│  │  │  │  └─ app_banner.dart                            // Banner thông báo
│  │  │  │
│  │  │  ├─ selections/
│  │  │  │  ├─ app_checkbox.dart                          // Checkbox
│  │  │  │  ├─ app_radio.dart                             // Radio
│  │  │  │  ├─ app_switch.dart                            // Switch
│  │  │  │  ├─ app_toggle.dart                            // Toggle button
│  │  │  │  └─ app_segmented_control.dart                 // Segmented control
│  │  │  │
│  │  │  ├─ layout/
│  │  │  │  ├─ app_gap.dart                               // Gap widget
│  │  │  │  ├─ app_spacing.dart                           // Spacing widget
│  │  │  │  ├─ app_safe_area.dart                         // Safe area wrapper
│  │  │  │  ├─ app_constrained_box.dart                   // Constraint wrapper
│  │  │  │  └─ app_responsive_container.dart              // Responsive container
│  │  │  │
│  │  │  └─ text/
│  │  │     ├─ app_text.dart                              // Text wrapper base
│  │  │     ├─ app_title_text.dart                        // Text tiêu đề
│  │  │     ├─ app_body_text.dart                         // Text nội dung
│  │  │     ├─ app_caption_text.dart                      // Caption
│  │  │     └─ app_link_text.dart                         // Text dạng link
│  │  │
│  │  ├─ composites/                                      // Ghép primitive thành UI pattern
│  │  │  │
│  │  │  ├─ appbars/
│  │  │  │  ├─ app_top_bar.dart                           // App bar chuẩn
│  │  │  │  ├─ app_search_top_bar.dart                    // App bar có search
│  │  │  │  └─ app_selection_top_bar.dart                 // App bar cho multi-select
│  │  │  │
│  │  │  ├─ dialogs/
│  │  │  │  ├─ app_alert_dialog.dart                      // Dialog thông báo
│  │  │  │  ├─ app_confirm_dialog.dart                    // Dialog xác nhận
│  │  │  │  ├─ app_bottom_sheet.dart                      // Bottom sheet base
│  │  │  │  ├─ app_action_sheet.dart                      // Action sheet
│  │  │  │  ├─ app_input_dialog.dart                      // Dialog nhập liệu
│  │  │  │  └─ app_rating_input_dialog.dart               // Dialog nhập rating/score dùng lại nhiều nơi
│  │  │  │
│  │  │  ├─ lists/
│  │  │  │  ├─ app_list_item.dart                         // Item list base
│  │  │  │  ├─ app_selectable_list_item.dart              // Item chọn được
│  │  │  │  ├─ app_swipe_list_item.dart                   // Item swipe
│  │  │  │  ├─ app_reorderable_list_item.dart             // Item reorder
│  │  │  │  └─ app_section_list.dart                      // List theo section
│  │  │  │
│  │  │  ├─ states/
│  │  │  │  ├─ app_loading_state.dart                     // Loading state
│  │  │  │  ├─ app_empty_state.dart                       // Empty state
│  │  │  │  ├─ app_error_state.dart                       // Error state
│  │  │  │  ├─ app_offline_state.dart                     // Offline state
│  │  │  │  ├─ app_unauthorized_state.dart                // Unauthorized state
│  │  │  │  ├─ app_no_result_state.dart                   // No result state
│  │  │  │  └─ app_fullscreen_loader.dart                 // Fullscreen loader
│  │  │  │
│  │  │  ├─ navigation/
│  │  │  │  ├─ app_bottom_navigation.dart                 // Bottom navigation
│  │  │  │  ├─ app_navigation_rail.dart                   // Navigation rail
│  │  │  │  ├─ app_tab_bar.dart                           // Tab bar
│  │  │  │  ├─ app_breadcrumb.dart                        // Breadcrumb
│  │  │  │  ├─ app_page_header.dart                       // Header page
│  │  │  │  └─ app_session_progress_header.dart           // Header tiến trình dùng lại nhiều flow
│  │  │  │
│  │  │  ├─ forms/
│  │  │  │  ├─ app_search_bar.dart                        // Search bar hoàn chỉnh
│  │  │  │  ├─ app_filter_bar.dart                        // Filter bar
│  │  │  │  ├─ app_sort_bar.dart                          // Sort bar
│  │  │  │  ├─ app_form_section.dart                      // Form section
│  │  │  │  └─ app_submit_bar.dart                        // Submit/action bar
│  │  │  │
│  │  │  ├─ cards/
│  │  │  │  ├─ app_info_card.dart                         // Card thông tin
│  │  │  │  ├─ app_action_card.dart                       // Card có action
│  │  │  │  ├─ app_stat_card.dart                         // Card thống kê
│  │  │  │  ├─ app_progress_card.dart                     // Card tiến độ
│  │  │  │  └─ app_card_face.dart                         // Mặt trước/sau card dùng lại nhiều nơi
│  │  │  │
│  │  │  ├─ feedback/
│  │  │  │  ├─ app_toast_listener.dart                    // Listener toast
│  │  │  │  ├─ app_snackbar_listener.dart                 // Listener snackbar
│  │  │  │  ├─ app_retry_panel.dart                       // Retry panel
│  │  │  │  └─ app_result_banner.dart                     // Banner trạng thái dùng lại nhiều nơi
│  │  │
│  │  ├─ layouts/                                         // Layout shared cấp presentation
│  │  │  ├─ app_scaffold.dart                             // Scaffold chuẩn
│  │  │  ├─ app_nested_scaffold.dart                      // Nested scaffold
│  │  │  ├─ app_scroll_view.dart                          // Scroll view chuẩn
│  │  │  ├─ app_list_page_layout.dart                     // Layout page dạng list
│  │  │  ├─ app_detail_page_layout.dart                   // Layout page chi tiết
│  │  │  ├─ app_form_page_layout.dart                     // Layout page form
│  │  │  ├─ app_dashboard_layout.dart                     // Layout dashboard
│  │  │  ├─ app_study_layout.dart                         // Layout study session
│  │  │  └─ app_split_view_layout.dart                    // Split view tablet/desktop
│  │  │
│  │  ├─ screens/                                         // Shared screen cấp hệ thống
│  │  │  ├─ splash_screen.dart                            // Splash screen
│  │  │  ├─ not_found_screen.dart                         // 404 screen
│  │  │  ├─ maintenance_screen.dart                       // Maintenance screen
│  │  │  └─ offline_screen.dart                           // Offline screen
│  │  │
│  │  ├─ mixins/                                          // Mixin presentation dùng chung
│  │  │  ├─ loading_state_mixin.dart                      // Loading helper
│  │  │  ├─ snackbar_mixin.dart                           // Snackbar helper
│  │  │  ├─ dialog_mixin.dart                             // Dialog helper
│  │  │  ├─ pagination_mixin.dart                         // Pagination helper
│  │  │  └─ keyboard_dismiss_mixin.dart                   // Dismiss keyboard helper
│  │  │
│  │  ├─ controllers/                                     // Controller UI dùng chung
│  │  │  ├─ app_search_controller.dart                    // Search controller
│  │  │  ├─ app_pagination_controller.dart                // Pagination controller
│  │  │  ├─ app_selection_controller.dart                 // Multi-select controller
│  │  │  └─ app_debounce_controller.dart                  // Debounce controller
│  │  │
│  │  └─ presenters/                                      // Model/presenter phục vụ UI shared
│  │     ├─ ui_message.dart                               // UI message model
│  │     ├─ ui_action.dart                                // UI action model
│  │     ├─ ui_filter_item.dart                           // Filter item model
│  │     ├─ ui_sort_item.dart                             // Sort item model
│  │     └─ ui_menu_item.dart                             // Menu item model
│  │
│  └─ features/                                           // Feature UI theo nghiệp vụ
│     │
│     ├─ dashboard/
│     │  ├─ screens/
│     │  │  └─ dashboard_screen.dart                      // Màn dashboard
│     │  ├─ widgets/
│     │  │  ├─ dashboard_header.dart                      // Header dashboard
│     │  │  ├─ dashboard_summary_card.dart                // Tóm tắt học tập
│     │  │  ├─ dashboard_streak_card.dart                 // Streak card
│     │  │  ├─ dashboard_due_decks.dart                   // Deck đến hạn học
│     │  │  └─ dashboard_quick_actions.dart               // Action nhanh
│     │  └─ providers/
│     │     ├─ dashboard_provider.dart                    // State chính
│     │     └─ dashboard_state.dart                       // State model
│     │
│     ├─ folder/
│     │  ├─ screens/
│     │  │  ├─ folder_list_screen.dart                    // Danh sách folder
│     │  │  ├─ folder_detail_screen.dart                  // Chi tiết folder
│     │  │  └─ folder_form_screen.dart                    // Tạo/sửa folder
│     │  ├─ widgets/
│     │  │  ├─ folder_card.dart                           // Card folder
│     │  │  ├─ folder_list_item.dart                      // Item folder
│     │  │  ├─ folder_tree_view.dart                      // Cây folder
│     │  │  ├─ folder_breadcrumb.dart                     // Breadcrumb folder
│     │  │  ├─ folder_empty_view.dart                     // Empty view
│     │  │  └─ folder_action_menu.dart                    // Menu action
│     │  └─ providers/
│     │     ├─ folder_provider.dart                       // State chính
│     │     ├─ folder_state.dart                          // State model
│     │     └─ folder_filter_provider.dart                // Filter/sort/search
│     │
│     ├─ deck/
│     │  ├─ screens/
│     │  │  ├─ deck_list_screen.dart                      // Danh sách deck
│     │  │  ├─ deck_detail_screen.dart                    // Chi tiết deck
│     │  │  ├─ deck_form_screen.dart                      // Tạo/sửa deck
│     │  │  └─ deck_statistics_screen.dart                // Thống kê deck
│     │  ├─ widgets/
│     │  │  ├─ deck_card.dart                             // Card deck
│     │  │  ├─ deck_list_item.dart                        // Item deck
│     │  │  ├─ deck_grid_item.dart                        // Grid item deck
│     │  │  ├─ deck_header.dart                           // Header deck
│     │  │  ├─ deck_progress_summary.dart                 // Tóm tắt tiến độ
│     │  │  ├─ deck_action_menu.dart                      // Menu action deck
│     │  │  ├─ deck_empty_view.dart                       // Empty view
│     │  │  └─ deck_filter_bar.dart                       // Filter bar riêng
│     │  └─ providers/
│     │     ├─ deck_provider.dart                         // State chính
│     │     ├─ deck_state.dart                            // State model
│     │     └─ deck_filter_provider.dart                  // Filter/sort/search
│     │
│     ├─ flashcard/
│     │  ├─ screens/
│     │  │  ├─ flashcard_list_screen.dart                 // Danh sách flashcard
│     │  │  ├─ flashcard_detail_screen.dart               // Chi tiết flashcard
│     │  │  ├─ flashcard_form_screen.dart                 // Tạo/sửa flashcard
│     │  │  ├─ flashcard_preview_screen.dart              // Preview flashcard
│     │  │  └─ flashcard_import_screen.dart               // Import CSV/file
│     │  ├─ widgets/
│     │  │  ├─ flashcard_card.dart                        // Card flashcard
│     │  │  ├─ flashcard_list_item.dart                   // Item flashcard
│     │  │  ├─ flashcard_term_view.dart                   // View term
│     │  │  ├─ flashcard_meaning_view.dart                // View meaning
│     │  │  ├─ flashcard_audio_button.dart                // Nút phát audio
│     │  │  ├─ flashcard_editor_form.dart                 // Form editor
│     │  │  ├─ flashcard_import_result.dart               // Kết quả import
│     │  │  └─ flashcard_empty_view.dart                  // Empty view
│     │  └─ providers/
│     │     ├─ flashcard_provider.dart                    // State chính
│     │     ├─ flashcard_state.dart                       // State model
│     │     ├─ flashcard_filter_provider.dart             // Filter/sort/search
│     │     └─ flashcard_editor_provider.dart             // Editor/form state
│     │
│     ├─ study/
│     │  ├─ screens/
│     │  │  ├─ study_setup_screen.dart                    // Cấu hình học
│     │  │  ├─ study_session_screen.dart                  // Học chính
│     │  │  ├─ study_result_screen.dart                   // Kết quả buổi học
│     │  │  ├─ study_history_screen.dart                  // Lịch sử học
│     │  │  └─ study_mode_picker_screen.dart              // Chọn/chuỗi mode học
│     │  ├─ widgets/
│     │  │  ├─ study_header.dart                          // Header buổi học
│     │  │  ├─ study_footer.dart                          // Footer buổi học
│     │  │  ├─ study_progress_bar.dart                    // Progress học
│     │  │  ├─ study_mode_stepper.dart                    // Tiến trình mode
│     │  │  ├─ study_action_bar.dart                      // Action đúng/sai/tiếp tục
│     │  │  ├─ study_audio_controls.dart                  // Audio controls
│     │  │  ├─ study_result_summary.dart                  // Tóm tắt kết quả
│     │  │  └─ study_exit_confirm_dialog.dart             // Confirm thoát
│     │  ├─ providers/
│     │  │  ├─ study_session_provider.dart                // State phiên học
│     │  │  ├─ study_session_state.dart                   // State model
│     │  │  ├─ study_setup_provider.dart                  // State setup
│     │  │  └─ study_result_provider.dart                 // State kết quả
│     │  └─ modes/                                        // Mỗi mode học tách riêng
│     │     ├─ review/
│     │     │  ├─ review_mode_screen.dart                 // Review mode
│     │     │  ├─ review_flashcard_view.dart              // UI review flashcard
│     │     │  ├─ review_score_panel.dart                 // Panel nhập điểm
│     │     │  └─ review_mode_provider.dart               // State review
│     │     ├─ match/
│     │     │  ├─ match_mode_screen.dart                  // Match mode
│     │     │  ├─ match_board.dart                        // Bảng match
│     │     │  ├─ match_option_tile.dart                  // Tile option
│     │     │  └─ match_mode_provider.dart                // State match
│     │     ├─ guess/
│     │     │  ├─ guess_mode_screen.dart                  // Guess mode
│     │     │  ├─ guess_question_view.dart                // Câu hỏi
│     │     │  ├─ guess_option_list.dart                  // Danh sách đáp án
│     │     │  └─ guess_mode_provider.dart                // State guess
│     │     ├─ recall/
│     │     │  ├─ recall_mode_screen.dart                 // Recall mode
│     │     │  ├─ recall_prompt_view.dart                 // Prompt recall
│     │     │  ├─ recall_answer_view.dart                 // Hiển thị đáp án
│     │     │  └─ recall_mode_provider.dart               // State recall
│     │     └─ fill/
│     │        ├─ fill_mode_screen.dart                   // Fill mode
│     │        ├─ fill_question_view.dart                 // Câu hỏi điền chỗ trống
│     │        ├─ fill_answer_input.dart                  // Ô nhập đáp án
│     │        └─ fill_mode_provider.dart                 // State fill
│     │
│     ├─ progress/
│     │  ├─ screens/
│     │  │  ├─ learning_progress_screen.dart              // Tiến độ học tập
│     │  │  ├─ deck_progress_screen.dart                  // Tiến độ theo deck
│     │  │  └─ study_calendar_screen.dart                 // Lịch học/ôn tập
│     │  ├─ widgets/
│     │  │  ├─ progress_summary_card.dart                 // Tóm tắt tiến độ
│     │  │  ├─ progress_chart_section.dart                // Biểu đồ
│     │  │  ├─ progress_filter_bar.dart                   // Filter bar
│     │  │  ├─ progress_history_list.dart                 // Lịch sử tiến độ
│     │  │  ├─ due_flashcard_section.dart                 // Thẻ đến hạn
│     │  │  └─ streak_calendar.dart                       // Calendar streak
│     │  └─ providers/
│     │     ├─ progress_provider.dart                     // State chính
│     │     ├─ progress_state.dart                        // State model
│     │     └─ progress_filter_provider.dart              // Filter state
│     │
│     ├─ reminder/
│     │  ├─ screens/
│     │  │  ├─ reminder_settings_screen.dart              // Cài đặt reminder
│     │  │  ├─ reminder_time_slots_screen.dart            // Time slot reminder
│     │  │  └─ reminder_preview_screen.dart               // Preview notification
│     │  ├─ widgets/
│     │  │  ├─ reminder_toggle_tile.dart                  // Bật/tắt reminder
│     │  │  ├─ reminder_time_slot_card.dart               // Card time slot
│     │  │  ├─ reminder_frequency_selector.dart           // Chọn tần suất
│     │  │  └─ reminder_day_selector.dart                 // Chọn ngày lặp
│     │  └─ providers/
│     │     ├─ reminder_provider.dart                     // State chính
│     │     └─ reminder_state.dart                        // State model
│     │
│     ├─ settings/
│     │  ├─ screens/
│     │  │  ├─ settings_screen.dart                       // Settings chung
│     │  │  ├─ theme_settings_screen.dart                 // Cài đặt theme
│     │  │  ├─ language_settings_screen.dart              // Cài đặt ngôn ngữ
│     │  │  ├─ audio_settings_screen.dart                 // Cài đặt audio/TTS
│     │  │  ├─ backup_restore_screen.dart                 // Backup/restore
│     │  │  └─ about_screen.dart                          // About
│     │  ├─ widgets/
│     │  │  ├─ settings_section.dart                      // Section settings
│     │  │  ├─ settings_tile.dart                         // Tile base
│     │  │  ├─ settings_switch_tile.dart                  // Tile switch
│     │  │  ├─ settings_navigation_tile.dart              // Tile navigation
│     │  │  └─ settings_value_tile.dart                   // Tile value
│     │  └─ providers/
│     │     ├─ settings_provider.dart                     // State chính
│     │     └─ settings_state.dart                        // State model
│     │
│     ├─ auth/
│     │  ├─ screens/
│     │  │  ├─ login_screen.dart                          // Login nếu app có sync/account
│     │  │  ├─ register_screen.dart                       // Register
│     │  │  └─ forgot_password_screen.dart                // Forgot password
│     │  ├─ widgets/
│     │  │  ├─ login_form.dart                            // Form login
│     │  │  └─ social_login_buttons.dart                  // Nút social login
│     │  └─ providers/
│     │     ├─ auth_provider.dart                         // State auth
│     │     └─ auth_state.dart                            // State model
│     │
│     └─ onboarding/
│        ├─ screens/
│        │  ├─ onboarding_screen.dart                     // Onboarding
│        │  ├─ permissions_intro_screen.dart              // Giới thiệu quyền
│        │  └─ study_goal_setup_screen.dart               // Thiết lập mục tiêu học
│        ├─ widgets/
│        │  ├─ onboarding_page_view.dart                  // Page onboarding
│        │  ├─ onboarding_indicator.dart                  // Indicator
│        │  └─ study_goal_selector.dart                   // Chọn study goal
│        └─ providers/
│           ├─ onboarding_provider.dart                   // State onboarding
│           └─ onboarding_state.dart                      // State model
│
├─ domain/                                                // Domain layer nếu áp dụng Clean Architecture đầy đủ
│  ├─ entities/                                           // Entity dùng chung / shared domain
│  ├─ repositories/                                       // Contract repository
│  └─ usecases/                                           // Use case dùng chung
│
├─ data/                                                  // Data layer nếu tách global
│  ├─ datasources/                                        // Remote/local datasource chung
│  ├─ models/                                             // DTO/model chung
│  ├─ repositories/                                       // Repository implementation
│  └─ mappers/                                            // Mapper data <-> domain
│
└─ l10n/                                                  // Localization
   ├─ app_en.arb                                          // English
   ├─ app_vi.arb                                          // Vietnamese
   ├─ app_ko.arb                                          // Korean
   └─ l10n.dart                                           // Localization config
```

## 2.4 Theme + Responsive Foundation

Muc dich

Phan nay giai quyet:

- design token
- adaptive sizing
- responsive layout
- theme apply dong nhat

Cau truc quan trong

```text
core/theme/
├─ tokens/
├─ responsive/
├─ extensions/
├─ component_themes/
├─ app_color_scheme.dart
├─ app_text_theme.dart
└─ app_theme.dart
```

tokens

Chua token goc:

- color
- spacing
- radius
- elevation
- typography
- icon size
- motion
- border
- opacity
- size

responsive

Chua logic thich ung:

- breakpoints
- screen class
- screen info
- responsive scale
- adaptive spacing
- adaptive radius
- adaptive typography
- adaptive icon size
- adaptive component size
- adaptive layout
- responsive theme factory

extensions

Chua ThemeExtension va context helper:

- dimension theme extension
- color extension
- text extension
- context.spacing
- context.radius
- context.layout
- context.screenClass

component_themes

Chua mapping theme cho component:

- button
- input
- card
- dialog
- chip
- app bar
- divider
- checkbox
- radio
- switch
- slider
- progress
- bottom sheet

## 2.5 Shared Presentation Layer

Muc dich

`presentation/shared` chi chua UI co the dung lai va khong phu thuoc domain.

Cau truc

```text
presentation/shared/
├─ primitives/
├─ composites/
├─ layouts/
├─ screens/
├─ mixins/
├─ controllers/
└─ presenters/
```

## 2.6 Primitive Widgets

Muc dich

Primitive widget la wrapper truc tiep cho raw Material widget.

Vi du

- AppButton
- AppTextField
- AppCard
- AppIcon
- AppCheckbox
- AppSwitch
- AppLoader

Primitive widget duoc phep lam gi

- ap dung token
- ap dung adaptive size
- chuan hoa style
- cung cap API dung lai

Primitive widget khong duoc lam gi

- khong chua business logic
- khong phu thuoc feature
- khong call API
- khong watch provider nghiep vu
- khong import model domain

## 2.7 Composite Widgets

Muc dich

Composite widget ghep nhieu primitive thanh UI pattern co the tai su dung.

Vi du

- AppSearchBar
- AppListItem
- AppConfirmDialog
- AppEmptyState
- AppTopBar
- AppStudyProgressHeader

Composite widget duoc phep lam gi

- ghep primitive
- xu ly layout UI
- dinh nghia slot nhu leading, trailing, action
- dung lai o nhieu feature

Composite widget khong duoc lam gi

- khong chua business logic
- khong phu thuoc folder, deck, flashcard cu the
- khong goi API
- khong phu thuoc state feature cu the

## 2.8 Layouts Layer

Muc dich

`presentation/shared/layouts` chua layout cap man hinh.

Vi du

- AppScaffold
- AppListPageLayout
- AppDetailPageLayout
- AppFormPageLayout
- AppDashboardLayout
- AppStudyLayout
- AppSplitViewLayout

Vai tro

- giu page structure dong nhat
- chuan hoa padding
- chuan hoa max width
- ho tro responsive layout
- giam lap code giua cac man

## 2.9 Shared Screens

Muc dich

Chi danh cho screen toan he thong, khong thuoc feature cu the.

Vi du

- SplashScreen
- NotFoundScreen
- MaintenanceScreen
- OfflineScreen

## 2.10 Feature Layer

Muc dich

`presentation/features` chua UI theo nghiep vu thuc te.

Feature trong lumos

- dashboard
- folder
- deck
- flashcard
- study
- progress
- reminder
- settings
- auth
- onboarding

Moi feature nen co

```text
feature_name/
├─ screens/
├─ widgets/
└─ providers/
```

Vai tro

- screens: man hinh cua feature
- widgets: widget mang nghiep vu
- providers: state management cua feature

## 2.11 Domain Layer

Muc dich

Chua contract nghiep vu va model nghiep vu.

Gom

- entities
- repositories
- usecases

Y nghia

- tach business khoi presentation
- de test
- de mo rong backend hoac local mode

## 2.12 Data Layer

Muc dich

Chua phan hien thuc du lieu.

Gom

- datasources
- models
- repositories
- mappers

Y nghia

- tach DTO khoi entity
- tach API/local implementation khoi UI

## 2.13 Dependency Rule

Luong phu thuoc dung

```text
features
  ↓
shared/composites
  ↓
shared/primitives
  ↓
core/theme + core/utils
```

Luong phu thuoc sai

- shared -> features
- core -> features
- primitive -> feature provider
- composite -> domain-specific widget

## 2.14 Naming Rules

Shared primitives

Phai co prefix chung:

- AppButton
- AppTextField
- AppCard
- AppLoader

Shared composites

Cung dung prefix chung:

- AppSearchBar
- AppConfirmDialog
- AppListItem

Feature widgets

Ten theo domain:

- DeckCard
- FolderTreeView
- FlashcardEditorForm
- StudyHeader
- ProgressSummaryCard

Quy tac

- Shared dung ten generic
- Feature dung ten theo domain

## 2.15 Rule phan loai widget

Widget duoc vao shared khi

- domain-agnostic
- reusable
- feature-independent
- dung lap lai nhieu noi hoac thuoc design system

Widget khong duoc vao shared khi

- phu thuoc folder, deck, flashcard
- chua business logic
- import provider cua feature
- chi dung cho mot nghiep vu cu the

## 2.16 Rule su dung shared widget trong feature

Feature phai uu tien dung shared widget

Trong feature widget:

- button di qua shared primitive
- input di qua shared primitive
- card di qua shared primitive
- dialog di qua shared composite hoac shared primitive tuong ung

Feature duoc phep dung truc tiep raw layout widget

- Row
- Column
- Stack
- Expanded
- Flexible
- Padding
- Align
- SizedBox

Feature khong nen style truc tiep

Khong nen:

- tu tao ElevatedButton style rieng moi man
- tu tao InputDecoration rieng tuy tien
- hardcode spacing/radius lung tung
- scale size bang MediaQuery o tung man

## 2.17 Responsive Rule

Responsive phai tap trung o core

Moi dinh nghia responsive phai nam tai:

- core/theme/responsive
- core/theme/extensions

Shared va feature phai lay qua extension

Vi du:

- context.spacing
- context.radius
- context.layout
- context.component
- context.screenClass

Khong duoc lam

- moi widget tu tinh font theo screenWidth
- moi feature tu dinh nghia breakpoint rieng
- desktop keo full-width khong gioi han
- tablet chi phong to y nguyen layout mobile

## 2.18 Theme Apply Rule

Theme phai duoc build tap trung

app_theme.dart la noi assemble:

- ColorScheme
- TextTheme
- ThemeExtension
- component themes

Shared primitive phai doc tu theme hoac extension

Khong hardcode style lon nho theo man hinh neu da co adaptive layer.

Feature khong override style cua primitive

Neu can bien the moi:

- tao variant moi o primitive
- hoac mo rong API co kiem soat

khong patch style bua trong feature

## 2.19 Study Feature Structure Rule

Study la feature loi nen tach sau hon

```text
study/
├─ screens/
├─ widgets/
├─ providers/
└─ modes/
   ├─ review/
   ├─ match/
   ├─ guess/
   ├─ recall/
   └─ fill/
```

Ly do

- moi mode co UI va state rieng
- de mo rong mode moi
- khong bien study thanh mot file khong lo

## 2.21 MVP Folder Priority

Thu tu dung folder theo ky thuat

- app
- core
- presentation/shared
- presentation/features skeleton
- domain
- data
- l10n

Ly do

Khong dung feature lon khi chua co:

- theme
- responsive
- shared primitive
- shared composite
- routing shell

## 2.22 Feature Development Priority

Trinh tu phat trien dung

- Dashboard skeleton
- Folder Management
- Deck Management
- Flashcard Management
- Study session shell
- Review mode
- Fill mode
- Cac mode con lai
- Progress
- Reminder
- Settings

Ly do

- CRUD du lieu phai co truoc
- study phai dua tren du lieu that
- progress chi co y nghia sau khi co study result
- reminder chi hop ly sau khi co due logic

## 2.23 Code Review Checklist for Folder Architecture

Voi core

- co phu thuoc feature khong
- co widget nghiep vu khong
- co breakpoint tap trung khong
- co adaptive token khong

Voi shared

- co import model domain khong
- co business logic khong
- co call provider feature khong
- co du primitive/composite tach bach khong

Voi feature

- co bypass shared widget khong
- co hardcode size/style nhieu khong
- co tach screen/widgets/providers chua
- co phu thuoc dung chieu khong

## 2.24 Final Architecture Principle

Kien truc cua lumos phai tuan theo nguyen tac:

- Theme va responsive di tu nen tang
- Shared widget la lop ap tieu chuan UI
- Feature chi tap trung nghiep vu
- Khong de shared bi nhiem domain
- Khong de feature pha design system
- Moi thu phai du sach de them mode hoc moi ma khong dap lai kien truc

## Optional rules

Add only rules that matter for folder ownership or placement.

- shared code location: `lib/core/**` cho technical foundation toàn app, `lib/presentation/shared/**` cho UI shared không chứa provider hoặc data logic, `lib/domain/**` và `lib/data/**` cho clean-architecture root toàn app.
- feature ownership rule: `lib/presentation/features/<feature>/**` sở hữu `screens`, `widgets`, `providers` của feature; code đặc thù feature không đẩy vào shared nếu chưa thật sự dùng lại và chưa tách khỏi provider/business logic.
- forbidden placement: không đặt business logic trong widget, không đọc provider trong shared widget, không đặt code `data` hoặc `domain` trong `presentation`, không đặt feature-specific code vào `core`.
- naming rule: dùng `snake_case.dart`, theme nằm dưới `lib/core/theme/**`, shared widget chia thành `lib/presentation/shared/primitives/**` và `lib/presentation/shared/composites/**`, một public type mỗi file khi code không còn trivial.
