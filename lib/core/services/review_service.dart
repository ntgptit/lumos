abstract interface class ReviewService {
  Future<bool> isAvailable();

  Future<void> requestReview();
}

class NoopReviewService implements ReviewService {
  const NoopReviewService();

  @override
  Future<bool> isAvailable() async {
    return false;
  }

  @override
  Future<void> requestReview() async {}
}
