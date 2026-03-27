enum DialogType {
  info,
  warning,
  error,
  confirm;

  bool get isDestructive => this == DialogType.error;

  bool get needsExplicitAction {
    return this == DialogType.confirm || this == DialogType.error;
  }
}
