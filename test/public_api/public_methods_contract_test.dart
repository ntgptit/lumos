import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const inventoryPath = 'tool/reports/public_methods_inventory.md';

  group('FE Public Methods Contract', () {
    final inventory = _loadInventory(inventoryPath);
    final sourceCache = <String, String>{};

    for (final entry in inventory.feEntries) {
      test('${entry.filePath} :: ${entry.signature}', () {
        final file = File(entry.filePath);
        expect(file.existsSync(), isTrue, reason: 'Missing source file: ${entry.filePath}');

        final source = sourceCache.putIfAbsent(entry.filePath, file.readAsStringSync);
        final tokens = _signatureTokens(entry.signature);
        expect(tokens.isNotEmpty, isTrue, reason: 'Cannot derive tokens for ${entry.signature}');

        final hasAnyToken = tokens.any(source.contains);
        expect(
          hasAnyToken,
          isTrue,
          reason: 'No token from ${tokens.join(', ')} found in ${entry.filePath} for ${entry.signature}',
        );
      });
    }
  });
}

_Inventory _loadInventory(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    fail('Inventory file not found: $path');
  }

  final lines = file.readAsLinesSync();
  final feEntries = <_MethodEntry>[];
  var inFeSection = false;
  var currentFilePath = '';
  final headingPattern = RegExp(r'^### `(.+)`$');
  final methodPattern = RegExp(r'^- L\d+: `(.+)` \((.+)\)$');

  for (final line in lines) {
    if (line == '## FE (Dart)') {
      inFeSection = true;
      continue;
    }
    if (line == '## BE (Java)') {
      inFeSection = false;
      continue;
    }
    if (!inFeSection) {
      continue;
    }

    final headingMatch = headingPattern.firstMatch(line);
    if (headingMatch != null) {
      currentFilePath = headingMatch.group(1)!;
      continue;
    }

    final methodMatch = methodPattern.firstMatch(line);
    if (methodMatch == null) {
      continue;
    }

    final signature = methodMatch.group(1)!;
    feEntries.add(_MethodEntry(currentFilePath, signature));
  }

  return _Inventory(feEntries);
}

List<String> _signatureTokens(String signature) {
  final normalized = signature.replaceAll('(top-level).', '');
  final segments = normalized.split('.');
  if (segments.isEmpty) {
    return const <String>[];
  }

  final methodSegment = segments.last;
  final constructorToken = methodSegment.replaceAll('()', '');
  final classToken = segments.first;
  final tokens = <String>{};

  if (methodSegment == '==') {
    tokens.add('operator ==');
  }

  if (constructorToken.isNotEmpty) {
    tokens.add(constructorToken);
  }

  if (classToken.isNotEmpty) {
    tokens.add(classToken);
  }

  final genericToken = methodSegment.replaceAll(RegExp(r'[^A-Za-z0-9_=]'), '');
  if (genericToken.isNotEmpty) {
    tokens.add(genericToken);
  }

  return tokens.toList();
}

final class _Inventory {
  const _Inventory(this.feEntries);

  final List<_MethodEntry> feEntries;
}

final class _MethodEntry {
  const _MethodEntry(this.filePath, this.signature);

  final String filePath;
  final String signature;
}
