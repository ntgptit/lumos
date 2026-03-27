import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({this.folderId, super.key});

  final int? folderId;

  @override
  Widget build(BuildContext context) {
    final String? message = folderId == null
        ? 'Deck list adapter is active.'
        : 'Deck list adapter is active for folder $folderId.';
    return AppPlaceholderScreen(title: 'Decks', message: message);
  }
}
