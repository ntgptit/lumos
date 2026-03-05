class FlashcardDialogFormState {
  const FlashcardDialogFormState({
    required this.frontText,
    required this.backText,
    required this.isSubmitting,
  });

  final String frontText;
  final String backText;
  final bool isSubmitting;

  FlashcardDialogFormState copyWith({
    String? frontText,
    String? backText,
    bool? isSubmitting,
  }) {
    return FlashcardDialogFormState(
      frontText: frontText ?? this.frontText,
      backText: backText ?? this.backText,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
