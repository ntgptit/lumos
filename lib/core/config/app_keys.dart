import 'package:lumos/core/storage/storage_keys.dart';

abstract final class AppKeys {
  static const rootNavigatorKeyLabel = 'rootNavigator';
  static const rootScaffoldMessengerKeyLabel = 'rootScaffoldMessenger';
  static const authTokenStorageKey = StorageKeys.authToken;
  static const refreshTokenStorageKey = StorageKeys.refreshToken;
  static const themeTypeStorageKey = StorageKeys.themeType;
  static const localeStorageKey = StorageKeys.locale;
  static const onboardingSeenStorageKey = StorageKeys.onboardingSeen;
  static const lastKnownBaseUrlStorageKey = StorageKeys.lastKnownBaseUrl;
  static const ttsEnabledStorageKey = StorageKeys.ttsEnabled;
  static const reviewSoundsEnabledStorageKey = StorageKeys.reviewSoundsEnabled;
  static const hapticsEnabledStorageKey = StorageKeys.hapticsEnabled;
  static const cloudBackupEnabledStorageKey = StorageKeys.cloudBackupEnabled;
  static const lastBackupAtStorageKey = StorageKeys.lastBackupAt;
}
