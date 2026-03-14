import 'package:flutter/foundation.dart';

@immutable
class ProfileSpeechPreviewState {
  const ProfileSpeechPreviewState({
    required this.isBusy,
    required this.isPlaying,
    required this.errorMessage,
  });

  const ProfileSpeechPreviewState.initial()
    : isBusy = false,
      isPlaying = false,
      errorMessage = null;

  final bool isBusy;
  final bool isPlaying;
  final String? errorMessage;

  ProfileSpeechPreviewState copyWith({
    bool? isBusy,
    bool? isPlaying,
    Object? errorMessage = _unsetProfileSpeechPreviewValue,
  }) {
    return ProfileSpeechPreviewState(
      isBusy: isBusy ?? this.isBusy,
      isPlaying: isPlaying ?? this.isPlaying,
      errorMessage: identical(errorMessage, _unsetProfileSpeechPreviewValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _unsetProfileSpeechPreviewValue = Object();
