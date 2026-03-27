enum LoadingStatus {
  idle,
  loading,
  success,
  error;

  bool get isIdle => this == LoadingStatus.idle;
  bool get isLoading => this == LoadingStatus.loading;
  bool get isSuccess => this == LoadingStatus.success;
  bool get isError => this == LoadingStatus.error;
  bool get isTerminal => isSuccess || isError;
}
