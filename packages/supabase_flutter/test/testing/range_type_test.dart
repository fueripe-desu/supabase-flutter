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
  });
}
