import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class DeckProgressScreen extends StatelessWidget {
  const DeckProgressScreen({required this.deckId, super.key});

  final int deckId;

  @override
  Widget build(BuildContext context) {
    return AppPlaceholderScreen(
      title: 'Deck Progress',
      message: 'Deck $deckId progress adapter is active.',
    );
  }
}
