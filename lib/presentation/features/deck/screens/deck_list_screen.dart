import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({this.folderId, super.key});

  final int? folderId;

  @override
  Widget build(BuildContext context) {
    final String message = folderId == null
        ? context.l10n.placeholderDeckListMessage
        : context.l10n.placeholderDeckListInFolderMessage(folderId!);
    return LumosPlaceholderScreen(
      title: context.l10n.placeholderDeckListTitle,
      message: message,
    );
  }
}
