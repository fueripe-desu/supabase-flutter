import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type.dart';

void main() {
  test('should successfuly create a range of UTC timestamptz type', () {
    expect(
      () => RangeType.createRange(
        range: '[2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.999Z]',
      ),
      returnsNormally,
    );

    expect(
      RangeType.createRange(
        range: '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
      ),
      isA<DateRangeType>(),
    );
  });

  test(
      'should throw an Exception if the lower bound is greater than the upper bound',
      () {
    expect(
      () => RangeType.createRange(
        range: '[2022-12-31T00:00:00.000Z, 2022-01-01T00:00:00.000Z]',
      ),
      throwsException,
    );
  });

  test(
      'should throw an Exception if the lower bound is greater than the upper bound with force type',
      () {
    expect(
      () => RangeType.createRange(
        range: '[2022-12-31T00:00:00.000Z, 2022-01-01T00:00:00.000Z]',
        forceType: RangeDataType.timestamptz,
      ),
      throwsException,
    );
  });

  test(
      'should create a range successfuly if the lower bound is equal to the upper bound',
      () {
    expect(
      () => RangeType.createRange(
        range: '[2022-01-01T00:00:00.000Z, 2022-01-01T00:00:00.000Z]',
      ),
      returnsNormally,
    );

    expect(
      () => RangeType.createRange(
        range: '(2022-01-01T00:00:00.000Z, 2022-01-01T00:00:00.000Z]',
      ),
      returnsNormally,
    );

    expect(
      () => RangeType.createRange(
        range: '[2022-01-01T00:00:00.000Z, 2022-01-01T00:00:00.000Z)',
      ),
      returnsNormally,
    );

    expect(
      () => RangeType.createRange(
        range: '(2022-01-01T00:00:00.000Z, 2022-01-01T00:00:00.000Z)',
      ),
      returnsNormally,
    );
  });

  test('should ensure that range is of UTC timestamptz type', () {
    final range = RangeType.createRange(
      range: '[2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.999Z]',
    );
    expect(range.rangeDataType, RangeDataType.timestamptz);
  });

  test(
      'should throw an Exception when the second value does not match the type of the first',
      () {
    expect(
      () => RangeType.createRange(range: '[2022-01-01T00:00:00.000Z, 20.0]'),
      throwsException,
    );
  });

  test('should return the correct raw range string', () {
    final range = RangeType.createRange(
      range: '[2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.999Z]',
    );
    expect(range.rawRangeString,
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z]');
  });

  test('should remove spaces from raw range string', () {
    final range = RangeType.createRange(
      range:
          '[      2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.999Z       ]',
    );
    expect(
      range.rawRangeString,
      '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z]',
    );
  });

  test('should successfuly create inclusive and exclusive ranges', () {
    final range1 = RangeType.createRange(
      range: '[2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.000Z]',
    );
    final range2 = RangeType.createRange(
      range: '(2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.000Z)',
    );
    final range3 = RangeType.createRange(
      range: '[2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.000Z)',
    );
    final range4 = RangeType.createRange(
      range: '(2022-01-01T00:00:00.000Z, 2022-01-01T15:00:00.000Z]',
    );

    expect(range1.lowerRangeInclusive, true);
    expect(range1.upperRangeInclusive, true);

    expect(range2.lowerRangeInclusive, false);
    expect(range2.lowerRangeInclusive, false);

    expect(range3.lowerRangeInclusive, true);
    expect(range3.upperRangeInclusive, false);

    expect(range4.lowerRangeInclusive, false);
    expect(range4.upperRangeInclusive, true);
  });

  group('unbounded range tests', () {
    late final DateRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
          forceType: RangeDataType.timestamptz,
        ) as DateRangeType;
      };
    });

    test('should be able to create a [,] range', () {
      expect(() => createRange('[,]'), returnsNormally);
      expect(
        createRange('[,]'),
        isA<DateRangeType>(),
      );
    });

    test('should be able to create a [b,] range', () {
      expect(() => createRange('[2022-01-01T00:00:00.999Z,]'), returnsNormally);
      expect(
        createRange('[2022-01-01T00:00:00.999Z,]'),
        isA<DateRangeType>(),
      );
    });

    test('should be able to create a [,b] range', () {
      expect(() => createRange('[,2022-01-01T15:00:00.999Z]'), returnsNormally);
      expect(
        createRange('[,2022-01-01T15:00:00.999Z]'),
        isA<DateRangeType>(),
      );
    });

    test('should create a [,] range with the correct type', () {
      final range = createRange('[,]');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test('should create a [b,] range with the correct type', () {
      final range = createRange('[2022-01-01T00:00:00.999Z,]');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test('should create a [,b] range with the correct type', () {
      final range = createRange('[,2022-01-01T15:00:00.999Z]');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test(
        'should create a [,] range with the correct lower and upper bound values',
        () {
      final range = createRange('[,]');
      expect(range.lowerRange, null);
      expect(range.upperRange, null);
    });

    test(
        'should create a [b,] range with the correct lower and upper bound values',
        () {
      final range = createRange('[2022-01-01T00:00:00.999Z,]');
      expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
      expect(range.upperRange, null);
    });

    test(
        'should create a [,b] range with the correct lower and upper bound values',
        () {
      final range = createRange('[,2022-01-01T15:00:00.999Z]');
      expect(range.lowerRange, null);
      expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0, 999));
    });

    test('should create a [,] range with the correct inclusivity', () {
      // When a bound is unspecified, it is always converted to exclusive
      final range = createRange('[,]');
      expect(range.lowerRangeInclusive, false);
      expect(range.upperRangeInclusive, false);
    });

    test('should create a [b,] range with the correct inclusivity', () {
      // When a bound is unspecified, it is always converted to exclusive
      final range = createRange('[2022-01-01T00:00:00.000Z,]');
      expect(range.lowerRangeInclusive, true);
      expect(range.upperRangeInclusive, false);
    });

    test('should create a [,b] range with the correct inclusivity', () {
      // When a bound is unspecified, it is always converted to exclusive
      final range = createRange('[,2022-01-01T15:00:00.000Z]');
      expect(range.lowerRangeInclusive, false);
      expect(range.upperRangeInclusive, true);
    });

    test('should create a [,] range with the correct raw range string', () {
      final range = createRange('[,]');
      expect(range.rawRangeString, '(,)');
    });

    test('should create a [b,] range with the correct raw range string', () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');
      expect(range.rawRangeString, '[2022-01-01T00:00:00.000Z,)');
    });

    test('should create a [,b] range with the correct raw range string', () {
      final range = createRange('[,2022-01-01T15:00:00.000Z]');
      expect(range.rawRangeString, '(,2022-01-01T15:00:00.000Z]');
    });

    test('should return false when checking if a [,] range is empty', () {
      final range = createRange('[,]');
      expect(range.isEmpty, false);
    });

    test('should return false when checking if a [b,] range is empty', () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');
      expect(range.isEmpty, false);
    });

    test('should return false when checking if a [,b] range is empty', () {
      final range = createRange('[,2022-01-01T15:00:00.000Z]');
      expect(range.isEmpty, false);
    });
  });

  group('type inference', () {
    late final DateRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
        ) as DateRangeType;
      };
    });

    test(
        'should be able to infer the type when only the lower bound is specified',
        () {
      final range = createRange('[2022-01-01T00:00:00.999Z,]');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test(
        'should be able to infer the type when only the upper bound is specified',
        () {
      final range = createRange('[,2022-01-01T15:00:00.999Z]');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test(
        'should be able to infer the type when both the upper and lower bounds are specified',
        () {
      final range = createRange(
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z]',
      );
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test('should throw an Exception when infering the type of a [,] range', () {
      expect(() => createRange('[,]'), throwsException);
    });

    test('should create a [b,] range with the correct lower and upper values',
        () {
      final range = createRange('[2022-01-01T00:00:00.999Z,]');
      expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
      expect(range.upperRange, null);
    });

    test('should create a [,b] range with the correct lower and upper values',
        () {
      final range = createRange('[,2022-01-01T15:00:00.999Z]');
      expect(range.lowerRange, null);
      expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0, 999));
    });

    test('should create a [b,b] range with the correct lower and upper values',
        () {
      final range =
          createRange('[2022-01-01T00:00:00.999Z,2022-01-01T15:00:00.999Z]');
      expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
      expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0, 999));
    });

    test('should create a [b,] range with the correct inclusivity', () {
      final range = createRange('[2022-01-01T00:00:00.999Z,]');
      expect(range.lowerRangeInclusive, true);
      expect(range.upperRangeInclusive, false);
    });

    test('should create a [,b] range with the correct correct inclusivity', () {
      final range = createRange('[,2022-01-01T15:00:00.999Z]');
      expect(range.lowerRangeInclusive, false);
      expect(range.upperRangeInclusive, true);
    });

    test('should create a [b,b] range with the correct inclusivity', () {
      final range = createRange(
        '[2022-01-01T00:00:00.999Z,2022-01-01T15:00:00.999Z]',
      );
      expect(range.lowerRangeInclusive, true);
      expect(range.upperRangeInclusive, true);
    });

    test('should create a [b,] range with the correct raw range string', () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');
      expect(range.rawRangeString, '[2022-01-01T00:00:00.000Z,)');
    });

    test('should create a [,b] range with the correct raw range string', () {
      final range = createRange('[,2022-01-01T15:00:00.000Z]');
      expect(range.rawRangeString, '(,2022-01-01T15:00:00.000Z]');
    });

    test('should create a [b,b] range with the correct raw range string', () {
      final range = createRange(
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.000Z]',
      );
      expect(
        range.rawRangeString,
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.000Z]',
      );
    });

    test('should return false when cheking if a [b,] range is empty', () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');
      expect(range.isEmpty, false);
    });

    test('should return false when cheking if a [,b] range is empty', () {
      final range = createRange('[,2022-01-01T15:00:00.000Z]');
      expect(range.isEmpty, false);
    });

    test('should return false when cheking if a [b,b] range is empty', () {
      final range = createRange(
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.000Z]',
      );
      expect(range.isEmpty, false);
    });
  });

  group('isInRange() tests', () {
    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      );
      expect(
        range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)),
        false,
      );
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      expect(
        range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)),
        false,
      );
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      expect(
        range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)),
        false,
      );
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      );
      expect(
        range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)),
        true,
      );
      expect(
        range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)),
        false,
      );
      expect(
        range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)),
        false,
      );
    });
  });

  group('isInRange() unbounded tests', () {
    late final DateRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
          forceType: RangeDataType.timestamptz,
        ) as DateRangeType;
      };
    });

    test(
        'should return true when checking if any value is in range of [,] range',
        () {
      final range = createRange('[,]');

      expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 0, 0, 0)), true);
    });

    test(
        'should return true when checking if a value bigger than the lower range is within a [b,] range',
        () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');

      expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 0, 0, 0)), true);
    });

    test(
        'should return false when checking if a value less than the lower range is within a [b,] range',
        () {
      final range = createRange('[2022-01-01T00:00:00.000Z,]');

      expect(range.isInRange(DateTime.utc(2021, 6, 15, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 1, 2, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 1, 1, 0, 0, 0)), false);
    });

    test(
        'should return true when checking if a value less than the upper range is within a [,b] range',
        () {
      final range = createRange('[,2022-12-31T00:00:00.000Z]');

      expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 3, 15, 0, 0, 0)), true);
    });

    test(
        'should return false when checking if a value bigger than the upper range is within a [,b] range',
        () {
      final range = createRange('[,2022-12-31T00:00:00.000Z]');

      expect(range.isInRange(DateTime.utc(2023, 6, 15, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 3, 15, 0, 0, 0)), false);
    });
  });

  group('overlaps() tests', () {
    late final bool Function(String range1, String range2) checkOverlap;

    setUpAll(() {
      checkOverlap = (String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      };
    });
    test('should return true if ranges overlap completely', () {
      // Ranges overlap completely
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
          '[2023-01-01T10:00:00.000Z, 2023-01-01T15:00:00.000Z]',
        ),
        true,
      );
    });

    test('should return true if one range is completely within the other', () {
      // One range is completely within the other
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
          '[2023-01-01T09:00:00.000Z, 2023-01-01T11:00:00.000Z]',
        ),
        true,
      );
    });

    test('should return true if ranges have the same start or end points ', () {
      // Ranges have the same start or end points
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
          '[2023-01-01T08:00:00.000Z, 2023-01-01T14:00:00.000Z]',
        ),
        true,
      );
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
          '[2023-01-01T05:00:00.000Z, 2023-01-01T08:00:00.000Z]',
        ),
        true,
      );
    });

    test('should return false if ranges touch but do not overlap', () {
      // Ranges touch but do not overlap
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
          '[2023-01-01T12:00:00.001Z, 2023-01-01T16:00:00.000Z]',
        ),
        false,
      );
    });

    test('should return false if ranges do not overlap', () {
      // Ranges don't overlap
      expect(
        checkOverlap(
          '[2023-01-01T08:00:00.000Z, 2023-01-01T10:00:00.000Z]',
          '[2023-01-01T11:00:00.000Z, 2023-01-01T15:00:00.000Z]',
        ),
        false,
      );
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(
        range: '[2023-01-01T08:00:00.000Z, 2023-01-01T10:00:00.000Z]',
      );
      final range2 = RangeType.createRange(range: '[10, 20]');

      expect(() => range1.overlaps(range2), throwsException);
    });
  });

  group('overlaps() unbounded tests', () {
    late final bool Function(String range1, String range2) checkOverlap;

    setUpAll(() {
      checkOverlap = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.timestamptz,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.timestamptz,
        );
        return r1.overlaps(r2);
      };
    });

    test('should return true when checking if a [,] range overlaps any other',
        () {
      // Ranges overlap because an unbounded range overlaps any other range
      expect(
        checkOverlap(
          '[,]',
          '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
        ),
        true,
      );
    });

    test(
        'should return true if the upper bound is greater than the other lower bound in a [,b] range',
        () {
      // Ranges overlap because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
      expect(
        checkOverlap(
          '[,2023-01-01T00:00:00.000Z]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        true,
      );
    });

    test(
        'should return false if the upper bound is less than the other lower bound in a [,b] range',
        () {
      // Ranges do not overlap because 2021-01-01T00:00:00.000Z < 2022-01-01T00:00:00.000Z
      expect(
        checkOverlap(
          '[,2021-01-01T00:00:00.000Z]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        false,
      );
    });

    test(
        'should return true if the lower bound is less than the other in a [b,] range',
        () {
      // Ranges overlap because 2021-01-01T00:00:00.000Z < 2022-01-01T00:00:00.000Z
      expect(
        checkOverlap(
          '[2021-01-01T00:00:00.000Z,]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        true,
      );
    });

    test(
        'should return false if the lower bound is greater than the other upper bound in a [b,] range',
        () {
      // Ranges do not overlap because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
      expect(
        checkOverlap(
          '[2023-01-01T00:00:00.000Z,]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        false,
      );
    });
  });

  group('isAdjacent() tests', () {
    late final bool Function(String range1, String range2) checkAdjacency;

    setUpAll(() {
      checkAdjacency = (String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      };
    });

    test('should return true if ranges are adjacent', () {
      // Two date ranges are adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00Z, 2023-01-01T15:00:00Z]',
          '(2023-01-01T15:00:00Z, 2023-01-01T20:00:00Z)',
        ),
        true,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00.000Z, 2023-01-01T15:00:00.000Z]',
          '[2023-01-01T15:00:00.001Z, 2023-01-01T20:00:00.000Z]',
        ),
        true,
      );
    });

    test('should return false if ranges are not adjacent', () {
      // Two date ranges are not adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00.000Z, 2023-01-10T00:00:00.000Z]',
          '[2023-01-12T00:00:00.000Z, 2023-01-20T00:00:00.000Z]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00.000Z, 2023-01-10T00:00:00.000Z]',
          '[2023-01-21T00:00:00.000Z, 2023-01-30T00:00:00.000Z]',
        ),
        false,
      );
    });
  });

  group('isAdjacent() unbounded tests', () {
    late final bool Function(String range1, String range2) checkAdjacency;

    setUpAll(() {
      checkAdjacency = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.timestamptz,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.timestamptz,
        );
        return r1.isAdjacent(r2);
      };
    });
    test('should return false if unbounded ranges are tested for adjacency',
        () {
      expect(
        checkAdjacency(
          '[,]',
          '[,]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[,]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[,2022-12-31T00:00:00.000Z]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2022-01-01T00:00:00.000Z,]',
          '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
        ),
        false,
      );
    });
  });

  group('getComparable() tests', () {
    late final RangeComparable<DateTime> Function(String range) getComparable;

    setUpAll(() {
      getComparable = (String range) {
        return RangeType.createRange(range: range).getComparable()
            as RangeComparable<DateTime>;
      };
    });
    test(
        'should return a comparable of the correct generic type when calling getComparable()',
        () {
      expect(
        getComparable(
          '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.000Z]',
        ),
        isA<RangeComparable<DateTime>>(),
      );
    });

    test('should return the correct comparable on [] ranges', () {
      final comparable = getComparable(
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z]',
      );

      expect(
        comparable.lowerRange,
        DateTime.utc(2022, 1, 1, 0, 0, 0, 0),
      );
      expect(
        comparable.upperRange,
        DateTime.utc(2022, 1, 1, 15, 0, 0, 999),
      );
    });

    test('should return the correct comparable on [) ranges', () {
      final comparable = getComparable(
        '[2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z)',
      );

      expect(
        comparable.lowerRange,
        DateTime.utc(2022, 1, 1, 0, 0, 0, 0),
      );
      expect(
        comparable.upperRange,
        DateTime.utc(2022, 1, 1, 15, 0, 0, 998),
      );
    });

    test('should return the correct comparable on (] ranges', () {
      final comparable = getComparable(
        '(2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z]',
      );

      expect(
        comparable.lowerRange,
        DateTime.utc(2022, 1, 1, 0, 0, 0, 1),
      );
      expect(
        comparable.upperRange,
        DateTime.utc(2022, 1, 1, 15, 0, 0, 999),
      );
    });

    test('should return the correct comparable on () ranges', () {
      final comparable = getComparable(
        '(2022-01-01T00:00:00.000Z,2022-01-01T15:00:00.999Z)',
      );

      expect(
        comparable.lowerRange,
        DateTime.utc(2022, 1, 1, 0, 0, 0, 1),
      );
      expect(
        comparable.upperRange,
        DateTime.utc(2022, 1, 1, 15, 0, 0, 998),
      );
    });
  });

  group('comparison tests', () {
    late final bool Function(String range1, String range2) gt;
    late final bool Function(String range1, String range2) gte;
    late final bool Function(String range1, String range2) lt;
    late final bool Function(String range1, String range2) lte;
    late final bool Function(String range1, String range2) eq;
    late final bool Function(String range1, String range2) ceq;

    setUpAll(() {
      (DateRangeType, DateRangeType) getRangePair(
          String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);

        return (r1, r2) as (DateRangeType, DateRangeType);
      }

      gt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 > c2;
      };

      gte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 >= c2;
      };

      lt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 < c2;
      };

      lte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 <= c2;
      };

      eq = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 == c2;
      };

      ceq = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1.getComparable() == c2.getComparable();
      };
    });

    group('greater than tests', () {
      test('should return true if the lower bound is greater than the other',
          () {
        // Lower bounds are greater than 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-02T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gt(
            '[2022-06-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test('should return false when the lower bound is less than the other',
          () {
        // Lower bounds are less than 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[2021-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          gt(
            '[2021-06-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return the correct value when lower bounds have different inclusivity',
          () {
        // Lower bounds have different inclusivity
        expect(
          gt(
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true if the lower bound is equal but the upper bound is greater',
          () {
        // Lower bounds are equal but the upper bounds are greater
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gt(
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });

      test(
          'should return false if the lower bound is equal but the upper bound is less',
          () {
        // Lower bounds are equal but the upper bounds are less
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z, 2022-06-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          gt(
            '(2022-01-01T00:00:00.000Z, 2022-06-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          false,
        );
      });

      test('should return false if values are equal', () {
        // Values are equal
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          gt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          false,
        );
      });
    });

    group('greater than or equal to tests', () {
      test('should return true if the lower bound is greater than the other',
          () {
        // Lower bounds are greater than 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-02T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gte(
            '[2022-06-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test('should return false if the lower bound is less than the other', () {
        // Lower bounds are less than 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[2021-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          gte(
            '[2021-06-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return the correct value when lower bounds have different inclusivity',
          () {
        // Ranges have different inclusivity
        expect(
          gte(
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should true if the lower bound is equal but the upper bound is greater',
          () {
        // Lower bounds are equal but the upper bound of is greater or equal
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gte(
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });

      test(
          'should return false if the lower bound is equal but the upper bound is less',
          () {
        // Lower bounds are equal but the upper bound of is less or equal
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z, 2022-06-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          gte(
            '(2022-01-01T00:00:00.000Z, 2022-06-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          false,
        );
      });

      test('should return true if ranges are equal', () {
        // Values are equal
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          gte(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });
    });

    group('less than tests', () {
      test('should return true if the lower bound is less than the other', () {
        // Lower bounds are less than 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[2021-01-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '[2021-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test('should return false if the lower bound is greater than the other',
          () {
        // Lower bounds are greater than 2021-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          lt(
            '[2022-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return the correct value when lower bounds have different inclusivity',
          () {
        // Ranges have different inclusivity
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true if the lower bound is equal but the upper bound is less',
          () {
        // Lower bounds are equal but the upper bounds are less
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
          ),
          true,
        );
      });

      test(
          'should return false if the lower bound is equal but the upper bound is greater',
          () {
        // Lower bounds are equal but the upper bounds are greater
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2024-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2024-01-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
          ),
          false,
        );
      });

      test('should return false if ranges are equal', () {
        // Values are equal
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          false,
        );
      });
    });

    group('less than or equal to tests', () {
      test('should return true if the lower bound is less than the other', () {
        // Lower bounds are less than 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[2021-01-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '[2021-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test('should return false if the lower bound is greater than the other',
          () {
        // Lower bounds are greater than 2021-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          lt(
            '[2022-06-01T00:00:00.000Z, 2022-11-31T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return the correct value when lower bounds have different inclusivity',
          () {
        // Ranges have different inclusivity
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true if the lower bound is equal but the upper bound is less',
          () {
        // Lower bounds are equal but the upper bounds are less
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
          ),
          true,
        );
      });

      test(
          'should return false if the lower bound is equal but the upper bound is greater',
          () {
        // Lower bounds are equal but the upper bounds are greater
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z, 2024-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
        expect(
          lt(
            '(2022-01-01T00:00:00.000Z, 2024-01-01T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2023-01-01T00:00:00.000Z)',
          ),
          false,
        );
      });

      test('should return true if ranges are equal', () {
        // Values are equal
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          lte(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });
    });

    group('range equality', () {
      late final bool Function(String range1, String range2) forceEq;
      late final bool Function(String range1, String range2) dynamicEq;

      setUpAll(() {
        forceEq = (range1, range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.timestamptz,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.timestamptz,
          );

          return r1 == r2;
        };

        dynamicEq = (range1, range2) {
          final r1 = RangeType.createRange(range: range1);
          final r2 = RangeType.createRange(range: range2);

          return r1 == r2;
        };
      });

      test('should return true if ranges are completely equal', () {
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          true,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          true,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          true,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          true,
        );
      });

      test('should return false if ranges have different values', () {
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
      });

      test(
          'should return false if ranges have the same lower bound but a different upper bound',
          () {
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
      });

      test(
          'should return false if ranges have the same upper bound but a different lower bound',
          () {
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
            '[2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
            '(2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
            '[2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
            '(2023-01-01T00:00:00Z, 2023-12-31T00:00:00Z)',
          ),
          false,
        );
      });

      test(
          'should return false if ranges cover the same values but are not the same',
          () {
        expect(
          eq(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.999Z)',
            '[2022-01-01T00:00:00.001Z, 2022-12-31T00:00:00.998Z]',
          ),
          false,
        );
      });

      test('should return true if ranges have the same infinity values', () {
        expect(
          forceEq(
            '[-infinity, 2022-12-31T00:00:00Z]',
            '[-infinity, 2022-12-31T00:00:00Z]',
          ),
          true,
        );
        expect(
          forceEq(
            '[2022-01-01T00:00:00Z, infinity]',
            '[2022-01-01T00:00:00Z, infinity]',
          ),
          true,
        );
        expect(
          forceEq(
            '[-infinity, infinity]',
            '[-infinity, infinity]',
          ),
          true,
        );
      });

      test('should return false if ranges have different infinity values', () {
        expect(
          forceEq(
            '[-infinity, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, infinity]',
          ),
          false,
        );
        expect(
          forceEq(
            '[-infinity, 2022-12-31T00:00:00Z]',
            '[-infinity, infinity]',
          ),
          false,
        );

        expect(
          forceEq(
            '[2022-01-01T00:00:00Z, infinity]',
            '[-infinity, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          forceEq(
            '[2022-01-01T00:00:00Z, infinity]',
            '[-infinity, infinity]',
          ),
          false,
        );

        expect(
          forceEq(
            '[-infinity, infinity]',
            '[2022-01-01T00:00:00Z, infinity]',
          ),
          false,
        );
        expect(
          forceEq(
            '[-infinity, infinity]',
            '[-infinity, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
      });

      test('should return false if ranges have a different inclusivity', () {
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );

        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );

        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );

        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
          ),
          false,
        );
        expect(
          eq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );
      });

      test('should return false if ranges are of different types', () {
        // UTC Timestamptz != Integer
        expect(
          dynamicEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[1, 10]',
          ),
          false,
        );

        // UTC Timestamptz != Float
        expect(
          dynamicEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[1.5, 10.5]',
          ),
          false,
        );

        // UTC Timestamptz != Date
        expect(
          dynamicEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01, 2022-12-31]',
          ),
          false,
        );

        // Timestamptz != Timestamp
        expect(
          dynamicEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
          ),
          false,
        );

        // UTC Timestamptz != Timestamptz
        expect(
          dynamicEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '[2022-01-01T00:00:00-01, 2022-12-31T00:00:00+01]',
          ),
          false,
        );
      });

      test('should return true if both ranges are empty', () {
        expect(forceEq('', ''), true);
      });

      test(
          'should return false if any range is compared against an empty range',
          () {
        expect(
          forceEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '',
          ),
          false,
        );
        expect(
          forceEq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
            '',
          ),
          false,
        );
        expect(
          forceEq(
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '',
          ),
          false,
        );
        expect(
          forceEq(
            '(2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z)',
            '',
          ),
          false,
        );
      });
    });

    group('comparable equality', () {
      test('should return true if ranges are equal', () {
        // Values are equal
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          ceq(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
        expect(
          ceq(
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });

      test('should return true if the ranges cover the same values', () {
        // Ranges cover same values
        expect(
          ceq(
            '[2022-01-01T00:00:00.001Z, 2022-12-31T00:00:00.998Z]',
            '(2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.999Z)',
          ),
          true,
        );
      });

      test('should return false if ranges are different', () {
        // Ranges are different
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z, 2024-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });
    });
  });

  group('comparison unbounded tests', () {
    late final bool Function(String range1, String range2) gt;
    late final bool Function(String range1, String range2) gte;
    late final bool Function(String range1, String range2) lt;
    late final bool Function(String range1, String range2) lte;
    late final bool Function(String range1, String range2) eq;
    late final bool Function(String range1, String range2) ceq;

    setUpAll(() {
      (DateRangeType, DateRangeType) getRangePair(
          String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.timestamptz,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.timestamptz,
        );

        return (r1, r2) as (DateRangeType, DateRangeType);
      }

      gt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 > c2;
      };

      gte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 >= c2;
      };

      lt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 < c2;
      };

      lte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 <= c2;
      };

      eq = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 == c2;
      };

      ceq = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1.getComparable() == c2.getComparable();
      };
    });
    group('greater than tests', () {
      test(
          'should return false when checking if a [,] range is greater than a [b,b] range',
          () {
        expect(
          gt(
            '[,]',
            '[2022-01-01T00:00:00.000Z, 2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when checking if a [,] range is greater than a [,b] range',
          () {
        expect(
          gt(
            '[,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when checking if a [,] range is greater than a [b,] range',
          () {
        expect(
          gt(
            '[,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when checking if a [,] range is greater than other [,] range',
          () {
        expect(
          gt(
            '[,]',
            '[,]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,2024-00-00T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,2024-00-00T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
          () {
        // Not greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,2024-00-00T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
          () {
        // Not greater than because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
          () {
        // Not greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2021-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when a [b,] range is compared against a completely unbounded range',
          () {
        // Greater than because [b,] is greater than [,]
        expect(
          gt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2021-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
          () {
        // Greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when a [,b] range is compared against a [,] range',
          () {
        // Not greater than because [,b] is not greater than [,]
        expect(
          gt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,]',
          ),
          false,
        );
      });
    });
    group('greater than or equal to tests', () {
      test(
          'should return false when checking if a [,] range is greater than or equal to a [b,b] range',
          () {
        expect(
          gte(
            '[,]',
            '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when checking if a [,] range is greater than or equal to a [,b] range',
          () {
        expect(
          gte(
            '[,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when checking if a [,] range is greater than or equal to [b,] a range',
          () {
        expect(
          gte(
            '[,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when checking if a [,] range is greater than or equal to other [,] range',
          () {
        expect(
          gte(
            '[,]',
            '[,]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
          () {
        // Equal to because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
          () {
        // Not greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
          () {
        // Equal to because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
          () {
        // Not greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2021-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
          () {
        // Greater than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when a [b,] range is compared against a completely unbounded range',
          () {
        // Greater than because [b,] is greater than [,]
        expect(
          gte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
          () {
        // Greater than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
          () {
        // Equal to because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
          () {
        // Not greater than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when a [,b] range is compared against a [,] range',
          () {
        // Not greater than because [,b] is not greater than [,]
        expect(
          gte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,]',
          ),
          false,
        );
      });
    });

    group('less than tests', () {
      test(
          'should return true when checking if a [,] range is less than a [b,b] range',
          () {
        expect(
          lt(
            '[,]',
            '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when checking if a [,] range is less than a [,b] range',
          () {
        expect(
          lt(
            '[,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when checking if a [,] range is less than a [b,] range',
          () {
        expect(
          lt(
            '[,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when checking if a [,] range is less than other [,] range',
          () {
        expect(
          lt(
            '[,]',
            '[,]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
          () {
        // Less than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
          () {
        // Less than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2021-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when a [b,] range is compared against a [,] range',
          () {
        // False because [b,] is greater than [,]
        expect(
          lt(
            '[2022-01-01T00:00:00.000Z,]',
            '[,]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
          () {
        // Not less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
          () {
        // Not less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when a [,b] range is compared against a [,] range',
          () {
        // Less than because [,b] is not greater than [,]
        expect(
          lt(
            '[,2023-01-01T00:00:00.000Z]',
            '[,]',
          ),
          true,
        );
      });
    });

    group('less than or equal to tests', () {
      test(
          'should return true when checking if a [,] range is less than or equal to a [b,b] range',
          () {
        expect(
          lte(
            '[,]',
            '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when checking if a [,] range is less than or equal to a [,b] range',
          () {
        expect(
          lte(
            '[,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when checking if a [,] range is less than or equal to a [b,] range',
          () {
        expect(
          lte(
            '[,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when checking if a [,] range is less than or equal to other [,] range',
          () {
        expect(
          lte(
            '[,]',
            '[,]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
          () {
        // Less than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2021-01-01T00:00:00.000Z,]',
          ),
          false,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
          () {
        // Less than because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z > 2021-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2021-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z == 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
          () {
        // False because 2022-01-01T00:00:00.000Z < 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return false when a [b,] range is compared against a [,] range',
          () {
        // False because [b,] is greater than [,]
        expect(
          lte(
            '[2022-01-01T00:00:00.000Z,]',
            '[,]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2022-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2020-01-01T00:00:00.000Z,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,2025-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00..000Z000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[2024-01-01T00:00:00.000Z,]',
          ),
          true,
        );
      });

      test(
          'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
          () {
        // Not less than because 2023-01-01T00:00:00.000Z > 2022-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2022-01-01T00:00:00.000Z]',
          ),
          false,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
          () {
        // Not less than because 2023-01-01T00:00:00.000Z == 2023-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2023-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
          () {
        // Less than because 2023-01-01T00:00:00.000Z < 2024-01-01T00:00:00.000Z
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,2024-01-01T00:00:00.000Z]',
          ),
          true,
        );
      });

      test(
          'should return true when a [,b] range is compared against a [,] range',
          () {
        // Less than because [,b] is not greater than [,]
        expect(
          lte(
            '[,2023-01-01T00:00:00.000Z]',
            '[,]',
          ),
          true,
        );
      });
    });

    group('range equality', () {
      test('should return true if the ranges have the same values', () {
        expect(eq('[2022-01-01T00:00:00Z,]', '[2022-01-01T00:00:00Z,]'), true);
        expect(eq('(2022-01-01T00:00:00Z,]', '(2022-01-01T00:00:00Z,]'), true);
        expect(eq('[2022-01-01T00:00:00Z,)', '[2022-01-01T00:00:00Z,)'), true);
        expect(eq('(2022-01-01T00:00:00Z,)', '(2022-01-01T00:00:00Z,)'), true);

        expect(eq('[,2022-12-31T00:00:00Z]', '[,2022-12-31T00:00:00Z]'), true);
        expect(eq('(,2022-12-31T00:00:00Z]', '(,2022-12-31T00:00:00Z]'), true);
        expect(eq('[,2022-12-31T00:00:00Z)', '[,2022-12-31T00:00:00Z)'), true);
        expect(eq('(,2022-12-31T00:00:00Z)', '(,2022-12-31T00:00:00Z)'), true);

        expect(eq('[,]', '[,]'), true);
        expect(eq('(,]', '(,]'), true);
        expect(eq('[,)', '[,)'), true);
        expect(eq('(,)', '(,)'), true);

        expect(eq('[2022-01-01T00:00:00Z,]', '[2022-01-01T00:00:00Z,)'), true);
        expect(eq('[,2022-12-31T00:00:00Z]', '(,2022-12-31T00:00:00Z]'), true);

        expect(eq('[,]', '(,)'), true);
        expect(eq('[,]', '(,]'), true);
        expect(eq('[,]', '[,)'), true);
      });

      test('should return false if the ranges have different values', () {
        expect(eq('[2022-01-01T00:00:00Z,]', '[2022-12-31T00:00:00Z,]'), false);
        expect(eq('[2022-01-01T00:00:00Z,]', '[,2022-12-31T00:00:00Z]'), false);
        expect(eq('[2022-01-01T00:00:00Z,]', '[,]'), false);

        expect(eq('[,2022-12-31T00:00:00Z]', '[2022-01-01T00:00:00Z,]'), false);
        expect(eq('[,2022-12-31T00:00:00Z]', '[,2022-01-01T00:00:00Z]'), false);
        expect(eq('[,2022-12-31T00:00:00Z]', '[,]'), false);

        expect(eq('[,]', '[2022-01-01T00:00:00Z,]'), false);
        expect(eq('[,]', '[,2022-12-31T00:00:00Z]'), false);
      });

      test(
          'should return false if values are equal but the inclusivity is different',
          () {
        expect(eq('[2022-01-01T00:00:00Z,]', '(2022-01-01T00:00:00Z,]'), false);
        expect(eq('[2022-01-01T00:00:00Z,]', '(2022-01-01T00:00:00Z,)'), false);

        expect(eq('[,2022-12-31T00:00:00Z]', '[,2022-12-31T00:00:00Z)'), false);
        expect(eq('[,2022-12-31T00:00:00Z]', '(,2022-12-31T00:00:00Z)'), false);
      });

      test(
          'should return false if ranges cover the same values but are not the same',
          () {
        expect(
          eq(
            '(2022-01-01T00:00:00.000Z,)',
            '[2022-01-01T00:00:00.001Z,]',
          ),
          false,
        );

        expect(
          eq(
            '(,2022-12-31T00:00:00.999Z)',
            '[,2022-12-31T00:00:00.999Z]',
          ),
          false,
        );
      });

      test('should return true if ranges have the same infinity values', () {
        expect(eq('[-infinity,]', '[-infinity,]'), true);
        expect(eq('[,infinity]', '[,infinity]'), true);
      });

      test('should return false if ranges have different infinity values', () {
        expect(eq('[2022-01-01T00:00:00Z,]', '[-infinity,]'), false);
        expect(eq('[2022-01-01T00:00:00Z,]', '[,infinity]'), false);

        expect(eq('[,2022-12-31T00:00:00Z]', '[-infinity,]'), false);
        expect(eq('[,2022-12-31T00:00:00Z]', '[,infinity]'), false);
      });

      test(
          'should return false if any range is compared against an empty range',
          () {
        expect(eq('[2022-01-01T00:00:00Z,]', ''), false);
        expect(eq('[,2022-12-31T00:00:00Z]', ''), false);
        expect(eq('[,]', ''), false);
      });
    });

    group('comparable equality', () {
      test('should return true if ranges are equal with the same inclusivity',
          () {
        // Values are equal
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
        expect(
          ceq(
            '[,2022-12-31T00:00:00.000Z]',
            '[,2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          ceq(
            '[,]',
            '[,]',
          ),
          true,
        );
      });

      test(
          'should return true if [b,] ranges are equal with different inclusivity',
          () {
        // Values are equal
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z,]',
            '[2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
        expect(
          ceq(
            '(2022-01-01T00:00:00.000Z,]',
            '(2022-01-01T00:00:00.000Z,]',
          ),
          true,
        );
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z,)',
            '[2022-01-01T00:00:00.000Z,)',
          ),
          true,
        );
        expect(
          ceq(
            '(2022-01-01T00:00:00.000Z,)',
            '(2022-01-01T00:00:00.000Z,)',
          ),
          true,
        );
      });

      test(
          'should return true if [,b] ranges are equal with different inclusivity',
          () {
        // Values are equal
        expect(
          ceq(
            '[,2022-12-31T00:00:00.000Z]',
            '[,2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          ceq(
            '(,2022-12-31T00:00:00.000Z]',
            '(,2022-12-31T00:00:00.000Z]',
          ),
          true,
        );
        expect(
          ceq(
            '[,2022-12-31T00:00:00.000Z)',
            '[,2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
        expect(
          ceq(
            '(,2022-12-31T00:00:00.000Z)',
            '(,2022-12-31T00:00:00.000Z)',
          ),
          true,
        );
      });

      test(
          'should return true if [,] ranges are equal with different inclusivity',
          () {
        // Values are equal
        expect(
          ceq(
            '[,]',
            '[,]',
          ),
          true,
        );
        expect(
          ceq(
            '(,]',
            '(,]',
          ),
          true,
        );
        expect(
          ceq(
            '[,)',
            '[,)',
          ),
          true,
        );
        expect(
          ceq(
            '(,)',
            '(,)',
          ),
          true,
        );
      });

      test('should return true if a [,] range is compared against a (,)', () {
        // Values are equal
        expect(
          ceq(
            '[,]',
            '(,)',
          ),
          true,
        );
      });

      test('should return true if the [b,] ranges cover the same values', () {
        // Ranges cover same values
        expect(
          ceq(
            '[2022-01-01T00:00:00.001Z,]',
            '(2022-01-01T00:00:00.000Z,)',
          ),
          true,
        );
      });

      test('should return true if the [,b] ranges cover the same values', () {
        // Ranges cover same values
        expect(
          ceq(
            '[,2022-12-31T00:00:00.998Z]',
            '(,2022-12-31T00:00:00.999Z)',
          ),
          true,
        );
      });

      test('should return false if ranges are different', () {
        // Ranges are different
        expect(
          ceq(
            '[2022-01-01T00:00:00.000Z,]',
            '[2023-01-01T00:00:00.000Z,]',
          ),
          false,
        );
        expect(
          ceq(
            '[,2022-12-31T00:00:00.000Z]',
            '[,2023-12-31T00:00:00.000Z]',
          ),
          false,
        );
      });
    });
  });

  group('empty range tests', () {
    late final DateRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
          forceType: RangeDataType.timestamptz,
        ) as DateRangeType;
      };
    });

    test('should successfuly create an empty range', () {
      expect(() => createRange(''), returnsNormally);
      expect(createRange(''), isA<DateRangeType>());
    });

    test('should ensure that the range is of integer type', () {
      final range = createRange('');
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test(
        'should return false when getting the inclusivity of the lower and upper bounds',
        () {
      final range = createRange('');
      expect(range.lowerRangeInclusive, false);
      expect(range.upperRangeInclusive, false);
    });

    test('should return an empty string when getting the raw range string', () {
      final range = createRange('');
      expect(range.rawRangeString.isEmpty, true);
    });

    test('should return true when checking if the range is empty', () {
      final range = createRange('');
      expect(range.isEmpty, true);
    });

    test(
        'should return false when checking if any value is in range of an empty range',
        () {
      final range = createRange('');
      expect(range.isInRange(DateTime.utc(2020, 01, 01, 12, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 01, 01, 12, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2022, 01, 01, 12, 0, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 01, 01, 12, 0, 0, 0)), false);
    });

    test(
        'should return false when checking if any other range overlaps an empty range',
        () {
      final emptyRange = createRange('');
      final dateRange = createRange(
        '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
      );
      expect(emptyRange.overlaps(dateRange), false);
      expect(dateRange.overlaps(emptyRange), false);
    });

    test(
        'should return false when checking if any other range is adjacent of an empty range',
        () {
      final emptyRange = createRange('');
      final dateRange = createRange(
        '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
      );
      expect(emptyRange.isAdjacent(dateRange), false);
      expect(dateRange.isAdjacent(emptyRange), false);
    });

    test(
        'should return throw an Exception when trying to get the comparable of an empty range',
        () {
      final range = createRange('');
      expect(() => range.getComparable(), throwsException);
    });
  });

  group('empty range comparisons', () {
    late final bool Function(String range1, String range2) gt;
    late final bool Function(String range1, String range2) gte;
    late final bool Function(String range1, String range2) lt;
    late final bool Function(String range1, String range2) lte;

    setUpAll(() {
      (DateRangeType, DateRangeType) getRangePair(
          String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.timestamptz,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.timestamptz,
        );

        return (r1, r2) as (DateRangeType, DateRangeType);
      }

      gt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 > c2;
      };

      gte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 >= c2;
      };

      lt = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 < c2;
      };

      lte = (range1, range2) {
        final (c1, c2) = getRangePair(range1, range2);
        return c1 <= c2;
      };
    });

    test(
        'should return false when checking if an empty range is greater than any other',
        () {
      expect(
        gt(
          '',
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
        ),
        false,
      );
      expect(
        gt(
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
          '',
        ),
        false,
      );
    });

    test(
        'should return false when checking if an empty range is greater than or equal to any other',
        () {
      expect(
        gte(
          '',
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
        ),
        false,
      );
      expect(
        gte(
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
          '',
        ),
        false,
      );
    });

    test(
        'should return false when checking if an empty range is less than any other',
        () {
      expect(
        lt(
          '',
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
        ),
        false,
      );
      expect(
        lt(
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
          '',
        ),
        false,
      );
    });

    test(
        'should return false when checking if an empty range is less than  or equal to any other',
        () {
      expect(
        lte(
          '',
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
        ),
        false,
      );
      expect(
        lte(
          '[2022-01-01T12:00:00Z, 2022-12-31T15:00:00Z]',
          '',
        ),
        false,
      );
    });
  });

  group('infinite range tests', () {
    late final DateRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
        ) as DateRangeType;
      };
    });

    test('should be able to create a [b,i] range', () {
      expect(
        () => createRange('[2022-01-01T00:00:00Z, infinity]'),
        returnsNormally,
      );
    });

    test('should ensure that a [b,i] range is of timestamp type', () {
      final range = createRange(
        '[2022-01-01T00:00:00Z, infinity]',
      );
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test('should be able to create a [i,b] range', () {
      expect(
        () => createRange('[-infinity, 2022-12-31T00:00:00Z]'),
        returnsNormally,
      );
    });

    test('should ensure that a [i,b] range is of timestamp type', () {
      final range = createRange(
        '[-infinity, 2022-12-31T00:00:00Z]',
      );
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test('should be able to create a [i,i] range', () {
      expect(
        () => RangeType.createRange(
          range: '[-infinity, infinity]',
          forceType: RangeDataType.timestamptz,
        ),
        returnsNormally,
      );
    });
  });
}
