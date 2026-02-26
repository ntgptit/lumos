import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LumosSnackbarType { info, success, warning, error }

enum LumosAnswerMode { typing, speaking, multipleChoice }

enum FlashcardStatus { unanswered, correct, incorrect }

enum ReviewRating { again, hard, good, easy }

enum LumosCelebrationType { confetti, fireworks, sparkles }

enum LumosTipType { tip, encouragement, fact }

enum SkillNodeStatus { locked, available, inProgress, completed, mastered }

enum LumosConfettiType { simple, full }

@immutable
class LumosTab {
  const LumosTab({required this.label, this.icon});

  final String label;
  final IconData? icon;
}

@immutable
class LumosActionItem {
  const LumosActionItem({
    required this.label,
    this.icon,
    this.onPressed,
    this.isDestructive = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isDestructive;
}

@immutable
class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.promptText,
    this.translation,
    this.pronunciation,
    this.imageUrl,
  });

  final String id;
  final String promptText;
  final String? translation;
  final String? pronunciation;
  final String? imageUrl;
}

@immutable
class FlashcardResult {
  const FlashcardResult({required this.cardId, required this.isCorrect});

  final String cardId;
  final bool isCorrect;
}

@immutable
class PairItem {
  const PairItem({required this.id, required this.label});

  final String id;
  final String label;
}

@immutable
class MatchedPair {
  const MatchedPair({required this.leftId, required this.rightId});

  final String leftId;
  final String rightId;
}

@immutable
class SkillNodeData {
  const SkillNodeData({
    required this.id,
    required this.title,
    required this.status,
    this.progress,
    this.xpReward,
  });

  final String id;
  final String title;
  final SkillNodeStatus status;
  final double? progress;
  final int? xpReward;
}

@immutable
class GoalOption {
  const GoalOption({
    required this.label,
    required this.value,
    this.description,
  });

  final String label;
  final int value;
  final String? description;
}

@immutable
class TestQuestion {
  const TestQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
}

@immutable
class TestResult {
  const TestResult({
    required this.totalQuestions,
    required this.correctAnswers,
  });

  final int totalQuestions;
  final int correctAnswers;
}

@immutable
class DueCardPreview {
  const DueCardPreview({required this.id, required this.title});

  final String id;
  final String title;
}
