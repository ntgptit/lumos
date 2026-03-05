import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'states/flashcard_dialog_form_state.dart';

part 'flashcard_dialog_form_provider.g.dart';

@Riverpod(keepAlive: false)
class FlashcardDialogFormController extends _$FlashcardDialogFormController {
  late final TextEditingController _frontTextController;
  late final TextEditingController _backTextController;

  @override
  FlashcardDialogFormState build(
    String initialFrontText,
    String initialBackText,
  ) {
    _frontTextController = TextEditingController(text: initialFrontText);
    _backTextController = TextEditingController(text: initialBackText);

    _frontTextController.addListener(_syncFrontTextState);
    _backTextController.addListener(_syncBackTextState);

    ref.onDispose(() {
      _frontTextController.removeListener(_syncFrontTextState);
      _backTextController.removeListener(_syncBackTextState);
      _frontTextController.dispose();
      _backTextController.dispose();
    });

    return FlashcardDialogFormState(
      frontText: initialFrontText,
      backText: initialBackText,
      isSubmitting: false,
    );
  }

  TextEditingController get frontTextController {
    return _frontTextController;
  }

  TextEditingController get backTextController {
    return _backTextController;
  }

  void startSubmitting() {
    if (state.isSubmitting) {
      return;
    }
    state = state.copyWith(isSubmitting: true);
  }

  void stopSubmitting() {
    if (!state.isSubmitting) {
      return;
    }
    state = state.copyWith(isSubmitting: false);
  }

  void _syncFrontTextState() {
    final String nextValue = _frontTextController.text;
    if (state.frontText == nextValue) {
      return;
    }
    state = state.copyWith(frontText: nextValue);
  }

  void _syncBackTextState() {
    final String nextValue = _backTextController.text;
    if (state.backText == nextValue) {
      return;
    }
    state = state.copyWith(backText: nextValue);
  }
}
