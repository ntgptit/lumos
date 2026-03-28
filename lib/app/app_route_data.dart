import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumos/app/app_shell.dart';
import 'package:lumos/core/utils/route_utils.dart';
import 'package:lumos/core/utils/string_utils.dart';
import 'package:lumos/presentation/features/auth/providers/auth_session_provider.dart';
import 'package:lumos/presentation/features/auth/screens/auth_screen.dart';
import 'package:lumos/presentation/features/auth/screens/forgot_password_screen.dart';
import 'package:lumos/presentation/features/auth/screens/launch_screen.dart';
import 'package:lumos/presentation/features/deck/screens/deck_list_screen.dart';
import 'package:lumos/presentation/features/deck/screens/deck_screen.dart';
import 'package:lumos/presentation/features/flashcard/screens/flashcard_screen.dart';
import 'package:lumos/presentation/features/folder/screens/folder_screen.dart';
import 'package:lumos/presentation/features/home/screens/home_content.dart';
import 'package:lumos/presentation/features/onboarding/screens/onboarding_screen.dart';
import 'package:lumos/presentation/features/onboarding/screens/permissions_intro_screen.dart';
import 'package:lumos/presentation/features/onboarding/screens/study_goal_setup_screen.dart';
import 'package:lumos/presentation/features/progress/screens/deck_progress_screen.dart';
import 'package:lumos/presentation/features/profile/screens/profile_content.dart';
import 'package:lumos/presentation/features/progress/screens/study_calendar_screen.dart';
import 'package:lumos/presentation/features/progress/screens/study_progress_screen.dart';
import 'package:lumos/presentation/features/reminder/screens/reminder_preview_screen.dart';
import 'package:lumos/presentation/features/reminder/screens/reminder_settings_screen.dart';
import 'package:lumos/presentation/features/reminder/screens/reminder_time_slots_screen.dart';
import 'package:lumos/presentation/features/settings/screens/about_screen.dart';
import 'package:lumos/presentation/features/settings/screens/audio_settings_screen.dart';
import 'package:lumos/presentation/features/settings/screens/backup_restore_screen.dart';
import 'package:lumos/presentation/features/settings/screens/language_settings_screen.dart';
import 'package:lumos/presentation/features/settings/screens/theme_settings_screen.dart';
import 'package:lumos/presentation/features/study/screens/study_history_screen.dart';
import 'package:lumos/presentation/features/study/screens/study_session_route_screen.dart';
import 'package:lumos/presentation/features/study/screens/study_mode_picker_screen.dart';
import 'package:lumos/presentation/features/study/screens/study_result_screen.dart';
import 'package:lumos/presentation/features/study/screens/study_setup_screen.dart';
import 'package:lumos/presentation/shared/screens/lumos_maintenance_screen.dart';
import 'package:lumos/presentation/shared/screens/lumos_not_found_screen.dart';
import 'package:lumos/presentation/shared/screens/lumos_offline_screen.dart';

part 'app_route_data.g.dart';

@TypedGoRoute<SplashRouteData>(path: '/splash')
class SplashRouteData extends GoRouteData with $SplashRouteData {
  const SplashRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LaunchScreen();
  }
}

@TypedGoRoute<AuthRouteData>(
  path: '/auth',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<LoginRouteData>(path: 'login'),
    TypedGoRoute<RegisterRouteData>(path: 'register'),
    TypedGoRoute<ForgotPasswordRouteData>(path: 'forgot-password'),
  ],
)
class AuthRouteData extends GoRouteData with $AuthRouteData {
  const AuthRouteData();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return const LoginRouteData().location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthScreen(initialMode: AuthScreenModeState.login);
  }
}

class LoginRouteData extends GoRouteData with $LoginRouteData {
  const LoginRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthScreen(initialMode: AuthScreenModeState.login);
  }
}

class RegisterRouteData extends GoRouteData with $RegisterRouteData {
  const RegisterRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthScreen(initialMode: AuthScreenModeState.register);
  }
}

class ForgotPasswordRouteData extends GoRouteData
    with $ForgotPasswordRouteData {
  const ForgotPasswordRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ForgotPasswordScreen();
  }
}

@TypedGoRoute<OnboardingRouteData>(
  path: '/onboarding',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<OnboardingPermissionsRouteData>(path: 'permissions'),
    TypedGoRoute<OnboardingStudyGoalRouteData>(path: 'study-goal'),
  ],
)
class OnboardingRouteData extends GoRouteData with $OnboardingRouteData {
  const OnboardingRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingScreen();
  }
}

class OnboardingPermissionsRouteData extends GoRouteData
    with $OnboardingPermissionsRouteData {
  const OnboardingPermissionsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PermissionsIntroScreen();
  }
}

class OnboardingStudyGoalRouteData extends GoRouteData
    with $OnboardingStudyGoalRouteData {
  const OnboardingStudyGoalRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StudyGoalSetupScreen();
  }
}

@TypedGoRoute<StudyRouteData>(
  path: '/study',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<StudySetupRouteData>(path: 'setup'),
    TypedGoRoute<StudySessionRouteData>(path: 'session'),
    TypedGoRoute<StudyResultRouteData>(path: 'result'),
    TypedGoRoute<StudyHistoryRouteData>(path: 'history'),
    TypedGoRoute<StudyModePickerRouteData>(path: 'mode-picker'),
  ],
)
class StudyRouteData extends GoRouteData with $StudyRouteData {
  const StudyRouteData();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return const StudySetupRouteData().location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudySetupScreen(
      onStartSession: () => const StudySessionRouteData().push(context),
      onOpenModePicker: () => const StudyModePickerRouteData().push(context),
      onOpenHistory: () => const StudyHistoryRouteData().push(context),
    );
  }
}

class StudySetupRouteData extends GoRouteData with $StudySetupRouteData {
  const StudySetupRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudySetupScreen(
      onStartSession: () => const StudySessionRouteData().push(context),
      onOpenModePicker: () => const StudyModePickerRouteData().push(context),
      onOpenHistory: () => const StudyHistoryRouteData().push(context),
    );
  }
}

class StudySessionRouteData extends GoRouteData with $StudySessionRouteData {
  const StudySessionRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudySessionScreen(
      onOpenModePicker: () => const StudyModePickerRouteData().push(context),
      onOpenResult: () => const StudyResultRouteData().go(context),
      onExit: () {
        if (!RouteUtils.popIfPossible(context)) {
          const DecksRouteData().go(context);
        }
      },
    );
  }
}

class StudyResultRouteData extends GoRouteData with $StudyResultRouteData {
  const StudyResultRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudyResultScreen(
      onRestartSession: () => const StudySessionRouteData().go(context),
      onOpenHistory: () => const StudyHistoryRouteData().push(context),
      onReturnToDeck: () {
        if (!RouteUtils.popIfPossible(context)) {
          const DecksRouteData().go(context);
        }
      },
    );
  }
}

class StudyHistoryRouteData extends GoRouteData with $StudyHistoryRouteData {
  const StudyHistoryRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StudyHistoryScreen();
  }
}

class StudyModePickerRouteData extends GoRouteData
    with $StudyModePickerRouteData {
  const StudyModePickerRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StudyModePickerScreen(
      onModeSelected: (_) {
        RouteUtils.popIfPossible(context);
      },
    );
  }
}

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<DashboardBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DashboardRouteData>(path: '/'),
      ],
    ),
    TypedStatefulShellBranch<FoldersBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<FoldersRouteData>(
          path: '/folders',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<FolderDetailRouteData>(
              path: ':folderId',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<FolderDecksRouteData>(
                  path: 'decks',
                  routes: <TypedRoute<RouteData>>[
                    TypedGoRoute<DeckDetailRouteData>(path: ':deckId'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<DecksBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DecksRouteData>(path: '/decks'),
      ],
    ),
    TypedStatefulShellBranch<ProgressBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProgressRouteData>(
          path: '/progress',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ProgressCalendarRouteData>(path: 'calendar'),
            TypedGoRoute<DeckProgressRouteData>(path: 'decks/:deckId'),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SettingsRouteData>(
          path: '/settings',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<ThemeSettingsRouteData>(path: 'theme'),
            TypedGoRoute<LanguageSettingsRouteData>(path: 'language'),
            TypedGoRoute<AudioSettingsRouteData>(path: 'audio'),
            TypedGoRoute<BackupRestoreRouteData>(path: 'backup-restore'),
            TypedGoRoute<ReminderSettingsRouteData>(
              path: 'reminders',
              routes: <TypedRoute<RouteData>>[
                TypedGoRoute<ReminderTimeSlotsRouteData>(path: 'time-slots'),
                TypedGoRoute<ReminderPreviewRouteData>(path: 'preview'),
              ],
            ),
            TypedGoRoute<AboutRouteData>(path: 'about'),
          ],
        ),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AppShell(navigationShell: navigationShell);
  }
}

class DashboardBranchData extends StatefulShellBranchData {
  const DashboardBranchData();
}

class FoldersBranchData extends StatefulShellBranchData {
  const FoldersBranchData();
}

class DecksBranchData extends StatefulShellBranchData {
  const DecksBranchData();
}

class ProgressBranchData extends StatefulShellBranchData {
  const ProgressBranchData();
}

class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();
}

class DashboardRouteData extends GoRouteData with $DashboardRouteData {
  const DashboardRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeContent();
  }
}

class FoldersRouteData extends GoRouteData with $FoldersRouteData {
  const FoldersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FolderScreen();
  }
}

class FolderDetailRouteData extends GoRouteData with $FolderDetailRouteData {
  const FolderDetailRouteData({required this.folderId});

  final int folderId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FolderScreen();
  }
}

class FolderDecksRouteData extends GoRouteData with $FolderDecksRouteData {
  const FolderDecksRouteData({required this.folderId});

  final int folderId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeckScreen(folderId: folderId);
  }
}

class DeckDetailRouteData extends GoRouteData with $DeckDetailRouteData {
  const DeckDetailRouteData({
    required this.folderId,
    required this.deckId,
    this.deckName,
  });

  final int folderId;
  final int deckId;
  final String? deckName;

  @override
  String get location {
    final String baseLocation = GoRouteData.$location(
      '/folders/${Uri.encodeComponent(folderId.toString())}/decks/${Uri.encodeComponent(deckId.toString())}',
    );
    final String? normalizedDeckName = StringUtils.trimmedOrNull(deckName);
    if (normalizedDeckName == null || normalizedDeckName.isEmpty) {
      return baseLocation;
    }
    return Uri.parse(baseLocation)
        .replace(
          queryParameters: <String, String>{'deckName': normalizedDeckName},
        )
        .toString();
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final String resolvedDeckName =
        state.uri.queryParameters['deckName'] ?? deckName ?? '';
    return FlashcardScreen(deckId: deckId, deckName: resolvedDeckName);
  }
}

class DecksRouteData extends GoRouteData with $DecksRouteData {
  const DecksRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DeckListScreen();
  }
}

class ProgressRouteData extends GoRouteData with $ProgressRouteData {
  const ProgressRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StudyProgressScreen();
  }
}

class ProgressCalendarRouteData extends GoRouteData
    with $ProgressCalendarRouteData {
  const ProgressCalendarRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StudyCalendarScreen();
  }
}

class DeckProgressRouteData extends GoRouteData with $DeckProgressRouteData {
  const DeckProgressRouteData({required this.deckId});

  final int deckId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DeckProgressScreen(deckId: deckId);
  }
}

class SettingsRouteData extends GoRouteData with $SettingsRouteData {
  const SettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileContent();
  }
}

class ThemeSettingsRouteData extends GoRouteData with $ThemeSettingsRouteData {
  const ThemeSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ThemeSettingsScreen();
  }
}

class LanguageSettingsRouteData extends GoRouteData
    with $LanguageSettingsRouteData {
  const LanguageSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LanguageSettingsScreen();
  }
}

class AudioSettingsRouteData extends GoRouteData with $AudioSettingsRouteData {
  const AudioSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AudioSettingsScreen();
  }
}

class BackupRestoreRouteData extends GoRouteData with $BackupRestoreRouteData {
  const BackupRestoreRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BackupRestoreScreen();
  }
}

class ReminderSettingsRouteData extends GoRouteData
    with $ReminderSettingsRouteData {
  const ReminderSettingsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReminderSettingsScreen();
  }
}

class ReminderTimeSlotsRouteData extends GoRouteData
    with $ReminderTimeSlotsRouteData {
  const ReminderTimeSlotsRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReminderTimeSlotsScreen();
  }
}

class ReminderPreviewRouteData extends GoRouteData
    with $ReminderPreviewRouteData {
  const ReminderPreviewRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ReminderPreviewScreen();
  }
}

class AboutRouteData extends GoRouteData with $AboutRouteData {
  const AboutRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutScreen();
  }
}

@TypedGoRoute<OfflineRouteData>(path: '/offline')
class OfflineRouteData extends GoRouteData with $OfflineRouteData {
  const OfflineRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LumosOfflineScreen();
  }
}

@TypedGoRoute<MaintenanceRouteData>(path: '/maintenance')
class MaintenanceRouteData extends GoRouteData with $MaintenanceRouteData {
  const MaintenanceRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LumosMaintenanceScreen();
  }
}

@TypedGoRoute<NotFoundRouteData>(path: '/not-found')
class NotFoundRouteData extends GoRouteData with $NotFoundRouteData {
  const NotFoundRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LumosNotFoundScreen();
  }
}
