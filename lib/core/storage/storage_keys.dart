abstract final class StorageKeys {
  static const authToken = 'auth_token';
  static const accessToken = authToken;
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const themeType = 'theme_type';
  static const locale = 'app_locale';
  static const onboardingSeen = 'onboarding_seen';
  static const lastKnownBaseUrl = 'last_known_base_url';
  static const ttsEnabled = 'tts_enabled';
  static const reviewSoundsEnabled = 'review_sounds_enabled';
  static const hapticsEnabled = 'haptics_enabled';
  static const cloudBackupEnabled = 'cloud_backup_enabled';
  static const lastBackupAt = 'last_backup_at';
  static const all = <String>{
    authToken,
    refreshToken,
    userId,
    themeType,
    locale,
    onboardingSeen,
    lastKnownBaseUrl,
    ttsEnabled,
    reviewSoundsEnabled,
    hapticsEnabled,
    cloudBackupEnabled,
    lastBackupAt,
  };
}
