import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class StudyCalendarScreen extends StatelessWidget {
  const StudyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LumosPlaceholderScreen(
      title: context.l10n.placeholderStudyCalendarTitle,
    );
  }
}
