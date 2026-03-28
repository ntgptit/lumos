import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class DeckDetailScreen extends StatelessWidget {
  const DeckDetailScreen({
    required this.folderId,
    required this.deckId,
    super.key,
  });

  final int folderId;
  final int deckId;

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: 'Deck Detail',
      message: 'Folder $folderId, deck $deckId.',
    );
  }
}
