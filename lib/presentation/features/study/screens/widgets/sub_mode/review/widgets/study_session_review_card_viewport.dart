import 'package:flutter/material.dart';

import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import 'study_session_review_card_deck.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionReviewCardViewport extends StatelessWidget {
  const StudySessionReviewCardViewport({
    required this.session,
    required this.speechPlaybackState,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    required this.canSwipeHorizontally,
    required this.controller,
    required this.itemCount,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.onLeadingEdgeAttempt,
    super.key,
  });

  final StudySessionData session;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;
  final bool canSwipeHorizontally;
  final PageController controller;
  final int itemCount;
  final int currentPageIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onLeadingEdgeAttempt;

  @override
  Widget build(BuildContext context) {
    final Widget cards = StudySessionReviewCardDeck(
      session: session,
      speechPlaybackState: speechPlaybackState,
      onPlaySpeech: onPlaySpeech,
      onReplaySpeech: onReplaySpeech,
    );
    if (!canSwipeHorizontally) {
      return cards;
    }
    return LumosHorizontalPager(
      controller: controller,
      itemCount: itemCount,
      onPageChanged: onPageChanged,
      onLeadingEdgeAttempt: onLeadingEdgeAttempt,
      itemBuilder: (BuildContext contextValue, int index) {
        if (index == currentPageIndex) {
          return cards;
        }
        return const SizedBox.shrink();
      },
    );
  }
}
