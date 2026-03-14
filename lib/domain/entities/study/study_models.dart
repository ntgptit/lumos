import 'package:flutter/foundation.dart';

import 'study_speech_contract.dart';

enum StudySessionTypeOption {
  firstLearning('FIRST_LEARNING'),
  review('REVIEW');

  const StudySessionTypeOption(this.apiValue);

  final String apiValue;
}

@immutable
class StudyChoice {
  const StudyChoice({required this.id, required this.label});

  factory StudyChoice.fromJson(Map<String, dynamic> json) {
    return StudyChoice(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }

  final String id;
  final String label;
}

@immutable
class StudyMatchPair {
  const StudyMatchPair({
    required this.leftId,
    required this.leftLabel,
    required this.rightId,
    required this.rightLabel,
  });

  factory StudyMatchPair.fromJson(Map<String, dynamic> json) {
    return StudyMatchPair(
      leftId: json['leftId'] as String? ?? '',
      leftLabel: json['leftLabel'] as String? ?? '',
      rightId: json['rightId'] as String? ?? '',
      rightLabel: json['rightLabel'] as String? ?? '',
    );
  }

  final String leftId;
  final String leftLabel;
  final String rightId;
  final String rightLabel;
}

@immutable
class StudyMatchSubmission {
  const StudyMatchSubmission({required this.leftId, required this.rightId});

  final String leftId;
  final String rightId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'leftId': leftId, 'rightId': rightId};
  }
}

@immutable
class SpeechCapability {
  const SpeechCapability({
    required this.enabled,
    required this.autoPlay,
    required this.available,
    required this.adapter,
    required this.locale,
    required this.voice,
    required this.speed,
    required this.pitch,
    required this.fieldName,
    required this.sourceType,
    required this.audioUrl,
    required this.allowedActions,
    required this.speechText,
  });

  factory SpeechCapability.fromJson(Map<String, dynamic> json) {
    return SpeechCapability(
      enabled: json['enabled'] as bool? ?? false,
      autoPlay: json['autoPlay'] as bool? ?? false,
      available: json['available'] as bool? ?? false,
      adapter: json['adapter'] as String? ?? studySpeechAdapterFlutterTts,
      locale: json['locale'] as String? ?? '',
      voice: json['voice'] as String? ?? studySpeechVoiceUnspecified,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      pitch: (json['pitch'] as num?)?.toDouble() ?? 1,
      fieldName: json['fieldName'] as String? ?? '',
      sourceType: json['sourceType'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? '',
      allowedActions: ((json['allowedActions'] as List?) ?? const <dynamic>[])
          .cast<String>(),
      speechText: json['speechText'] as String? ?? '',
    );
  }

  final bool enabled;
  final bool autoPlay;
  final bool available;
  final String adapter;
  final String locale;
  final String voice;
  final double speed;
  final double pitch;
  final String fieldName;
  final String sourceType;
  final String audioUrl;
  final List<String> allowedActions;
  final String speechText;
}

@immutable
class StudySessionItemData {
  const StudySessionItemData({
    required this.flashcardId,
    required this.prompt,
    required this.answer,
    required this.note,
    required this.pronunciation,
    required this.instruction,
    required this.inputPlaceholder,
    required this.choices,
    required this.matchPairs,
    required this.speech,
  });

  factory StudySessionItemData.fromJson(Map<String, dynamic> json) {
    return StudySessionItemData(
      flashcardId: json['flashcardId'] as int? ?? 0,
      prompt: json['prompt'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      note: json['note'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
      inputPlaceholder: json['inputPlaceholder'] as String? ?? '',
      choices: ((json['choices'] as List?) ?? const <dynamic>[])
          .map(
            (dynamic item) =>
                StudyChoice.fromJson((item as Map).cast<String, dynamic>()),
          )
          .toList(growable: false),
      matchPairs: ((json['matchPairs'] as List?) ?? const <dynamic>[])
          .map(
            (dynamic item) =>
                StudyMatchPair.fromJson((item as Map).cast<String, dynamic>()),
          )
          .toList(growable: false),
      speech: SpeechCapability.fromJson(
        (json['speech'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
    );
  }

  final int flashcardId;
  final String prompt;
  final String answer;
  final String note;
  final String pronunciation;
  final String instruction;
  final String inputPlaceholder;
  final List<StudyChoice> choices;
  final List<StudyMatchPair> matchPairs;
  final SpeechCapability speech;
}

@immutable
class StudyProgressSummary {
  const StudyProgressSummary({
    required this.completedItems,
    required this.totalItems,
    required this.completedModes,
    required this.totalModes,
    required this.itemProgress,
    required this.modeProgress,
    required this.sessionProgress,
  });

  factory StudyProgressSummary.fromJson(Map<String, dynamic> json) {
    return StudyProgressSummary(
      completedItems: json['completedItems'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
      completedModes: json['completedModes'] as int? ?? 0,
      totalModes: json['totalModes'] as int? ?? 0,
      itemProgress: (json['itemProgress'] as num?)?.toDouble() ?? 0,
      modeProgress: (json['modeProgress'] as num?)?.toDouble() ?? 0,
      sessionProgress: (json['sessionProgress'] as num?)?.toDouble() ?? 0,
    );
  }

  final int completedItems;
  final int totalItems;
  final int completedModes;
  final int totalModes;
  final double itemProgress;
  final double modeProgress;
  final double sessionProgress;
}

@immutable
class StudySessionData {
  const StudySessionData({
    required this.sessionId,
    required this.deckId,
    required this.deckName,
    required this.sessionType,
    required this.activeMode,
    required this.modeState,
    required this.modePlan,
    required this.allowedActions,
    required this.progress,
    required this.currentItem,
    required this.sessionCompleted,
  });

  factory StudySessionData.fromJson(Map<String, dynamic> json) {
    return StudySessionData(
      sessionId: json['sessionId'] as int? ?? 0,
      deckId: json['deckId'] as int? ?? 0,
      deckName: json['deckName'] as String? ?? '',
      sessionType: json['sessionType'] as String? ?? '',
      activeMode: json['activeMode'] as String? ?? '',
      modeState: json['modeState'] as String? ?? '',
      modePlan: ((json['modePlan'] as List?) ?? const <dynamic>[])
          .cast<String>(),
      allowedActions: ((json['allowedActions'] as List?) ?? const <dynamic>[])
          .cast<String>(),
      progress: StudyProgressSummary.fromJson(
        (json['progress'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      currentItem: StudySessionItemData.fromJson(
        (json['currentItem'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      sessionCompleted: json['sessionCompleted'] as bool? ?? false,
    );
  }

  final int sessionId;
  final int deckId;
  final String deckName;
  final String sessionType;
  final String activeMode;
  final String modeState;
  final List<String> modePlan;
  final List<String> allowedActions;
  final StudyProgressSummary progress;
  final StudySessionItemData currentItem;
  final bool sessionCompleted;
}

@immutable
class ReminderRecommendation {
  const ReminderRecommendation({
    required this.deckId,
    required this.deckName,
    required this.dueCount,
    required this.overdueCount,
    required this.estimatedSessionMinutes,
    required this.recommendedSessionType,
  });

  factory ReminderRecommendation.fromJson(Map<String, dynamic> json) {
    return ReminderRecommendation(
      deckId: json['deckId'] as int? ?? 0,
      deckName: json['deckName'] as String? ?? '',
      dueCount: json['dueCount'] as int? ?? 0,
      overdueCount: json['overdueCount'] as int? ?? 0,
      estimatedSessionMinutes: json['estimatedSessionMinutes'] as int? ?? 0,
      recommendedSessionType: json['recommendedSessionType'] as String? ?? '',
    );
  }

  final int deckId;
  final String deckName;
  final int dueCount;
  final int overdueCount;
  final int estimatedSessionMinutes;
  final String recommendedSessionType;
}

@immutable
class StudyReminderSummary {
  const StudyReminderSummary({
    required this.dueCount,
    required this.overdueCount,
    required this.escalationLevel,
    required this.reminderTypes,
    required this.recommendation,
  });

  factory StudyReminderSummary.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? recommendationJson =
        (json['recommendation'] as Map?)?.cast<String, dynamic>();
    return StudyReminderSummary(
      dueCount: json['dueCount'] as int? ?? 0,
      overdueCount: json['overdueCount'] as int? ?? 0,
      escalationLevel: json['escalationLevel'] as String? ?? '',
      reminderTypes: ((json['reminderTypes'] as List?) ?? const <dynamic>[])
          .cast<String>(),
      recommendation: recommendationJson == null
          ? null
          : ReminderRecommendation.fromJson(recommendationJson),
    );
  }

  final int dueCount;
  final int overdueCount;
  final String escalationLevel;
  final List<String> reminderTypes;
  final ReminderRecommendation? recommendation;
}

@immutable
class StudyAnalyticsOverview {
  const StudyAnalyticsOverview({
    required this.totalLearnedItems,
    required this.dueCount,
    required this.overdueCount,
    required this.passedAttempts,
    required this.failedAttempts,
    required this.boxDistribution,
  });

  factory StudyAnalyticsOverview.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawBoxDistribution =
        (json['boxDistribution'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    return StudyAnalyticsOverview(
      totalLearnedItems: json['totalLearnedItems'] as int? ?? 0,
      dueCount: json['dueCount'] as int? ?? 0,
      overdueCount: json['overdueCount'] as int? ?? 0,
      passedAttempts: json['passedAttempts'] as int? ?? 0,
      failedAttempts: json['failedAttempts'] as int? ?? 0,
      boxDistribution: rawBoxDistribution.map(
        (String key, dynamic value) =>
            MapEntry(int.tryParse(key) ?? 0, value as int? ?? 0),
      ),
    );
  }

  final int totalLearnedItems;
  final int dueCount;
  final int overdueCount;
  final int passedAttempts;
  final int failedAttempts;
  final Map<int, int> boxDistribution;
}

@immutable
class SpeechPreference {
  const SpeechPreference({
    required this.enabled,
    required this.autoPlay,
    required this.adapter,
    required this.voice,
    required this.speed,
    required this.pitch,
    required this.locale,
  });

  factory SpeechPreference.fromJson(Map<String, dynamic> json) {
    return SpeechPreference(
      enabled: json['enabled'] as bool? ?? false,
      autoPlay: json['autoPlay'] as bool? ?? false,
      adapter: json['adapter'] as String? ?? studySpeechAdapterFlutterTts,
      voice: json['voice'] as String? ?? studySpeechVoiceUnspecified,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      pitch: (json['pitch'] as num?)?.toDouble() ?? 1,
      locale: json['locale'] as String? ?? '',
    );
  }

  final bool enabled;
  final bool autoPlay;
  final String adapter;
  final String voice;
  final double speed;
  final double pitch;
  final String locale;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'enabled': enabled,
      'autoPlay': autoPlay,
      'adapter': adapter,
      'voice': voice,
      'speed': speed,
      'pitch': pitch,
    };
  }

  SpeechPreference copyWith({
    bool? enabled,
    bool? autoPlay,
    String? adapter,
    String? voice,
    double? speed,
    double? pitch,
    String? locale,
  }) {
    return SpeechPreference(
      enabled: enabled ?? this.enabled,
      autoPlay: autoPlay ?? this.autoPlay,
      adapter: adapter ?? this.adapter,
      voice: voice ?? this.voice,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      locale: locale ?? this.locale,
    );
  }
}

@immutable
class StudyPreference {
  const StudyPreference({required this.firstLearningCardLimit});

  static const int minFirstLearningCardLimit = 1;
  static const int maxFirstLearningCardLimit = 100;

  factory StudyPreference.fromJson(Map<String, dynamic> json) {
    return StudyPreference(
      firstLearningCardLimit: json['firstLearningCardLimit'] as int? ?? 20,
    );
  }

  final int firstLearningCardLimit;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'firstLearningCardLimit': firstLearningCardLimit};
  }

  StudyPreference copyWith({int? firstLearningCardLimit}) {
    return StudyPreference(
      firstLearningCardLimit:
          firstLearningCardLimit ?? this.firstLearningCardLimit,
    );
  }
}
