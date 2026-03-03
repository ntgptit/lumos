import 'package:flutter/material.dart';

import '../../../../../../domain/entities/flashcard_models.dart';
import 'flashcard_content_card.dart';

class FlashcardTile extends StatelessWidget {
  const FlashcardTile({
    required this.item,
    required this.isStarred,
    required this.isAudioPlaying,
    required this.onAudioPressed,
    required this.onStarPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final FlashcardNode item;
  final bool isStarred;
  final bool isAudioPlaying;
  final VoidCallback onAudioPressed;
  final VoidCallback onStarPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return FlashcardContentCard(
      item: item,
      isStarred: isStarred,
      isAudioPlaying: isAudioPlaying,
      onAudioPressed: onAudioPressed,
      onStarPressed: onStarPressed,
      onEditPressed: onEditPressed,
      onDeletePressed: onDeletePressed,
    );
  }
}
