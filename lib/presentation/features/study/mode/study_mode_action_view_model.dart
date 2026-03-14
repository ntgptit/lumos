import 'package:flutter/material.dart';

import 'study_mode_action_button_style.dart';

class StudyModeActionViewModel {
  const StudyModeActionViewModel({
    required this.actionId,
    required this.label,
    required this.style,
    this.icon,
  });

  final String actionId;
  final String label;
  final StudyModeActionButtonStyle style;
  final IconData? icon;
}
