import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_type.dart';

void main() {
  test(
      'should throw an Exception when trying to create a range with an invalid value',
      () {
    expect(
      () => RangeType.createRange(range: '[invalid_lower, invalid_upper]'),
      throwsException,
    );
  });

  test('should throw an Exception when the first bracket is not valid', () {
    expect(
      () => RangeType.createRange(range: '{0, 10]'),
      throwsException,
    );
  });

  test('should throw an Exception when the last bracket is not valid', () {
    expect(
      () => RangeType.createRange(range: '[0, 10}'),
      throwsException,
    );
  });

  test('should throw an Exception when more than 2 values is passed in a range',
      () {
    expect(
      () => RangeType.createRange(range: '[0, 10, 30]'),
      throwsException,
    );
  });

  test('should return the correct inclusivity of the ranges', () {
    final range1 = RangeType.createRange(range: '[1, 10]');
    final range2 = RangeType.createRange(range: '[1, 10)');
    final range3 = RangeType.createRange(range: '(1, 10]');
    final range4 = RangeType.createRange(range: '(1, 10)');

    expect(range1.lowerRangeInclusive, true);
    expect(range1.upperRangeInclusive, true);

    expect(range2.lowerRangeInclusive, true);
    expect(range2.upperRangeInclusive, false);

    expect(range3.lowerRangeInclusive, false);
    expect(range3.upperRangeInclusive, true);

    expect(range4.lowerRangeInclusive, false);
    expect(range4.upperRangeInclusive, false);
  });

  group('IntegerRangeType tests', () {
    test('should successfuly create a range of integer type', () {
      RangeType.createRange(range: '[1, 10]');
    });

    test('should ensure that range is of integer type', () {
      final range = RangeType.createRange(range: '[1, 10]');
      expect(range.rangeDataType, RangeDataType.integer);
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[1, 10]');
      expect(range.rawRangeString, '[1,10]');
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(range: '[1, 10]');
      final range2 = RangeType.createRange(range: '(1, 10)');
      final range3 = RangeType.createRange(range: '[1, 10)');
      final range4 = RangeType.createRange(range: '(1, 10]');

      expect(range1.lowerRangeInclusive, true);
      expect(range1.upperRangeInclusive, true);

      expect(range2.lowerRangeInclusive, false);
      expect(range2.lowerRangeInclusive, false);

      expect(range3.lowerRangeInclusive, true);
      expect(range3.upperRangeInclusive, false);

      expect(range4.lowerRangeInclusive, false);
      expect(range4.upperRangeInclusive, true);
    });

    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      final range = RangeType.createRange(range: '[1, 10]');
      expect(range.isInRange(5), true);
      expect(range.isInRange(10), true);
      expect(range.isInRange(1), true);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      final range = RangeType.createRange(range: '(1, 10)');
      expect(range.isInRange(5), true);
      expect(range.isInRange(10), false);
      expect(range.isInRange(1), false);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      final range = RangeType.createRange(range: '[1, 10)');
      expect(range.isInRange(5), true);
      expect(range.isInRange(10), false);
      expect(range.isInRange(1), true);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      final range = RangeType.createRange(range: '(1, 10]');
      expect(range.isInRange(5), true);
      expect(range.isInRange(10), true);
      expect(range.isInRange(1), false);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[0, 5.0]'),
        throwsException,
      );
    });

    test('should return true if the specified range overlaps the other', () {
      bool checkOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // Ranges overlap completely
      expect(checkOverlap('[1, 10]', '[5, 15]'), true);

      // One range is completely within the other
      expect(checkOverlap('[1, 10]', '[3, 8]'), true);

      // Ranges have the same start or end points
      expect(checkOverlap('[1, 10]', '[10, 15]'), true);
      expect(checkOverlap('[1, 10]', '[0, 5]'), true);

      // Ranges touch but do not overlap
      expect(checkOverlap('[1, 10]', '(10, 20]'), false);

      // Ranges don't overlap
      expect(checkOverlap('[1, 5]', '[6, 10]'), false);
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(range: '[10, 20]');
      final range2 = RangeType.createRange(range: '[10.0, 20.0]');

      expect(() => range1.overlaps(range2), throwsException);
    });

    test('should return true if two integer ranges are adjacent', () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two integer ranges are adjacent
      expect(checkAdjacency('[1, 10]', '(10, 20)'), true);
      expect(checkAdjacency('[1, 10]', '[11, 20]'), true);

      // Two integer ranges are not adjacent
      expect(checkAdjacency('[1, 10]', '[12, 20]'), false);
      expect(checkAdjacency('[1, 10]', '[21, 30]'), false);
    });
  });

  group('FloatRangeType tests', () {
    test('should successfuly create a range of float type', () {
      RangeType.createRange(range: '[1.5, 10.5]');
    });

    test('should ensure that range is of float type', () {
      final range = RangeType.createRange(range: '[1.5, 10.5]');
      expect(range.rangeDataType, RangeDataType.float);
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[1.5, 10.5]');
      expect(range.rawRangeString, '[1.5,10.5]');
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(range: '[1.5, 10.5]');
      final range2 = RangeType.createRange(range: '(1.5, 10.5)');
      final range3 = RangeType.createRange(range: '[1.5, 10.5)');
      final range4 = RangeType.createRange(range: '(1.5, 10.5]');

      expect(range1.lowerRangeInclusive, true);
      expect(range1.upperRangeInclusive, true);

      expect(range2.lowerRangeInclusive, false);
      expect(range2.lowerRangeInclusive, false);

      expect(range3.lowerRangeInclusive, true);
      expect(range3.upperRangeInclusive, false);

      expect(range4.lowerRangeInclusive, false);
      expect(range4.upperRangeInclusive, true);
    });

    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      final range = RangeType.createRange(range: '[1.5, 10.5]');
      expect(range.isInRange(5.5), true);
      expect(range.isInRange(10.5), true);
      expect(range.isInRange(1.5), true);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      final range = RangeType.createRange(range: '(1.5, 10.5)');
      expect(range.isInRange(5.5), true);
      expect(range.isInRange(10.5), false);
      expect(range.isInRange(1.5), false);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      final range = RangeType.createRange(range: '[1.5, 10.5)');
      expect(range.isInRange(5.5), true);
      expect(range.isInRange(10.5), false);
      expect(range.isInRange(1.5), true);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      final range = RangeType.createRange(range: '(1.5, 10.5]');
      expect(range.isInRange(5.5), true);
      expect(range.isInRange(10.5), true);
      expect(range.isInRange(1.5), false);
      expect(range.isInRange(0), false);
      expect(range.isInRange(11), false);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[5.0, 2022-01-01]'),
        throwsException,
      );
    });

    test('should return true if the specified range overlaps the other', () {
      bool checkOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // Ranges overlap completely
      expect(checkOverlap('[1.0, 10.0]', '[5.0, 15.0]'), true);

      // One range is completely within the other
      expect(checkOverlap('[1.0, 10.0]', '[3.0, 8.0]'), true);

      // Ranges have the same start or end points
      expect(checkOverlap('[1.0, 10.0]', '[10.0, 15.0]'), true);
      expect(checkOverlap('[1.0, 10.0]', '[0.0, 5.0]'), true);

      // Ranges touch but do not overlap
      expect(checkOverlap('[1.0, 10.0]', '(10.0, 20.0]'), false);

      // Ranges don't overlap
      expect(checkOverlap('[1.0, 5.0]', '[6.0, 10.0]'), false);
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(range: '[10.0, 20.0]');
      final range2 = RangeType.createRange(range: '[10, 20]');

      expect(() => range1.overlaps(range2), throwsException);
    });

    test('should return true if two double ranges are adjacent', () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two integer ranges are adjacent
      expect(checkAdjacency('[1.0, 10.0]', '(10.0, 20.0)'), true);
      expect(checkAdjacency('[1.0, 10.0]', '[10.1, 20.0]'), true);

      // Two integer ranges are not adjacent
      expect(checkAdjacency('[1.0, 10.0]', '[12.0, 20.0]'), false);
      expect(checkAdjacency('[1.0, 10.0]', '[21.0, 30.0]'), false);
    });
  });

  group('DateRangeType general tests', () {
    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-01-01, 5.0]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception when both values does not have the same precision',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-01-01, 2022-01-01T15:00:00]'),
        throwsException,
      );

      expect(
        () =>
            RangeType.createRange(range: '[2022-01-01, 2022-01-01T15:00:00Z]'),
        throwsException,
      );

      expect(
        () => RangeType.createRange(
            range: '[2022-01-01T15:00:00, 2022-01-01T15:00:00Z]'),
        throwsException,
      );
    });
  });

  group('DateRangeType tests', () {
    test('should successfuly create a range of date type', () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]')
          as DateRangeType;

      expect(range.lowerRange, DateTime.utc(2022, 1, 1));
      expect(range.upperRange, DateTime.utc(2022, 12, 31));
    });

    test('should ensure that range is of date type', () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      expect(range.rangeDataType, RangeDataType.date);
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      expect(
        range.rawRangeString,
        '[2022-01-01T00:00:00.000Z,2022-12-31T00:00:00.000Z]',
      );
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      final range2 = RangeType.createRange(range: '(2022-01-01, 2022-12-31)');
      final range3 = RangeType.createRange(range: '[2022-01-01, 2022-12-31)');
      final range4 = RangeType.createRange(range: '(2022-01-01, 2022-12-31]');

      expect(range1.lowerRangeInclusive, true);
      expect(range1.upperRangeInclusive, true);

      expect(range2.lowerRangeInclusive, false);
      expect(range2.lowerRangeInclusive, false);

      expect(range3.lowerRangeInclusive, true);
      expect(range3.upperRangeInclusive, false);

      expect(range4.lowerRangeInclusive, false);
      expect(range4.upperRangeInclusive, true);
    });

    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      final range = RangeType.createRange(range: '(2022-01-01, 2022-12-31)');
      expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31)');
      expect(range.isInRange(DateTime(2022, 6, 15)), true);
      expect(range.isInRange(DateTime(2022, 1, 1)), true);
      expect(range.isInRange(DateTime(2022, 12, 31)), false);
      expect(range.isInRange(DateTime(2023, 1, 1)), false);
      expect(range.isInRange(DateTime(2021, 12, 31)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      final range = RangeType.createRange(range: '(2022-01-01, 2022-12-31]');
      expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31)), false);
    });

    test('should return true if two date ranges overlap', () {
      bool checkDateOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // Date ranges overlap completely
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-05, 2023-01-15]',
        ),
        true,
      );

      // One date range is completely within the other
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-03, 2023-01-08]',
        ),
        true,
      );

      // Date ranges have the same start or end points
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-10, 2023-01-15]',
        ),
        true,
      );
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-10]',
          '[2022-12-31, 2023-01-05]',
        ),
        true,
      );

      // Date ranges touch but do not overlap
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-10]',
          '(2023-01-10, 2023-01-20]',
        ),
        false,
      );

      // Date ranges don't overlap
      expect(
        checkDateOverlap(
          '[2023-01-01, 2023-01-05]',
          '[2023-01-06, 2023-01-10]',
        ),
        false,
      );
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(range: '[2023-01-01, 2023-01-05]');
      final range2 = RangeType.createRange(range: '[10, 20]');

      expect(() => range1.overlaps(range2), throwsException);
    });

    test('should return true if two date ranges are adjacent', () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two integer ranges are adjacent
      expect(
        checkAdjacency(
          '[2023-01-01, 2023-01-10]',
          '(2023-01-10, 2023-01-20)',
        ),
        true,
      );
      expect(
        checkAdjacency(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-11, 2023-01-20]',
        ),
        true,
      );

      // Two integer ranges are not adjacent
      expect(
        checkAdjacency(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-12, 2023-01-20]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2023-01-01, 2023-01-10]',
          '[2023-01-21, 2023-01-30]',
        ),
        false,
      );
    });
  });

  group('DateRangeType timestamp without timezone tests', () {
    test('should successfuly create a range of timestamp without timezone type',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
      ) as DateRangeType;

      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00]',
      ) as DateRangeType;

      // Explicitly passing milliseconds
      expect(range.lowerRange, DateTime.utc(2022, 1, 1, 12, 0, 0, 999));
      expect(range.upperRange, DateTime.utc(2022, 12, 31, 12, 0, 0, 999));

      // Ommiting milliseconds
      expect(range2.lowerRange, DateTime.utc(2022, 1, 1, 12, 0, 0, 000));
      expect(range2.upperRange, DateTime.utc(2022, 12, 31, 12, 0, 0, 000));
    });

    test('should ensure that range is of date type', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
      );

      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00]',
      );
      expect(range.rangeDataType, RangeDataType.timestamp);
      expect(range2.rangeDataType, RangeDataType.timestamp);
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
      );
      expect(
        range.rawRangeString,
        '[2022-01-01T12:00:00.999Z,2022-12-31T12:00:00.999Z]',
      );
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00]',
      );
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00)',
      );
      final range3 = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00)',
      );
      final range4 = RangeType.createRange(
        range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00]',
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

    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00]',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00)',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999)',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00)',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999)',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), true);
      expect(
          range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00]',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test('should return true if two timestamp ranges overlap', () {
      bool checkDateTimeOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // DateTime ranges overlap completely
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
          '[2023-01-01T10:00:00, 2023-01-01T15:00:00]',
        ),
        true,
      );

      // One DateTime range is completely within the other
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
          '[2023-01-01T09:00:00, 2023-01-01T11:00:00]',
        ),
        true,
      );

      // DateTime ranges have the same start or end points
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
          '[2023-01-01T08:00:00, 2023-01-01T14:00:00]',
        ),
        true,
      );
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
          '[2023-01-01T05:00:00, 2023-01-01T08:00:00]',
        ),
        true,
      );

      // DateTime ranges touch but do not overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
          '(2023-01-01T12:00:00, 2023-01-01T16:00:00]',
        ),
        false,
      );

      // DateTime ranges don't overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00, 2023-01-01T10:00:00]',
          '[2023-01-01T11:00:00, 2023-01-01T15:00:00]',
        ),
        false,
      );
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(
        range: '[2023-01-01T08:00:00, 2023-01-01T10:00:00]',
      );
      final range2 = RangeType.createRange(range: '[10, 20]');

      expect(() => range1.overlaps(range2), throwsException);
    });

    test('should return true if two timestamp ranges are adjacent', () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two timestamp ranges are adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00, 2023-01-01T15:00:00]',
          '(2023-01-01T15:00:00, 2023-01-01T20:00:00)',
        ),
        true,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00.000, 2023-01-01T15:00:00.000]',
          '[2023-01-01T15:00:00.001, 2023-01-01T20:00:00.000]',
        ),
        true,
      );

      // Two timestamp ranges are not adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00, 2023-01-10T00:00:00]',
          '[2023-01-12T00:00:00, 2023-01-20T00:00:00]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00, 2023-01-10T00:00:00]',
          '[2023-01-21T00:00:00, 2023-01-30T00:00:00]',
        ),
        false,
      );
    });
  });

  group('DateRangeType timestamp with timezone tests', () {
    test('should successfuly create a range of timestamp with timezone type',
        () {
      RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      ) as DateRangeType;

      RangeType.createRange(
        range: '[2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z]',
      ) as DateRangeType;

      RangeType.createRange(
        range: '[2022-01-01T12:00:00+05:00, 2022-12-31T12:00:00-03]',
      ) as DateRangeType;
      RangeType.createRange(
        range: '[2022-01-01T12:00:00.999+05, 2022-12-31T12:00:00.999-03]',
      ) as DateRangeType;
    });

    test('should ensure that range is of date type', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      ) as DateRangeType;

      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z]',
      ) as DateRangeType;

      final range3 = RangeType.createRange(
        range: '[2022-01-01T12:00:00+05:00, 2022-12-31T12:00:00-03]',
      ) as DateRangeType;
      final range4 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999+05, 2022-12-31T12:00:00.999-03]',
      ) as DateRangeType;

      expect(range.rangeDataType, RangeDataType.timestamptz);
      expect(range2.rangeDataType, RangeDataType.timestamptz);
      expect(range3.rangeDataType, RangeDataType.timestamptz);
      expect(range4.rangeDataType, RangeDataType.timestamptz);
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      ) as DateRangeType;
      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00+05:00, 2022-12-31T12:00:00-03]',
      ) as DateRangeType;
      expect(
        range.rawRangeString,
        '[2022-01-01T12:00:00.999Z,2022-12-31T12:00:00.999Z]',
      );
      expect(
        range2.rawRangeString,
        '[2022-01-01T12:00:00.000+05:00,2022-12-31T12:00:00.000-03:00]',
      );
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      );
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      final range3 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      final range4 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
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

    test(
        'should return the correct value when calling isInRange() on a inclusive range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z]',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a exclusive range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z)',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a [) range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '[2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z)',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '[2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z)',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), true);
      expect(
          range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test(
        'should return the correct value when calling isInRange() on a (] range',
        () {
      // Without milliseconds
      final range = RangeType.createRange(
        range: '(2022-01-01T12:00:00Z, 2022-12-31T12:00:00Z]',
      );
      expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
      expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
      expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);

      // With milliseconds
      final range2 = RangeType.createRange(
        range: '(2022-01-01T12:00:00.999Z, 2022-12-31T12:00:00.999Z]',
      );
      expect(range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)), false);
      expect(range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)), true);
      expect(range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)), false);
      expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)), false);
    });

    test('should return true if two UTC timestamptz ranges overlap', () {
      bool checkDateTimeOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // DateTime ranges overlap completely
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T12:00:00Z]',
          '[2023-01-01T10:00:00Z, 2023-01-01T15:00:00Z]',
        ),
        true,
      );

      // One DateTime range is completely within the other
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T12:00:00Z]',
          '[2023-01-01T09:00:00Z, 2023-01-01T11:00:00Z]',
        ),
        true,
      );

      // DateTime ranges have the same start or end points
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T12:00:00Z]',
          '[2023-01-01T08:00:00Z, 2023-01-01T14:00:00Z]',
        ),
        true,
      );
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T12:00:00Z]',
          '[2023-01-01T05:00:00Z, 2023-01-01T08:00:00Z]',
        ),
        true,
      );

      // DateTime ranges touch but do not overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T12:00:00Z]',
          '(2023-01-01T12:00:00Z, 2023-01-01T16:00:00Z]',
        ),
        false,
      );

      // DateTime ranges don't overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00Z, 2023-01-01T10:00:00Z]',
          '[2023-01-01T11:00:00Z, 2023-01-01T15:00:00Z]',
        ),
        false,
      );
    });

    test('should return true if two timestamptz with tz offset ranges overlap',
        () {
      bool checkDateTimeOverlap(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.overlaps(r2);
      }

      // DateTime ranges overlap completely
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
          '[2023-01-01T10:00:00-01, 2023-01-01T15:00:00+01]',
        ),
        true,
      );

      // One DateTime range is completely within the other
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
          '[2023-01-01T09:00:00-01, 2023-01-01T11:00:00+01]',
        ),
        true,
      );

      // DateTime ranges have the same start or end points
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
          '[2023-01-01T08:00:00-01, 2023-01-01T14:00:00+01]',
        ),
        true,
      );
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
          '[2023-01-01T05:00:00+01, 2023-01-01T08:00:00-01]',
        ),
        true,
      );

      // DateTime ranges touch but do not overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
          '(2023-01-01T12:00:00-01, 2023-01-01T16:00:00+01]',
        ),
        false,
      );

      // DateTime ranges don't overlap
      expect(
        checkDateTimeOverlap(
          '[2023-01-01T08:00:00-01, 2023-01-01T10:00:00+01]',
          '[2023-01-01T11:00:00-01, 2023-01-01T15:00:00+01]',
        ),
        false,
      );
    });

    test(
        'should throw an Exception when checking if two ranges of different type overlap',
        () {
      final range1 = RangeType.createRange(
        range: '[2023-01-01T08:00:00Z, 2023-01-01T10:00:00Z]',
      );
      final range2 = RangeType.createRange(
        range: '[2023-01-01T08:00:00-03, 2023-01-01T10:00:00+05]',
      );
      final range3 = RangeType.createRange(range: '[10, 20]');

      expect(() => range1.overlaps(range3), throwsException);
      expect(() => range2.overlaps(range3), throwsException);
    });

    test('should return true if two UTC timestamp ranges are adjacent', () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two timestamp ranges are adjacent
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

      // Two timestamp ranges are not adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00Z, 2023-01-10T00:00:00Z]',
          '[2023-01-12T00:00:00Z, 2023-01-20T00:00:00Z]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00Z, 2023-01-10T00:00:00Z]',
          '[2023-01-21T00:00:00Z, 2023-01-30T00:00:00Z]',
        ),
        false,
      );
    });

    test(
        'should return true if two timestamptz with tz offset ranges are adjacent',
        () {
      bool checkAdjacency(String range1, String range2) {
        final r1 = RangeType.createRange(range: range1);
        final r2 = RangeType.createRange(range: range2);
        return r1.isAdjacent(r2);
      }

      // Two timestamp ranges are adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00-01, 2023-01-01T15:00:00+01]',
          '(2023-01-01T15:00:00+01, 2023-01-01T20:00:00-01)',
        ),
        true,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T12:00:00.000-01, 2023-01-01T15:00:00.000+01]',
          '[2023-01-01T15:00:00.001+01, 2023-01-01T20:00:00.000-01]',
        ),
        true,
      );

      // Two timestamp ranges are not adjacent
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00-01, 2023-01-10T00:00:00+01]',
          '[2023-01-12T00:00:00-01, 2023-01-20T00:00:00+01]',
        ),
        false,
      );
      expect(
        checkAdjacency(
          '[2023-01-01T00:00:00-01, 2023-01-10T00:00:00+01]',
          '[2023-01-21T00:00:00-01, 2023-01-30T00:00:00+01]',
        ),
        false,
      );
    });
  });

  group('comparable tests', () {
    group('IntegerRangeType comparable tests', () {
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        final comparable =
            RangeType.createRange(range: '[1, 10]').getComparable();

        expect(comparable, isA<RangeComparable<int>>());
      });

      test('should return the correct comparable when calling getComparable()',
          () {
        final comparable1 = RangeType.createRange(range: '[1, 10]')
            .getComparable() as RangeComparable<int>;
        final comparable2 = RangeType.createRange(range: '[1, 10)')
            .getComparable() as RangeComparable<int>;
        final comparable3 = RangeType.createRange(range: '(1, 10]')
            .getComparable() as RangeComparable<int>;
        final comparable4 = RangeType.createRange(range: '(1, 10)')
            .getComparable() as RangeComparable<int>;

        expect(comparable1.lowerRange, 1);
        expect(comparable1.upperRange, 10);

        expect(comparable2.lowerRange, 1);
        expect(comparable2.upperRange, 9);

        expect(comparable3.lowerRange, 2);
        expect(comparable3.upperRange, 10);

        expect(comparable4.lowerRange, 2);
        expect(comparable4.upperRange, 9);
      });

      test('should return true if a range is greater than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        expect(compare('[11, 20]', '[1, 10]'), true);
        expect(compare('[-5, 20]', '[1, 10]'), false);

        expect(compare('(10, 20]', '[10, 15]'), true);
        expect(compare('[10, 20]', '(10, 15]'), false);

        // Return true if lower bounds are equal but the upper bounds are greater
        expect(compare('[10, 20]', '[10, 15]'), true);
        expect(compare('(10, 20)', '(10, 15)'), true);

        // Return false if values are equal
        expect(compare('[1, 10]', '[1, 10]'), false);
        expect(compare('(1, 10)', '(1, 10)'), false);
      });

      test('should return true if a range is less than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(compare('[1, 10]', '[11, 20]'), true);
        expect(compare('[1, 10]', '[-5, 20]'), false);

        // Upper bound of range1 is less than upper bound of range2
        expect(compare('[10, 15]', '(10, 20]'), true);
        expect(compare('(10, 15]', '[10, 20]'), false);

        // Lower bounds are equal but the upper bound of range1 is less
        expect(compare('[10, 15]', '[10, 20]'), true);
        expect(compare('(10, 15)', '(10, 20)'), true);

        // Values are equal
        expect(compare('[1, 10]', '[1, 10]'), false);
        expect(compare('(1, 10)', '(1, 10)'), false);
      });

      test('should return true if a range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than or equal to lower bound of range2
        expect(compare('[1, 10]', '[11, 20]'), true);
        expect(compare('[1, 10]', '[-5, 20]'), false);

        // Upper bound of range1 is less than or equal to upper bound of range2
        expect(compare('[10, 15]', '(10, 20]'), true);
        expect(compare('(10, 15]', '[10, 20]'), false);

        // Lower bounds are equal but the upper bound of range1 is less or equal
        expect(compare('[10, 15]', '[10, 20]'), true);
        expect(compare('(10, 15)', '(10, 20)'), true);

        // Values are equal
        expect(compare('[1, 10]', '[1, 10]'), true);
        expect(compare('(1, 10)', '(1, 10)'), true);
      });

      test(
          'should return true if a range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than or equal to lower bound of range2
        expect(compare('[11, 20]', '[1, 10]'), true);
        expect(compare('[-5, 20]', '[1, 10]'), false);

        // Upper bound of range1 is greater than or equal to upper bound of range2
        expect(compare('(10, 20]', '[10, 15]'), true);
        expect(compare('[10, 20]', '(10, 15]'), false);

        // Lower bounds are equal but the upper bound of range1 is greater or equal
        expect(compare('[10, 20]', '[10, 15]'), true);
        expect(compare('(10, 20)', '(10, 15)'), true);

        // Values are equal
        expect(compare('[1, 10]', '[1, 10]'), true);
        expect(compare('(1, 10)', '(1, 10)'), true);
      });

      test('should return true if ranges are equal', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(compare('[10, 20]', '[10, 20]'), true);
        expect(compare('(10, 20]', '(10, 20]'), true);
        expect(compare('[10, 20)', '[10, 20)'), true);
        expect(compare('(10, 20)', '(10, 20)'), true);

        // Ranges cover same values
        expect(compare('[10, 20]', '(9, 21)'), true);

        // Ranges are different
        expect(compare('[10, 20]', '[30, 40]'), false);
      });
    });

    group('FloatRangeType comparable tests', () {
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        final comparable =
            RangeType.createRange(range: '[1.0, 5.0]').getComparable();

        expect(comparable, isA<RangeComparable<double>>());
      });

      test('should return the correct comparable when calling getComparable()',
          () {
        final comparable1 = RangeType.createRange(range: '[1.0, 5.0]')
            .getComparable() as RangeComparable<double>;
        final comparable2 = RangeType.createRange(range: '[1.0, 5.0)')
            .getComparable() as RangeComparable<double>;
        final comparable3 = RangeType.createRange(range: '(1.0, 5.0]')
            .getComparable() as RangeComparable<double>;
        final comparable4 = RangeType.createRange(range: '(1.0, 5.0)')
            .getComparable() as RangeComparable<double>;

        expect(comparable1.lowerRange, 1.0);
        expect(comparable1.upperRange, 5.0);

        expect(comparable2.lowerRange, 1.0);
        expect(comparable2.upperRange, 4.9);

        expect(comparable3.lowerRange, 1.1);
        expect(comparable3.upperRange, 5.0);

        expect(comparable4.lowerRange, 1.1);
        expect(comparable4.upperRange, 4.9);
      });

      test('should return true if a range is greater than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        expect(compare('[11.0, 20.0]', '[1.0, 10.0]'), true);
        expect(compare('[-5.0, 20.0]', '[1.0, 10.0]'), false);

        expect(compare('(10.0, 20.0]', '[10.0, 15.0]'), true);
        expect(compare('[10.0, 20.0]', '(10.0, 15.0]'), false);

        // Return true if lower bounds are equal but the upper bounds are greater
        expect(compare('[10.0, 20.0]', '[10.0, 15.0]'), true);
        expect(compare('(10.0, 20.0)', '(10.0, 15.0)'), true);

        // Return false if values are equal
        expect(compare('[1.0, 10.0]', '[1.0, 10.0]'), false);
        expect(compare('(1.0, 10.0)', '(1.0, 10.0)'), false);
      });

      test('should return true if a range is less than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(compare('[1.0, 10.0]', '[11.0, 20.0]'), true);
        expect(compare('[1.0, 10.0]', '[-5.0, 20.0]'), false);

        // Upper bound of range1 is less than upper bound of range2
        expect(compare('[10.0, 15.0]', '(10.0, 20.0]'), true);
        expect(compare('(10.0, 15.0]', '[10.0, 20.0]'), false);

        // Lower bounds are equal but the upper bound of range1 is less
        expect(compare('[10.0, 15.0]', '[10.0, 20.0]'), true);
        expect(compare('(10.0, 15.0)', '(10.0, 20.0)'), true);

        // Values are equal
        expect(compare('[1.0, 10.0]', '[1.0, 10.0]'), false);
        expect(compare('(1.0, 10.0)', '(1.0, 10.0)'), false);
      });

      test('should return true if a range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than or equal to lower bound of range2
        expect(compare('[1.0, 10.0]', '[11.0, 20.0]'), true);
        expect(compare('[1.0, 10.0]', '[-5.0, 20.0]'), false);

        // Upper bound of range1 is less than or equal to upper bound of range2
        expect(compare('[10.0, 15.0]', '(10.0, 20.0]'), true);
        expect(compare('(10.0, 15.0]', '[10.0, 20.0]'), false);

        // Lower bounds are equal but the upper bound of range1 is less or equal
        expect(compare('[10.0, 15.0]', '[10.0, 20.0]'), true);
        expect(compare('(10.0, 15.0)', '(10.0, 20.0)'), true);

        // Values are equal
        expect(compare('[1.0, 10.0]', '[1.0, 10.0]'), true);
        expect(compare('(1.0, 10.0)', '(1.0, 10.0)'), true);
      });

      test(
          'should return true if a range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than or equal to lower bound of range2
        expect(compare('[11.0, 20.0]', '[1.0, 10.0]'), true);
        expect(compare('[-5.0, 20.0]', '[1.0, 10.0]'), false);

        // Upper bound of range1 is greater than or equal to upper bound of range2
        expect(compare('(10.0, 20.0]', '[10.0, 15.0]'), true);
        expect(compare('[10.0, 20.0]', '(10.0, 15.0]'), false);

        // Lower bounds are equal but the upper bound of range1 is greater or equal
        expect(compare('[10.0, 20.0]', '[10.0, 15.0]'), true);
        expect(compare('(10.0, 20.0)', '(10.0, 15.0)'), true);

        // Values are equal
        expect(compare('[1.0, 10.0]', '[1.0, 10.0]'), true);
        expect(compare('(1.0, 10.0)', '(1.0, 10.0)'), true);
      });

      test('should return true if ranges are equal', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(compare('[10.0, 20.0]', '[10.0, 20.0]'), true);
        expect(compare('(10.0, 20.0]', '(10.0, 20.0]'), true);
        expect(compare('[10.0, 20.0)', '[10.0, 20.0)'), true);
        expect(compare('(10.0, 20.0)', '(10.0, 20.0)'), true);

        // Ranges cover same values
        expect(compare('[10.1, 19.9]', '(10.0, 20.0)'), true);

        // Ranges are different
        expect(compare('[10.0, 20.0]', '[30.0, 40.0]'), false);
      });
    });

    group('DateRangeType comparable tests', () {
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        final comparable =
            RangeType.createRange(range: '[2023-01-10, 2023-12-25]')
                .getComparable();

        expect(comparable, isA<RangeComparable<DateTime>>());
      });

      test('should return the correct comparable when calling getComparable()',
          () {
        final comparable1 =
            RangeType.createRange(range: '[2023-01-10, 2023-12-25]')
                .getComparable() as RangeComparable<DateTime>;
        final comparable2 =
            RangeType.createRange(range: '[2023-01-10, 2023-12-25)')
                .getComparable() as RangeComparable<DateTime>;
        final comparable3 =
            RangeType.createRange(range: '(2023-01-10, 2023-12-25]')
                .getComparable() as RangeComparable<DateTime>;
        final comparable4 =
            RangeType.createRange(range: '(2023-01-10, 2023-12-25)')
                .getComparable() as RangeComparable<DateTime>;

        const duration = Duration(days: 1);
        final lowerDt = DateTime.utc(2023, 1, 10);
        final upperDt = DateTime.utc(2023, 12, 25);

        expect(comparable1.lowerRange, lowerDt);
        expect(comparable1.upperRange, upperDt);

        expect(comparable2.lowerRange, lowerDt);
        expect(comparable2.upperRange, upperDt.subtract(duration));

        expect(comparable3.lowerRange, lowerDt.add(duration));
        expect(comparable3.upperRange, upperDt);

        expect(comparable4.lowerRange, lowerDt.add(duration));
        expect(comparable4.upperRange, upperDt.subtract(duration));
      });

      test('should return true if a date range is greater than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-01-02, 2023-01-15]', '[2022-12-01, 2023-01-01]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01, 2023-01-20]', '[2023-01-01, 2023-01-10]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01, 2023-01-15]', '[2023-01-01, 2023-01-10]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-10]'),
          false,
        );
      });

      test('should return true if a date range is less than the other', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2022-12-01, 2023-01-01]', '[2023-01-02, 2023-01-15]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-20]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-15]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-10]'),
          false,
        );
      });

      test(
          'should return true if a date range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-01-02, 2023-01-15]', '[2022-12-01, 2023-01-01]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01, 2023-01-20]', '[2023-01-01, 2023-01-10]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01, 2023-01-15]', '[2023-01-01, 2023-01-10]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-10]'),
          true,
        );
      });

      test(
          'should return true if a date range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2022-12-01, 2023-01-01]', '[2023-01-02, 2023-01-15]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-20]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-15]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-10]'),
          true,
        );
      });

      test('should return true if ranges are equal', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-10]'),
          true,
        );
        expect(
          compare('(2023-01-01, 2023-01-10]', '(2023-01-01, 2023-01-10]'),
          true,
        );
        expect(
          compare('[2023-01-01, 2023-01-10)', '[2023-01-01, 2023-01-10)'),
          true,
        );
        expect(
          compare('(2023-01-01, 2023-01-10)', '(2023-01-01, 2023-01-10)'),
          true,
        );

        // Ranges cover same values
        expect(
          compare('[2023-01-02, 2023-01-10]', '(2023-01-01, 2023-01-11)'),
          true,
        );

        // Ranges are different
        expect(
          compare('[2023-01-01, 2023-01-10]', '[2023-01-01, 2023-01-15]'),
          false,
        );
      });
    });

    group('DateRangeType timestamp comparable tests', () {
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        final comparable = RangeType.createRange(
                range: '[2023-01-10T12:00:00, 2023-12-25T15:00:00]')
            .getComparable();

        expect(comparable, isA<RangeComparable<DateTime>>());
      });

      test('should return the correct comparable when calling getComparable()',
          () {
        final comparable1 = RangeType.createRange(
                range: '[2023-01-10T12:00:00, 2023-12-25T15:00:00]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable2 = RangeType.createRange(
                range: '[2023-01-10T12:00:00, 2023-12-25T15:00:00)')
            .getComparable() as RangeComparable<DateTime>;
        final comparable3 = RangeType.createRange(
                range: '(2023-01-10T12:00:00, 2023-12-25T15:00:00]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable4 = RangeType.createRange(
                range: '(2023-01-10T12:00:00, 2023-12-25T15:00:00)')
            .getComparable() as RangeComparable<DateTime>;

        const duration = Duration(milliseconds: 1);
        final lowerDt = DateTime.utc(2023, 1, 10, 12, 0, 0, 0);
        final upperDt = DateTime.utc(2023, 12, 25, 15, 0, 0, 0);

        expect(comparable1.lowerRange, lowerDt);
        expect(comparable1.upperRange, upperDt);

        expect(comparable2.lowerRange, lowerDt);
        expect(comparable2.upperRange, upperDt.subtract(duration));

        expect(comparable3.lowerRange, lowerDt.add(duration));
        expect(comparable3.upperRange, upperDt);

        expect(comparable4.lowerRange, lowerDt.add(duration));
        expect(comparable4.upperRange, upperDt.subtract(duration));
      });

      test('should return true if a timestamp range is greater than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01, 2024-01-01T00:00:00]',
              '[2023-01-10T12:00:00, 2023-12-25T15:00:00]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-15T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-15T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          false,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-15T00:00:00, 2023-01-20T00:00:00]'),
          false,
        );
      });

      test(
          'should return true if a timestamp range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00, 2023-12-25T15:00:00]',
              '[2023-12-25T15:00:01, 2024-01-01T00:00:00]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-15T00:00:00]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-15T00:00:00]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00, 2023-01-20T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          false,
        );
      });

      test(
          'should return true if a timestamp range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01, 2024-01-01T00:00:00]',
              '[2023-01-10T12:00:00, 2023-12-25T15:00:00]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-15T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-15T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          true,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-15T00:00:00, 2023-01-20T00:00:00]'),
          false,
        );
      });

      test('should return true if a timestamp range is less than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00, 2023-12-25T15:00:00]',
              '[2023-12-25T15:00:01, 2024-01-01T00:00:00]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-15T00:00:00]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-15T00:00:00]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00, 2023-01-10T12:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          false,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00, 2023-01-20T00:00:00]',
              '[2023-01-01T00:00:00, 2023-01-10T12:00:00]'),
          false,
        );
      });

      test('should return true if ranges are equal', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(
          compare(
            '[2023-01-01T12:00:00, 2023-01-10T15:00:00]',
            '[2023-01-01T12:00:00, 2023-01-10T15:00:00]',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00, 2023-01-10T15:00:00]',
            '(2023-01-01T12:00:00, 2023-01-10T15:00:00]',
          ),
          true,
        );
        expect(
          compare(
            '[2023-01-01T12:00:00, 2023-01-10T15:00:00)',
            '[2023-01-01T12:00:00, 2023-01-10T15:00:00)',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00, 2023-01-10T15:00:00)',
            '(2023-01-01T12:00:00, 2023-01-10T15:00:00)',
          ),
          true,
        );

        // Ranges cover same values
        expect(
          compare(
            '[2023-01-01T12:00:00.001, 2023-01-10T14:59:59.999]',
            '(2023-01-01T12:00:00, 2023-01-10T15:00:00)',
          ),
          true,
        );

        // Ranges are different
        expect(
          compare(
            '[2023-01-01T12:00:00, 2023-01-10T15:00:00]',
            '[2023-01-01T18:00:00, 2023-01-15T23:00:00]',
          ),
          false,
        );
      });
    });

    group('DateRangeType timestamptz comparable tests', () {
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        final comparable = RangeType.createRange(
                range: '[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]')
            .getComparable();

        final comparable2 = RangeType.createRange(
                range: '[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]')
            .getComparable();

        expect(comparable, isA<RangeComparable<DateTime>>());
        expect(comparable2, isA<RangeComparable<DateTime>>());
      });

      test(
          'should return the correct comparable when calling getComparable() with UTC timezones',
          () {
        final comparable1 = RangeType.createRange(
                range: '[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable2 = RangeType.createRange(
                range: '[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z)')
            .getComparable() as RangeComparable<DateTime>;
        final comparable3 = RangeType.createRange(
                range: '(2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable4 = RangeType.createRange(
                range: '(2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z)')
            .getComparable() as RangeComparable<DateTime>;

        const duration = Duration(milliseconds: 1);
        final lowerDt = DateTime.utc(2023, 1, 10, 12, 0, 0, 0);
        final upperDt = DateTime.utc(2023, 12, 25, 15, 0, 0, 0);

        expect(comparable1.lowerRange, lowerDt);
        expect(comparable1.upperRange, upperDt);

        expect(comparable2.lowerRange, lowerDt);
        expect(comparable2.upperRange, upperDt.subtract(duration));

        expect(comparable3.lowerRange, lowerDt.add(duration));
        expect(comparable3.upperRange, upperDt);

        expect(comparable4.lowerRange, lowerDt.add(duration));
        expect(comparable4.upperRange, upperDt.subtract(duration));
      });

      test(
          'should return the correct comparable when calling getComparable() with timezone offsets',
          () {
        final comparable1 = RangeType.createRange(
                range: '[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable2 = RangeType.createRange(
                range: '[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05)')
            .getComparable() as RangeComparable<DateTime>;
        final comparable3 = RangeType.createRange(
                range: '(2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]')
            .getComparable() as RangeComparable<DateTime>;
        final comparable4 = RangeType.createRange(
                range: '(2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05)')
            .getComparable() as RangeComparable<DateTime>;

        const duration = Duration(milliseconds: 1);
        final lowerDt = DateTime.parse('2023-01-10T12:00:00.000-03');
        final upperDt = DateTime.parse('2023-12-25T15:00:00.000+05');

        expect(comparable1.lowerRange, lowerDt);
        expect(comparable1.upperRange, upperDt);

        expect(comparable2.lowerRange, lowerDt);
        expect(comparable2.upperRange, upperDt.subtract(duration));

        expect(comparable3.lowerRange, lowerDt.add(duration));
        expect(comparable3.upperRange, upperDt);

        expect(comparable4.lowerRange, lowerDt.add(duration));
        expect(comparable4.upperRange, upperDt.subtract(duration));
      });

      test(
          'should return true if an UTC timestamptz range is greater than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01Z, 2024-01-01T00:00:00Z]',
              '[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          false,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-15T00:00:00Z, 2023-01-20T00:00:00Z]'),
          false,
        );
      });

      test(
          'should return true if an UTC timestamptz range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]',
              '[2023-12-25T15:00:01Z, 2024-01-01T00:00:00Z]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00Z, 2023-01-20T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          false,
        );
      });

      test(
          'should return true if an UTC timestamptz range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01Z, 2024-01-01T00:00:00Z]',
              '[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          true,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-15T00:00:00Z, 2023-01-20T00:00:00Z]'),
          false,
        );
      });

      test(
          'should return true if an UTC timestamptz range is less than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00Z, 2023-12-25T15:00:00Z]',
              '[2023-12-25T15:00:01Z, 2024-01-01T00:00:00Z]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-15T00:00:00Z]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          false,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00Z, 2023-01-20T00:00:00Z]',
              '[2023-01-01T00:00:00Z, 2023-01-10T12:00:00Z]'),
          false,
        );
      });

      test('should return true if UTC timestamptz ranges are equal', () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(
          compare(
            '[2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z]',
            '[2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z]',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z]',
            '(2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z]',
          ),
          true,
        );
        expect(
          compare(
            '[2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z)',
            '[2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z)',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z)',
            '(2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z)',
          ),
          true,
        );

        // Ranges cover same values
        expect(
          compare(
            '[2023-01-01T12:00:00.001Z, 2023-01-10T14:59:59.999Z]',
            '(2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z)',
          ),
          true,
        );

        // Ranges are different
        expect(
          compare(
            '[2023-01-01T12:00:00Z, 2023-01-10T15:00:00Z]',
            '[2023-01-01T18:00:00Z, 2023-01-15T23:00:00Z]',
          ),
          false,
        );
      });

      test(
          'should return true if a timestamptz with tz offset range is greater than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 > c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01-03, 2024-01-01T00:00:00+05]',
              '[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          false,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-15T00:00:00-03, 2023-01-20T00:00:00+05]'),
          false,
        );
      });

      test(
          'should return true if a timestamptz with tz offset range is less than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 <= c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]',
              '[2023-12-25T15:00:01-03, 2024-01-01T00:00:00+05]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00-03, 2023-01-20T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          false,
        );
      });

      test(
          'should return true if a timestamptz with a tz offset range is greater than or equal to the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 >= c2;
        }

        // Lower bound of range1 is greater than lower bound of range2
        expect(
          compare('[2023-12-25T15:00:01-03, 2024-01-01T00:00:00+05]',
              '[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]'),
          true,
        );

        // Upper bound of range1 is greater than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is greater
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          true,
        );

        // Smaller ranges
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-15T00:00:00-03, 2023-01-20T00:00:00+05]'),
          false,
        );
      });

      test(
          'should return true if a timestamptz with tz offset range is less than the other',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 < c2;
        }

        // Lower bound of range1 is less than lower bound of range2
        expect(
          compare('[2023-01-10T12:00:00-03, 2023-12-25T15:00:00+05]',
              '[2023-12-25T15:00:01-03, 2024-01-01T00:00:00+05]'),
          true,
        );

        // Upper bound of range1 is less than upper bound of range2
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]'),
          true,
        );

        // Lower bounds are equal but the upper bound of range1 is less
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-15T00:00:00+05]'),
          true,
        );

        // Values are equal
        expect(
          compare('[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          false,
        );

        // Greater ranges
        expect(
          compare('[2023-01-15T00:00:00-03, 2023-01-20T00:00:00+05]',
              '[2023-01-01T00:00:00-03, 2023-01-10T12:00:00+05]'),
          false,
        );
      });

      test('should return true if timestamptz ranges with tz offset are equal',
          () {
        bool compare(String range1, String range2) {
          final c1 = RangeType.createRange(range: range1).getComparable();
          final c2 = RangeType.createRange(range: range2).getComparable();

          return c1 == c2;
        }

        // Values are equal
        expect(
          compare(
            '[2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05]',
            '[2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05]',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05]',
            '(2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05]',
          ),
          true,
        );
        expect(
          compare(
            '[2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05)',
            '[2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05)',
          ),
          true,
        );
        expect(
          compare(
            '(2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05)',
            '(2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05)',
          ),
          true,
        );

        // Ranges cover same values
        expect(
          compare(
            '[2023-01-01T12:00:00.001-03, 2023-01-10T14:59:59.999+05]',
            '(2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05)',
          ),
          true,
        );

        // Ranges are different
        expect(
          compare(
            '[2023-01-01T12:00:00-03, 2023-01-10T15:00:00+05]',
            '[2023-01-01T18:00:00-03, 2023-01-15T23:00:00+05]',
          ),
          false,
        );
      });
    });
  });
}
