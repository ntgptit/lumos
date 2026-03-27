enum SnackbarType {
  success,
  error,
  info,
  warning;

  bool get isPositive => this == SnackbarType.success;
  bool get isNegative => this == SnackbarType.error;
  bool get isWarning => this == SnackbarType.warning;

  Duration get defaultDuration {
    switch (this) {
      case SnackbarType.error:
        return const Duration(seconds: 4);
      case SnackbarType.success:
      case SnackbarType.info:
      case SnackbarType.warning:
        return const Duration(seconds: 3);
    }
  }
}
