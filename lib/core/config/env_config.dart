import 'package:flutter/foundation.dart';
import 'package:lumos/core/config/app_strings.dart';

const _appFlavorEnv = String.fromEnvironment(
  'APP_FLAVOR',
  defaultValue: 'development',
);
const _appNameEnv = String.fromEnvironment('APP_NAME', defaultValue: '');
const _apiBaseUrlEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
const _enableNetworkLogsEnv = String.fromEnvironment(
  'ENABLE_NETWORK_LOGS',
  defaultValue: '',
);
const _enableProviderLogsEnv = String.fromEnvironment(
  'ENABLE_PROVIDER_LOGS',
  defaultValue: '',
);
const _enableRouterLogsEnv = String.fromEnvironment(
  'ENABLE_ROUTER_LOGS',
  defaultValue: '',
);
const _showEnvBannerEnv = String.fromEnvironment(
  'SHOW_ENV_BANNER',
  defaultValue: '',
);
const _showPerformanceOverlayEnv = String.fromEnvironment(
  'SHOW_PERFORMANCE_OVERLAY',
  defaultValue: '',
);
const _showDebugBannerEnv = String.fromEnvironment(
  'SHOW_DEBUG_BANNER',
  defaultValue: '',
);

enum AppFlavor {
  development('development'),
  staging('staging'),
  production('production');

  const AppFlavor(this.value);

  final String value;

  static AppFlavor fromValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dev':
      case 'development':
        return AppFlavor.development;
      case 'stage':
      case 'production':
      case 'staging':
        return value.trim().toLowerCase() == 'production'
            ? AppFlavor.production
            : AppFlavor.staging;
      case 'prod':
        return AppFlavor.production;
      default:
        return AppFlavor.development;
    }
  }
}

@immutable
class EnvConfig {
  const EnvConfig({
    required this.appName,
    required this.flavor,
    required this.baseUrl,
    required this.enableNetworkLogs,
    required this.enableProviderLogs,
    required this.enableRouterLogs,
    required this.showEnvironmentBanner,
    required this.showPerformanceOverlay,
    required this.showDebugBanner,
  });

  factory EnvConfig.fromEnvironment() {
    final flavor = AppFlavor.fromValue(_appFlavorEnv);

    return EnvConfig(
      appName: _resolveString(_appNameEnv, fallback: AppStrings.appName),
      flavor: flavor,
      baseUrl: _readBaseUrl(),
      enableNetworkLogs: _resolveBool(
        _enableNetworkLogsEnv,
        fallback: kDebugMode || flavor != AppFlavor.production,
      ),
      enableProviderLogs: _resolveBool(
        _enableProviderLogsEnv,
        fallback: kDebugMode,
      ),
      enableRouterLogs: _resolveBool(
        _enableRouterLogsEnv,
        fallback: kDebugMode,
      ),
      showEnvironmentBanner: _resolveBool(
        _showEnvBannerEnv,
        fallback: flavor != AppFlavor.production,
      ),
      showPerformanceOverlay: _resolveBool(
        _showPerformanceOverlayEnv,
        fallback: false,
      ),
      showDebugBanner: _resolveBool(_showDebugBannerEnv, fallback: false),
    );
  }

  final String appName;
  final AppFlavor flavor;
  final String baseUrl;
  final bool enableNetworkLogs;
  final bool enableProviderLogs;
  final bool enableRouterLogs;
  final bool showEnvironmentBanner;
  final bool showPerformanceOverlay;
  final bool showDebugBanner;

  bool get isProduction => flavor == AppFlavor.production;
  bool get isDevelopment => flavor == AppFlavor.development;
  bool get isStaging => flavor == AppFlavor.staging;

  String get environmentLabel {
    switch (flavor) {
      case AppFlavor.development:
        return AppStrings.developmentLabel;
      case AppFlavor.staging:
        return AppStrings.stagingLabel;
      case AppFlavor.production:
        return AppStrings.productionLabel;
    }
  }

  Uri get baseUri => Uri.parse(baseUrl);

  @override
  String toString() {
    return 'EnvConfig(appName: $appName, flavor: ${flavor.value}, baseUrl: $baseUrl)';
  }
}

String _resolveString(String rawValue, {required String fallback}) {
  final value = rawValue.trim();
  if (value.isEmpty) {
    return fallback;
  }

  return value;
}

bool _resolveBool(String rawValue, {required bool fallback}) {
  final raw = rawValue.trim().toLowerCase();
  switch (raw) {
    case 'true':
    case '1':
    case 'yes':
    case 'y':
    case 'on':
      return true;
    case 'false':
    case '0':
    case 'no':
    case 'n':
    case 'off':
      return false;
    default:
      return fallback;
  }
}

String _readBaseUrl() {
  final value = _resolveString(
    _apiBaseUrlEnv,
    fallback: 'http://localhost:8080',
  );
  final uri = Uri.tryParse(value);

  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    throw FormatException('Invalid API_BASE_URL: $value');
  }

  return uri.replace(path: _normalizePath(uri.path)).toString();
}

String _normalizePath(String path) {
  if (path.isEmpty || path == '/') {
    return '';
  }

  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}
