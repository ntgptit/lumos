import 'package:flutter/material.dart';

enum LumosActionListItemTone { standard, critical }

class LumosActionListItem {
  const LumosActionListItem({
    required this.key,
    required this.label,
    required this.icon,
    this.supportingText,
    this.tone = LumosActionListItemTone.standard,
  });

  final String key;
  final String label;
  final IconData icon;
  final String? supportingText;
  final LumosActionListItemTone tone;
}
