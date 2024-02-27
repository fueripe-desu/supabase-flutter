import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

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

  test(
      'should throw an Exception when trying to create a range without a force type',
      () {
    expect(() => RangeType.createRange(range: ''), throwsRangeError);
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

  group('infinite range tests', () {
    late final IntegerRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
          forceType: RangeDataType.integer,
        ) as IntegerRangeType;
      };
    });

    test(
        'should throw an Exception when both bounds are infinite without a force type',
        () {
      expect(
        () => RangeType.createRange(range: '[-infinity, infinity]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception when the lower bound is infinite and the upper bound is unbounded without force type',
        () {
      expect(
        () => RangeType.createRange(range: '[-infinity,]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception when the lower bound is unbounded and the upper bound is infinite without force type',
        () {
      expect(
        () => RangeType.createRange(range: '[,infinity]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception when trying to create a range with \'infinity\' in the lower bound',
        () {
      expect(
        () => RangeType.createRange(range: '[infinity,]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception when trying to create a range with \'-infinity\' in the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[,-infinity]'),
        throwsException,
      );
    });

    test('should be able to create an infinte range', () {
      expect(() => createRange('[-infinity, infinity]'), returnsNormally);
    });

    test('should ensure that the infinite range is of integer type', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.rangeDataType, RangeDataType.integer);
    });

    test('should be created with the correct inclusivity', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.lowerRangeInclusive, false);
      expect(range.upperRangeInclusive, false);
    });

    test('should be created with the lower and upper bound values', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.lowerRange, null);
      expect(range.upperRange, null);
    });

    test('should return true when checking if a bound is infinite', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.isLowerBoundInfinite, true);
      expect(range.isUpperBoundInfinite, true);
    });

    test('should return false when checking if an infinite range is empty', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.isEmpty, false);
    });

    test('should return the correct raw range string', () {
      final range = createRange('[-infinity, infinity]');
      expect(range.rawRangeString, '(-infinity,infinity)');
    });

    test('should return the correct comparable', () {
      final comparable = createRange('[-infinity, infinity]').getComparable();
      expect(comparable.lowerRange, null);
      expect(comparable.upperRange, null);
      expect(comparable.rangeType, RangeDataType.integer);
    });
  });
}
