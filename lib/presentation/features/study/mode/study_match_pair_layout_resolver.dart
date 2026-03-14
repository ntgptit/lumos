import '../../../../domain/entities/study/study_models.dart';

abstract final class StudyMatchPairLayoutResolver {
  StudyMatchPairLayoutResolver._();

  static List<StudyMatchPair> resolveRightColumnPairs({
    required List<StudyMatchPair> pairs,
    required int shuffleSeed,
  }) {
    if (pairs.length < 2) {
      return pairs;
    }
    final int rawShift = shuffleSeed % pairs.length;
    final int shift = rawShift == 0 ? 1 : rawShift;
    return <StudyMatchPair>[...pairs.skip(shift), ...pairs.take(shift)];
  }
}
