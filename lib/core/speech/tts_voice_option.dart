import 'package:flutter/foundation.dart';

@immutable
class TtsVoiceOption {
  const TtsVoiceOption({
    required this.id,
    required this.label,
    required this.locale,
  });

  final String id;
  final String label;
  final String locale;
}
