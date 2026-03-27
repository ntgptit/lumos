import 'package:lumos/core/services/bottom_sheet_service.dart';
import 'package:lumos/core/di/core_providers.dart';
import 'package:lumos/core/services/analytics_service.dart';
import 'package:lumos/core/services/audio_service.dart';
import 'package:lumos/core/services/clock_service.dart';
import 'package:lumos/core/services/connectivity_service.dart';
import 'package:lumos/core/services/crashlytics_service.dart';
import 'package:lumos/core/services/dialog_service.dart';
import 'package:lumos/core/services/file_picker_service.dart';
import 'package:lumos/core/services/local_notification_service.dart';
import 'package:lumos/core/services/navigation_service.dart';
import 'package:lumos/core/services/notification_service.dart';
import 'package:lumos/core/services/permission_service.dart';
import 'package:lumos/core/services/review_service.dart';
import 'package:lumos/core/services/share_service.dart';
import 'package:lumos/core/services/snackbar_service.dart';
import 'package:lumos/core/services/text_to_speech_service.dart';
import 'package:lumos/core/services/vibration_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.g.dart';

@Riverpod(keepAlive: true)
ClockService clockService(Ref ref) {
  return const SystemClockService();
}

@Riverpod(keepAlive: true)
NavigationService navigationService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return NavigationService(navigatorKey);
}

@Riverpod(keepAlive: true)
DialogService dialogService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return DialogService(navigatorKey);
}

@Riverpod(keepAlive: true)
BottomSheetService bottomSheetService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return BottomSheetService(navigatorKey);
}

@Riverpod(keepAlive: true)
SnackbarService snackbarService(Ref ref) {
  final messengerKey = ref.watch(rootScaffoldMessengerKeyProvider);
  return SnackbarService(messengerKey);
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return const NoopAnalyticsService();
}

@Riverpod(keepAlive: true)
CrashlyticsService crashlyticsService(Ref ref) {
  return const NoopCrashlyticsService();
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return DefaultConnectivityService(networkInfo);
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return const NoopNotificationService();
}

@Riverpod(keepAlive: true)
LocalNotificationService localNotificationService(Ref ref) {
  return const LocalNotificationService();
}

@Riverpod(keepAlive: true)
AudioService audioService(Ref ref) {
  return const NoopAudioService();
}

@Riverpod(keepAlive: true)
TextToSpeechService textToSpeechService(Ref ref) {
  return const NoopTextToSpeechService();
}

@Riverpod(keepAlive: true)
VibrationService vibrationService(Ref ref) {
  return const NoopVibrationService();
}

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) {
  return const NoopPermissionService();
}

@Riverpod(keepAlive: true)
FilePickerService filePickerService(Ref ref) {
  return const NoopFilePickerService();
}

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) {
  return const NoopShareService();
}

@Riverpod(keepAlive: true)
ReviewService reviewService(Ref ref) {
  return const NoopReviewService();
}
