class RangeTypeErrors {
  static const invalidBoundError =
      'Lower bound must be less than or equal to the upper bound.';
  static const bothBoundsNullError =
      'For ranges where both boundaries are null, \'forceType\' must be provided.';
  static const bothBoundsInfiniteError =
      'For ranges where both boundaries are infinite, \'forceType\' must be provided.';
  static const datetimePrecisionError =
      'Lower bound and upper bound must be specified with the same precision.';
  static const adjacencyTypeError =
      'Cannot check adjacency between two ranges of different types.';
  static const overlapTypeError =
      'Ranges must be of the same type in order to check if they overlap.';
  static const rangeLengthError =
      'Range must have length at least greater than 2.';
  static const firstBracketError =
      'Range string must start with an inclusive \'[\' or exclusive \'(\' bracket.';
  static const lastBracketError =
      'Range string must start with an inclusive \']\' or exclusive \')\' bracket.';
  static const thirdBoundError =
      'Range string must have only two values divided by comma: the lower and upper bounds.';
  static const invalidUseOfInfinityError =
      'The lower bound cannot be \'infinity\' but only \'-infinity\'.';
  static const invalidUseOfNegativeInfinityError =
      'The upper bound cannot be \'-infinity\' but only \'infinity\'.';
  static const emptyRangeComparableError =
      'Cannot get comparable of an empty range.';

  static String typeMismatchError(dynamic firstType, dynamic secondType) =>
      'Because the lower bound is $firstType, upper bound must also be $firstType, but instead got: $secondType';

  static String inferenceInvalidType(dynamic value) =>
      'Type could not be inferred, $value is an invalid value in range.';
}
