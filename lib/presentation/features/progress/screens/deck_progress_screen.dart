import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class DeckProgressScreen extends StatelessWidget {
  const DeckProgressScreen({required this.deckId, super.key});

  final int deckId;

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: context.l10n.placeholderDeckProgressTitle,
      message: context.l10n.placeholderDeckProgressMessage(deckId),
    );
  }
}
