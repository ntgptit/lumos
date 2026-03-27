import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class FolderListScreen extends StatelessWidget {
  const FolderListScreen({this.folderId, super.key});

  final int? folderId;

  @override
  Widget build(BuildContext context) {
    final String? message = folderId == null
        ? 'Folder list adapter is active.'
        : 'Folder detail adapter is active for folder $folderId.';
    return AppPlaceholderScreen(title: 'Folders', message: message);
  }
}
