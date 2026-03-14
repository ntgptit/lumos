import 'dart:io';

import 'package:yaml/yaml.dart';

class GuardProjectProfile {
  const GuardProjectProfile({
    required this.packageName,
    required this.widgetClassPrefix,
    required this.widgetFilePrefix,
  });

  static const String _pubspecPath = 'pubspec.yaml';
  static const String _configPath =
      'tool/guards/contracts/guard_project_profile.yaml';
  static const String _fallbackPackageName = 'app';
  static const String _widgetFilePrefixToken = '{{widget_file_prefix}}';

  final String packageName;
  final String widgetClassPrefix;
  final String widgetFilePrefix;

  static GuardProjectProfile load() {
    final YamlMap? configDocument = _loadYamlDocument(path: _configPath);
    final YamlMap? pubspecDocument = _loadYamlDocument(path: _pubspecPath);

    final String packageName = _readConfiguredValue(
      document: configDocument,
      keys: const <String>['packageName', 'package_name'],
    );
    final String resolvedPackageName = packageName.isNotEmpty
        ? _normalizePackageName(packageName)
        : _resolvePackageNameFromPubspec(document: pubspecDocument);
    final String widgetClassPrefix = _resolveWidgetClassPrefix(
      document: configDocument,
      packageName: resolvedPackageName,
    );
    final String widgetFilePrefix = _resolveWidgetFilePrefix(
      document: configDocument,
      packageName: resolvedPackageName,
    );
    return GuardProjectProfile(
      packageName: resolvedPackageName,
      widgetClassPrefix: widgetClassPrefix,
      widgetFilePrefix: widgetFilePrefix,
    );
  }

  String packageImportPrefix() {
    return 'package:$packageName/';
  }

  String widgetName(String suffix) {
    return '$widgetClassPrefix$suffix';
  }

  String widgetAlternatives(List<String> suffixes) {
    return suffixes.map(widgetName).join('/');
  }

  String widgetFilePath({required String directory, required String suffix}) {
    final String baseName = widgetFileName(suffix);
    return '$directory/$baseName';
  }

  String widgetFileName(String suffix) {
    if (widgetFilePrefix.isEmpty) {
      return suffix;
    }
    return '${widgetFilePrefix}_$suffix';
  }

  String expandWidgetFilePrefixToken(String value) {
    return value.replaceAll(_widgetFilePrefixToken, widgetFilePrefix);
  }

  RegExp widgetInvocationPattern() {
    return RegExp('\\b${RegExp.escape(widgetClassPrefix)}[A-Z]\\w*\\s*\\(');
  }

  RegExp widgetCapturePattern() {
    return RegExp('\\b(${RegExp.escape(widgetClassPrefix)}[A-Z]\\w*)\\s*\\(');
  }

  static YamlMap? _loadYamlDocument({required String path}) {
    final File file = File(path);
    if (!file.existsSync()) {
      return null;
    }

    final dynamic document = loadYaml(file.readAsStringSync());
    if (document is! YamlMap) {
      return null;
    }

    return document;
  }

  static String _resolvePackageNameFromPubspec({required YamlMap? document}) {
    if (document == null) {
      return _fallbackPackageName;
    }

    final dynamic rawValue = document['name'];
    if (rawValue is! String) {
      return _fallbackPackageName;
    }

    final String normalizedValue = _normalizePackageName(rawValue);
    if (normalizedValue.isEmpty) {
      return _fallbackPackageName;
    }

    return normalizedValue;
  }

  static String _resolveWidgetClassPrefix({
    required YamlMap? document,
    required String packageName,
  }) {
    final String configuredValue = _readConfiguredValue(
      document: document,
      keys: const <String>['widgetClassPrefix', 'widget_class_prefix'],
    );
    if (configuredValue.isNotEmpty) {
      return configuredValue.trim();
    }

    return _toPascalCase(packageName);
  }

  static String _resolveWidgetFilePrefix({
    required YamlMap? document,
    required String packageName,
  }) {
    final String configuredValue = _readConfiguredValue(
      document: document,
      keys: const <String>['widgetFilePrefix', 'widget_file_prefix'],
    );
    if (configuredValue.isNotEmpty) {
      return _normalizePackageName(configuredValue);
    }

    return packageName;
  }

  static String _readConfiguredValue({
    required YamlMap? document,
    required List<String> keys,
  }) {
    if (document == null) {
      return '';
    }

    for (final String key in keys) {
      final dynamic rawValue = document[key];
      if (rawValue is! String) {
        continue;
      }

      final String trimmedValue = rawValue.trim();
      if (trimmedValue.isEmpty) {
        continue;
      }

      return trimmedValue;
    }

    return '';
  }

  static String _normalizePackageName(String value) {
    return value.trim().replaceAll('-', '_');
  }

  static String _toPascalCase(String value) {
    final List<String> parts = value
        .split(RegExp(r'[_\-\s]+'))
        .where((String part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return 'App';
    }

    return parts.map((String part) {
      final String normalizedPart = part.toLowerCase();
      final String firstCharacter = normalizedPart[0].toUpperCase();
      final String remainder = normalizedPart.substring(1);
      return '$firstCharacter$remainder';
    }).join();
  }
}
