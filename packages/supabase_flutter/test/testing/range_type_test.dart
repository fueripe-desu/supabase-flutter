import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_comparable.dart';
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
      expect(
        () => RangeType.createRange(range: '[1, 10]'),
        returnsNormally,
      );

      expect(
        RangeType.createRange(range: '[1, 10]'),
        isA<IntegerRangeType>(),
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[20, 10]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound with force type',
        () {
      expect(
        () => RangeType.createRange(
          range: '[20, 10]',
          forceType: RangeDataType.integer,
        ),
        throwsException,
      );
    });

    test(
        'should create a range successfuly if the lower bound is equal to the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[10, 10]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(10, 10]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '[10, 10)'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(10, 10)'),
        returnsNormally,
      );
    });

    test('should ensure that range is of integer type', () {
      final range = RangeType.createRange(range: '[1, 10]');
      expect(range.rangeDataType, RangeDataType.integer);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[0, 5.0]'),
        throwsException,
      );
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[1, 10]');
      expect(range.rawRangeString, '[1,10]');
    });

    test('should remove spaces from raw range string', () {
      final range = RangeType.createRange(range: '[      1, 10       ]');
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

    group('unbounded range tests', () {
      late final IntegerRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.integer,
          ) as IntegerRangeType;
        };
      });

      test('should be able to create a [,] range', () {
        expect(() => createRange('[,]'), returnsNormally);
        expect(createRange('[,]'), isA<IntegerRangeType>());
      });

      test('should be able to create a [b,] range', () {
        expect(() => createRange('[10,]'), returnsNormally);
        expect(createRange('[10,]'), isA<IntegerRangeType>());
      });

      test('should be able to create a [,b] range', () {
        expect(() => createRange('[,20]'), returnsNormally);
        expect(createRange('[,20]'), isA<IntegerRangeType>());
      });

      test('should create a [,] range with the correct type', () {
        final range = createRange('[,]');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test('should create a [b,] range with the correct type', () {
        final range = createRange('[10,]');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test('should create a [,b] range with the correct type', () {
        final range = createRange('[,20]');
        expect(range.rangeDataType, RangeDataType.integer);
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
        final range = createRange('[10,]');
        expect(range.lowerRange, 10);
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values',
          () {
        final range = createRange('[,20]');
        expect(range.lowerRange, null);
        expect(range.upperRange, 20);
      });

      test('should create a [,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[10,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,20]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [,] range with the correct raw range string', () {
        final range = createRange('[,]');
        expect(range.rawRangeString, '(,)');
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[10,]');
        expect(range.rawRangeString, '[10,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,20]');
        expect(range.rawRangeString, '(,20]');
      });

      test('should return false when checking if a [,] range is empty', () {
        final range = createRange('[,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [b,] range is empty', () {
        final range = createRange('[10,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [,b] range is empty', () {
        final range = createRange('[,20]');
        expect(range.isEmpty, false);
      });
    });

    group('type inference', () {
      late final IntegerRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
          ) as IntegerRangeType;
        };
      });

      test(
          'should be able to infer the type when only the lower bound is specified',
          () {
        final range = createRange('[10,]');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test(
          'should be able to infer the type when only the upper bound is specified',
          () {
        final range = createRange('[,20]');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified',
          () {
        final range = createRange('[10,20]');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test('should throw an Exception when infering the type of a [,] range',
          () {
        expect(() => createRange('[,]'), throwsException);
      });

      test('should create a [b,] range with the correct lower and upper values',
          () {
        final range = createRange('[10,]');
        expect(range.lowerRange, 10);
        expect(range.upperRange, null);
      });

      test('should create a [,b] range with the correct lower and upper values',
          () {
        final range = createRange('[,20]');
        expect(range.lowerRange, null);
        expect(range.upperRange, 20);
      });

      test(
          'should create a [b,b] range with the correct lower and upper values',
          () {
        final range = createRange('[10,20]');
        expect(range.lowerRange, 10);
        expect(range.upperRange, 20);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        final range = createRange('[10,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct correct inclusivity',
          () {
        final range = createRange('[,20]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,b] range with the correct inclusivity', () {
        final range = createRange('[10,20]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[10,]');
        expect(range.rawRangeString, '[10,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,20]');
        expect(range.rawRangeString, '(,20]');
      });

      test('should create a [b,b] range with the correct raw range string', () {
        final range = createRange('[10,20]');
        expect(range.rawRangeString, '[10,20]');
      });

      test('should return false when cheking if a [b,] range is empty', () {
        final range = createRange('[10,)');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [,b] range is empty', () {
        final range = createRange('(,20]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [b,b] range is empty', () {
        final range = createRange('[10,20]');
        expect(range.isEmpty, false);
      });
    });

    group('isInRange() tests', () {
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

    group('isInRange() unbounded tests', () {
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
          'should return true when checking if any value is in range of [,] range',
          () {
        final range = createRange('[,]');

        expect(range.isInRange(10), true);
        expect(range.isInRange(9), true);
        expect(range.isInRange(20), true);
      });

      test(
          'should return true when checking if a value bigger than the lower range is within a [b,] range',
          () {
        final range = createRange('[10,]');

        expect(range.isInRange(20), true);
        expect(range.isInRange(10), true);
        expect(range.isInRange(50), true);
      });

      test(
          'should return false when checking if a value less than the lower range is within a [b,] range',
          () {
        final range = createRange('[10,]');

        expect(range.isInRange(9), false);
        expect(range.isInRange(4), false);
        expect(range.isInRange(-5), false);
      });

      test(
          'should return true when checking if a value less than the upper range is within a [,b] range',
          () {
        final range = createRange('[,20]');

        expect(range.isInRange(10), true);
        expect(range.isInRange(20), true);
        expect(range.isInRange(-5), true);
      });

      test(
          'should return false when checking if a value bigger than the upper range is within a [,b] range',
          () {
        final range = createRange('[,20]');

        expect(range.isInRange(30), false);
        expect(range.isInRange(21), false);
        expect(range.isInRange(50), false);
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
        expect(checkOverlap('[1, 10]', '[5, 15]'), true);
      });

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(checkOverlap('[1, 10]', '[3, 8]'), true);
      });

      test('should return true if ranges have the same start or end points ',
          () {
        // Ranges have the same start or end points
        expect(checkOverlap('[1, 10]', '[10, 15]'), true);
        expect(checkOverlap('[1, 10]', '[0, 5]'), true);
      });

      test('should return false if ranges touch but do not overlap', () {
        // Ranges touch but do not overlap
        expect(checkOverlap('[1, 10]', '(10, 20]'), false);
      });

      test('should return false if ranges do not overlap', () {
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
    });

    group('overlaps() unbounded tests', () {
      late final bool Function(String range1, String range2) checkOverlap;

      setUpAll(() {
        checkOverlap = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.integer,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.integer,
          );
          return r1.overlaps(r2);
        };
      });

      test('should return true when checking if a [,] range overlaps any other',
          () {
        // Ranges overlap because an unbounded range overlaps any other range
        expect(checkOverlap('[,]', '[100,200]'), true);
      });

      test(
          'should return true if the upper bound is greater than the other lower bound in a [,b] range',
          () {
        // Ranges overlap because 10 > 5
        expect(checkOverlap('[,10]', '[5,15]'), true);
      });

      test(
          'should return false if the upper bound is less than the other lower bound in a [,b] range',
          () {
        // Ranges do not overlap because 10 < 20
        expect(checkOverlap('[,10]', '[20,30]'), false);
      });

      test(
          'should return true if the lower bound is less than the other in a [b,] range',
          () {
        // Ranges overlap because 10 < 15
        expect(checkOverlap('[10,]', '[15,20]'), true);
      });

      test(
          'should return false if the lower bound is greater than the other upper bound in a [b,] range',
          () {
        // Ranges do not overlap because 10 > 8
        expect(checkOverlap('[10,]', '[1,8]'), false);
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
        // Two integer ranges are adjacent
        expect(checkAdjacency('[1, 10]', '(10, 20)'), true);
        expect(checkAdjacency('[1, 10]', '[11, 20]'), true);
      });

      test('should return false if ranges are not adjacent', () {
        // Two integer ranges are not adjacent
        expect(checkAdjacency('[1, 10]', '[12, 20]'), false);
        expect(checkAdjacency('[1, 10]', '[21, 30]'), false);
      });
    });

    group('isAdjacent() unbounded tests', () {
      late final bool Function(String range1, String range2) checkAdjacency;

      setUpAll(() {
        checkAdjacency = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.integer,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.integer,
          );
          return r1.isAdjacent(r2);
        };
      });
      test('should return false if unbounded ranges are tested for adjacency',
          () {
        expect(checkAdjacency('[,]', '[,]'), false);
        expect(checkAdjacency('[,]', '[5,15]'), false);
        expect(checkAdjacency('[,15]', '[5,15]'), false);
        expect(checkAdjacency('[5,]', '[5,15]'), false);
      });
    });

    group('getComparable() tests', () {
      late final RangeComparable<int> Function(String range) getComparable;

      setUpAll(() {
        getComparable = (String range) {
          return RangeType.createRange(range: range).getComparable()
              as RangeComparable<int>;
        };
      });
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        expect(getComparable('[1, 10]'), isA<RangeComparable<int>>());
      });

      test('should return the correct comparable on [] ranges', () {
        final comparable = getComparable('[1, 10]');

        expect(comparable.lowerRange, 1);
        expect(comparable.upperRange, 10);
      });

      test('should return the correct comparable on [) ranges', () {
        final comparable = getComparable('[1, 10)');

        expect(comparable.lowerRange, 1);
        expect(comparable.upperRange, 9);
      });

      test('should return the correct comparable on (] ranges', () {
        final comparable = getComparable('(1, 10]');

        expect(comparable.lowerRange, 2);
        expect(comparable.upperRange, 10);
      });

      test('should return the correct comparable on () ranges', () {
        final comparable = getComparable('(1, 10)');

        expect(comparable.lowerRange, 2);
        expect(comparable.upperRange, 9);
      });
    });

    group('comparison tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (IntegerRangeType, IntegerRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(range: range1);
          final r2 = RangeType.createRange(range: range2);

          return (r1, r2) as (IntegerRangeType, IntegerRangeType);
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });

      group('greater than tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 1
          expect(gt('[11, 20]', '[1, 10]'), true);
          expect(gt('[15, 20]', '[1, 10]'), true);
        });

        test('should return false when the lower bound is less than the other',
            () {
          // Lower bounds are less than 1
          expect(gt('[-5, 20]', '[1, 10]'), false);
          expect(gt('[-1, 20]', '[1, 10]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Lower bounds have different inclusivity
          expect(gt('(10, 20]', '[10, 15]'), true);
          expect(gt('[10, 20]', '(10, 15]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(gt('[10, 20]', '[10, 15]'), true);
          expect(gt('(10, 20)', '(10, 15)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(gt('[10, 12]', '[10, 15]'), false);
          expect(gt('(10, 12)', '(10, 15)'), false);
        });

        test('should return false if values are equal', () {
          // Values are equal
          expect(gt('[1, 10]', '[1, 10]'), false);
          expect(gt('(1, 10)', '(1, 10)'), false);
        });
      });

      group('greater than or equal to tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 1
          expect(gte('[11, 20]', '[1, 10]'), true);
          expect(gte('[15, 20]', '[1, 10]'), true);
        });

        test('should return false if the lower bound is less than the other',
            () {
          // Lower bounds are less than 1
          expect(gte('[-5, 20]', '[1, 10]'), false);
          expect(gte('[-1, 20]', '[1, 10]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(gte('(10, 20]', '[10, 15]'), true);
          expect(gte('[10, 20]', '(10, 15]'), false);
        });

        test(
            'should true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bound of is greater or equal
          expect(gte('[10, 20]', '[10, 15]'), true);
          expect(gte('(10, 20)', '(10, 15)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bound of is greater or equal
          expect(gte('[10, 11]', '[10, 15]'), false);
          expect(gte('(10, 13)', '(10, 15)'), false);
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(gte('[1, 10]', '[1, 10]'), true);
          expect(gte('(1, 10)', '(1, 10)'), true);
        });
      });

      group('less than tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 11
          expect(lt('[1, 10]', '[11, 20]'), true);
          expect(lt('[5, 10]', '[11, 20]'), true);
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than -5
          expect(lt('[1, 10]', '[-5, 20]'), false);
          expect(lt('[5, 10]', '[-5, 20]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(lt('[10, 15]', '(10, 20]'), true);
          expect(lt('(10, 15]', '[10, 20]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(lt('[10, 15]', '[10, 20]'), true);
          expect(lt('(10, 15)', '(10, 20)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(lt('[10, 25]', '[10, 20]'), false);
          expect(lt('(10, 25)', '(10, 20)'), false);
        });

        test('should return false if ranges are equal', () {
          // Values are equal
          expect(lt('[1, 10]', '[1, 10]'), false);
          expect(lt('(1, 10)', '(1, 10)'), false);
        });
      });

      group('less than or equal to tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 11
          expect(lte('[1, 10]', '[11, 20]'), true);
          expect(lte('[5, 10]', '[11, 20]'), true);
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than -5
          expect(lte('[1, 10]', '[-5, 20]'), false);
          expect(lte('[5, 10]', '[-5, 20]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(lte('[10, 15]', '(10, 20]'), true);
          expect(lte('(10, 15]', '[10, 20]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(lte('[10, 15]', '[10, 20]'), true);
          expect(lte('(10, 15)', '(10, 20)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(lte('[10, 25]', '[10, 20]'), false);
          expect(lte('(10, 25)', '(10, 20)'), false);
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(lte('[1, 10]', '[1, 10]'), true);
          expect(lte('(1, 10)', '(1, 10)'), true);
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal', () {
          // Values are equal
          expect(ceq('[10, 20]', '[10, 20]'), true);
          expect(ceq('(10, 20]', '(10, 20]'), true);
          expect(ceq('[10, 20)', '[10, 20)'), true);
          expect(ceq('(10, 20)', '(10, 20)'), true);
        });

        test('should return true if the ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[10, 20]', '(9, 21)'), true);
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(ceq('[10, 20]', '[30, 40]'), false);
        });
      });
    });

    group('comparison unbounded tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (IntegerRangeType, IntegerRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.integer,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.integer,
          );

          return (r1, r2) as (IntegerRangeType, IntegerRangeType);
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });
      group('greater than tests', () {
        test(
            'should return false when checking if a [,] range is greater than a [b,b] range',
            () {
          expect(gt('[,]', '[5,15]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than a [,b] range',
            () {
          expect(gt('[,]', '[,20]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than a [b,] range',
            () {
          expect(gt('[,]', '[10,]'), false);
        });

        test(
            'should return false when checking if a [,] range is greater than other [,] range',
            () {
          expect(gt('[,]', '[,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3,]', '[2,15]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 == 3
          expect(gt('[3,]', '[3,15]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 3 < 4
          expect(gt('[3,]', '[4,15]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3,]', '[2,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 == 3
          expect(gt('[3,]', '[3,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 < 4
          expect(gt('[3,]', '[4,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3,]', '[,2]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 3 == 3
          expect(gt('[3,]', '[,3]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 < 4
          expect(gt('[3,]', '[,4]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gt('[3,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7]', '[4,6]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7]', '[4,7]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7]', '[4,8]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7]', '[6,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7]', '[7,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7]', '[8,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7]', '[6,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7]', '[7,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7]', '[8,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 7 > 6
          expect(gt('[,7]', '[,6]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7]', '[,7]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7]', '[,8]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gt('[,7]', '[,]'), false);
        });
      });
      group('greater than or equal to tests', () {
        test(
            'should return false when checking if a [,] range is greater than or equal to a [b,b] range',
            () {
          expect(gte('[,]', '[5,15]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to a [,b] range',
            () {
          expect(gte('[,]', '[,20]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than or equal to [b,] a range',
            () {
          expect(gte('[,]', '[10,]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to other [,] range',
            () {
          expect(gte('[,]', '[,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3,]', '[2,15]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Equal to because 3 == 3
          expect(gte('[3,]', '[3,15]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 3 < 4
          expect(gte('[3,]', '[4,15]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3,]', '[2,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Equal to because 3 == 3
          expect(gte('[3,]', '[3,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 < 4
          expect(gte('[3,]', '[4,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3,]', '[,2]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 3 == 3
          expect(gte('[3,]', '[,3]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 < 4
          expect(gte('[3,]', '[,4]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gte('[3,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7]', '[4,6]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7]', '[4,7]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7]', '[4,8]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7]', '[6,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7]', '[7,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7]', '[8,20]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7]', '[6,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7]', '[7,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7]', '[8,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 7 > 6
          expect(gte('[,7]', '[,6]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Equal to because 7 == 7
          expect(gte('[,7]', '[,7]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7]', '[,8]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gte('[,7]', '[,]'), false);
        });
      });

      group('less than tests', () {
        test(
            'should return true when checking if a [,] range is less than a [b,b] range',
            () {
          expect(lt('[,]', '[5,15]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than a [,b] range',
            () {
          expect(lt('[,]', '[,20]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than a [b,] range',
            () {
          expect(lt('[,]', '[10,]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than other [,] range',
            () {
          expect(lt('[,]', '[,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 3 > 2
          expect(lt('[3,]', '[2,15]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 3 == 3
          expect(lt('[3,]', '[3,15]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 3 < 4
          expect(lt('[3,]', '[4,15]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 3 > 2
          expect(lt('[3,]', '[2,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 3 == 3
          expect(lt('[3,]', '[3,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 3 < 4
          expect(lt('[3,]', '[4,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 3 > 2
          expect(lt('[3,]', '[,2]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 3 == 3
          expect(lt('[3,]', '[,3]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 3 < 4
          expect(lt('[3,]', '[,4]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lt('[3,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7]', '[4,6]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7]', '[4,7]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7]', '[4,8]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7]', '[6,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7]', '[7,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7]', '[8,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7]', '[6,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7]', '[7,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7]', '[8,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 7 > 6
          expect(lt('[,7]', '[,6]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 7 == 7
          expect(lt('[,7]', '[,7]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7]', '[,8]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lt('[,7]', '[,]'), true);
        });
      });

      group('less than or equal to tests', () {
        test(
            'should return true when checking if a [,] range is less than or equal to a [b,b] range',
            () {
          expect(lte('[,]', '[5,15]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than or equal to a [,b] range',
            () {
          expect(lte('[,]', '[,20]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to a [b,] range',
            () {
          expect(lte('[,]', '[10,]'), true);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to other [,] range',
            () {
          expect(lte('[,]', '[,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 3 > 2
          expect(lte('[3,]', '[2,15]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 3 == 3
          expect(lte('[3,]', '[3,15]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 3 < 4
          expect(lte('[3,]', '[4,15]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 3 > 2
          expect(lte('[3,]', '[2,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 3 == 3
          expect(lte('[3,]', '[3,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 3 < 4
          expect(lte('[3,]', '[4,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 3 > 2
          expect(lte('[3,]', '[,2]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 3 == 3
          expect(lte('[3,]', '[,3]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 3 < 4
          expect(lte('[3,]', '[,4]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lte('[3,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7]', '[4,6]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7]', '[4,7]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7]', '[4,8]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7]', '[6,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7]', '[7,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7]', '[8,20]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7]', '[6,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7]', '[7,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7]', '[8,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 7 > 6
          expect(lte('[,7]', '[,6]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 7 == 7
          expect(lte('[,7]', '[,7]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7]', '[,8]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lte('[,7]', '[,]'), true);
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal with the same inclusivity',
            () {
          // Values are equal
          expect(ceq('[10,]', '[10,]'), true);
          expect(ceq('[,20]', '[,20]'), true);
          expect(ceq('[,]', '[,]'), true);
        });

        test(
            'should return true if [b,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[10,]', '[10,]'), true);
          expect(ceq('(10,]', '(10,]'), true);
          expect(ceq('[10,)', '[10,)'), true);
          expect(ceq('(10,)', '(10,)'), true);
        });

        test(
            'should return true if [,b] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,20]', '[,20]'), true);
          expect(ceq('(,20]', '(,20]'), true);
          expect(ceq('[,20)', '[,20)'), true);
          expect(ceq('(,20)', '(,20)'), true);
        });

        test(
            'should return true if [,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,]', '[,]'), true);
          expect(ceq('(,]', '(,]'), true);
          expect(ceq('[,)', '[,)'), true);
          expect(ceq('(,)', '(,)'), true);
        });

        test('should return true if a [,] range is compared against a (,)', () {
          // Values are equal
          expect(ceq('[,]', '(,)'), true);
        });

        test('should return true if the [b,] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[10,]', '(9,)'), true);
        });

        test('should return true if the [,b] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[,20]', '(,21)'), true);
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(ceq('[10,]', '[30,]'), false);
          expect(ceq('[,20]', '[,40]'), false);
        });
      });
    });
  });

  group('FloatRangeType tests', () {
    test('should successfuly create a range of float type', () {
      expect(
        () => RangeType.createRange(range: '[1.5, 10.5]'),
        returnsNormally,
      );

      expect(
        RangeType.createRange(range: '[1.5, 10.5]'),
        isA<FloatRangeType>(),
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[20.5, 10.5]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound with force type',
        () {
      expect(
        () => RangeType.createRange(
          range: '[20.5, 10.5]',
          forceType: RangeDataType.float,
        ),
        throwsException,
      );
    });

    test(
        'should create a range successfuly if the lower bound is equal to the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[10.5, 10.5]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(10.5, 10.5]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '[10.5, 10.5)'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(10.5, 10.5)'),
        returnsNormally,
      );
    });

    test('should ensure that range is of float type', () {
      final range = RangeType.createRange(range: '[1.5, 10.5]');
      expect(range.rangeDataType, RangeDataType.float);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[5.0, 2022-01-01]'),
        throwsException,
      );
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[1.5, 10.5]');
      expect(range.rawRangeString, '[1.5,10.5]');
    });

    test('should remove spaces from raw range string', () {
      final range = RangeType.createRange(range: '[      1.5, 10.5       ]');
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

    group('unbounded range tests', () {
      late final FloatRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.float,
          ) as FloatRangeType;
        };
      });

      test('should be able to create a [,] range', () {
        expect(() => createRange('[,]'), returnsNormally);
        expect(createRange('[,]'), isA<FloatRangeType>());
      });

      test('should be able to create a [b,] range', () {
        expect(() => createRange('[10.5,]'), returnsNormally);
        expect(createRange('[10.5,]'), isA<FloatRangeType>());
      });

      test('should be able to create a [,b] range', () {
        expect(() => createRange('[,20.5]'), returnsNormally);
        expect(createRange('[,20.5]'), isA<FloatRangeType>());
      });

      test('should create a [,] range with the correct type', () {
        final range = createRange('[,]');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test('should create a [b,] range with the correct type', () {
        final range = createRange('[10.5,]');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test('should create a [,b] range with the correct type', () {
        final range = createRange('[,20.5]');
        expect(range.rangeDataType, RangeDataType.float);
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
        final range = createRange('[10.5,]');
        expect(range.lowerRange, 10.5);
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values',
          () {
        final range = createRange('[,20.5]');
        expect(range.lowerRange, null);
        expect(range.upperRange, 20.5);
      });

      test('should create a [,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[10.5,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,20.5]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [,] range with the correct raw range string', () {
        final range = createRange('[,]');
        expect(range.rawRangeString, '(,)');
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[10.5,]');
        expect(range.rawRangeString, '[10.5,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,20.5]');
        expect(range.rawRangeString, '(,20.5]');
      });

      test('should return false when checking if a [,] range is empty', () {
        final range = createRange('[,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [b,] range is empty', () {
        final range = createRange('[10.5,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [,b] range is empty', () {
        final range = createRange('[,20.5]');
        expect(range.isEmpty, false);
      });
    });

    group('type inference', () {
      late final FloatRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
          ) as FloatRangeType;
        };
      });

      test(
          'should be able to infer the type when only the lower bound is specified',
          () {
        final range = createRange('[10.5,]');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test(
          'should be able to infer the type when only the upper bound is specified',
          () {
        final range = createRange('[,20.5]');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified',
          () {
        final range = createRange('[10.5,20.5]');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test('should throw an Exception when infering the type of a [,] range',
          () {
        expect(() => createRange('[,]'), throwsException);
      });

      test('should create a [b,] range with the correct lower and upper values',
          () {
        final range = createRange('[10.5,]');
        expect(range.lowerRange, 10.5);
        expect(range.upperRange, null);
      });

      test('should create a [,b] range with the correct lower and upper values',
          () {
        final range = createRange('[,20.5]');
        expect(range.lowerRange, null);
        expect(range.upperRange, 20.5);
      });

      test(
          'should create a [b,b] range with the correct lower and upper values',
          () {
        final range = createRange('[10.5,20.5]');
        expect(range.lowerRange, 10.5);
        expect(range.upperRange, 20.5);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        final range = createRange('[10.5,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct correct inclusivity',
          () {
        final range = createRange('[,20.5]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,b] range with the correct inclusivity', () {
        final range = createRange('[10.5,20.5]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[10.5,]');
        expect(range.rawRangeString, '[10.5,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,20.5]');
        expect(range.rawRangeString, '(,20.5]');
      });

      test('should create a [b,b] range with the correct raw range string', () {
        final range = createRange('[10.5,20.5]');
        expect(range.rawRangeString, '[10.5,20.5]');
      });

      test('should return false when cheking if a [b,] range is empty', () {
        final range = createRange('[10.5,]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [,b] range is empty', () {
        final range = createRange('[,20.5]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [b,b] range is empty', () {
        final range = createRange('[10.5,20.5]');
        expect(range.isEmpty, false);
      });
    });

    group('isInRange() tests', () {
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

    group('isInRange() unbounded tests', () {
      late final FloatRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.float,
          ) as FloatRangeType;
        };
      });

      test(
          'should return true when checking if any value is in range of [,] range',
          () {
        final range = createRange('[,]');

        expect(range.isInRange(10.0), true);
        expect(range.isInRange(9.0), true);
        expect(range.isInRange(0), true);
      });

      test(
          'should return true when checking if a value bigger than the lower range is within a [b,] range',
          () {
        final range = createRange('[10.5,]');

        expect(range.isInRange(20.5), true);
        expect(range.isInRange(10.6), true);
        expect(range.isInRange(50.5), true);
      });

      test(
          'should return false when checking if a value less than the lower range is within a [b,] range',
          () {
        final range = createRange('[10.5,]');

        expect(range.isInRange(9.5), false);
        expect(range.isInRange(4.5), false);
        expect(range.isInRange(-5.5), false);
      });

      test(
          'should return true when checking if a value less than the upper range is within a [,b] range',
          () {
        final range = createRange('[,20.5]');

        expect(range.isInRange(10.5), true);
        expect(range.isInRange(20.0), true);
        expect(range.isInRange(-5.5), true);
      });

      test(
          'should return false when checking if a value bigger than the upper range is within a [,b] range',
          () {
        final range = createRange('[,20.5]');

        expect(range.isInRange(30.5), false);
        expect(range.isInRange(21.5), false);
        expect(range.isInRange(50.5), false);
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
        expect(checkOverlap('[1.0, 10.0]', '[5.0, 15.0]'), true);
      });

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(checkOverlap('[1.0, 10.0]', '[3.0, 8.0]'), true);
      });

      test('should return true if ranges have the same start or end points ',
          () {
        // Ranges have the same start or end points
        expect(checkOverlap('[1.0, 10.0]', '[10.0, 15.0]'), true);
        expect(checkOverlap('[1.0, 10.0]', '[0.0, 5.0]'), true);
      });

      test('should return false if ranges touch but do not overlap', () {
        // Ranges touch but do not overlap
        expect(checkOverlap('[1.0, 10.0]', '(10.0, 20.0]'), false);
      });

      test('should return false if ranges do not overlap', () {
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
    });

    group('overlaps() unbounded tests', () {
      late final bool Function(String range1, String range2) checkOverlap;

      setUpAll(() {
        checkOverlap = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.float,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.float,
          );
          return r1.overlaps(r2);
        };
      });

      test('should return true when checking if a [,] range overlaps any other',
          () {
        // Ranges overlap because an unbounded range overlaps any other range
        expect(checkOverlap('[,]', '[100.0,200.0]'), true);
      });

      test(
          'should return true if the upper bound is greater than the other lower bound in a [,b] range',
          () {
        // Ranges overlap because 10 > 5
        expect(checkOverlap('[,10.0]', '[5.0,15.0]'), true);
      });

      test(
          'should return false if the upper bound is less than the other lower bound in a [,b] range',
          () {
        // Ranges do not overlap because 10 < 20
        expect(checkOverlap('[,10.0]', '[20.0,30.0]'), false);
      });

      test(
          'should return true if the lower bound is less than the other in a [b,] range',
          () {
        // Ranges overlap because 10 < 15
        expect(checkOverlap('[10.0,]', '[15.0,20.0]'), true);
      });

      test(
          'should return false if the lower bound is greater than the other upper bound in a [b,] range',
          () {
        // Ranges do not overlap because 10 > 8
        expect(checkOverlap('[10.0,]', '[1.0,8.0]'), false);
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
        // Two float ranges are adjacent
        expect(checkAdjacency('[1.0, 10.0]', '(10.0, 20.0)'), true);
        expect(checkAdjacency('[1.0, 10.0]', '[10.1, 20.0]'), true);
      });

      test('should return false if ranges are not adjacent', () {
        // Two float ranges are not adjacent
        expect(checkAdjacency('[1.0, 10.0]', '[12.0, 20.0]'), false);
        expect(checkAdjacency('[1.0, 10.0]', '[21.0, 30.0]'), false);
      });
    });

    group('isAdjacent() unbounded tests', () {
      late final bool Function(String range1, String range2) checkAdjacency;

      setUpAll(() {
        checkAdjacency = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.float,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.float,
          );
          return r1.isAdjacent(r2);
        };
      });
      test('should return false if unbounded ranges are tested for adjacency',
          () {
        expect(checkAdjacency('[,]', '[,]'), false);
        expect(checkAdjacency('[,]', '[5.0,15.0]'), false);
        expect(checkAdjacency('[,15.0]', '[5.0,15.0]'), false);
        expect(checkAdjacency('[5.0,]', '[5.0,15.0]'), false);
      });
    });

    group('getComparable() tests', () {
      late final RangeComparable<double> Function(String range) getComparable;

      setUpAll(() {
        getComparable = (String range) {
          return RangeType.createRange(range: range).getComparable()
              as RangeComparable<double>;
        };
      });
      test(
          'should return a comparable of the correct generic type when calling getComparable()',
          () {
        expect(getComparable('[1.0, 10.0]'), isA<RangeComparable<double>>());
      });

      test('should return the correct comparable on [] ranges', () {
        final comparable = getComparable('[1.0, 10.0]');

        expect(comparable.lowerRange, 1.0);
        expect(comparable.upperRange, 10.0);
      });

      test('should return the correct comparable on [) ranges', () {
        final comparable = getComparable('[1.0, 10.0)');

        expect(comparable.lowerRange, 1.0);
        expect(comparable.upperRange, 9.9);
      });

      test('should return the correct comparable on (] ranges', () {
        final comparable = getComparable('(1.0, 10.0]');

        expect(comparable.lowerRange, 1.1);
        expect(comparable.upperRange, 10.0);
      });

      test('should return the correct comparable on () ranges', () {
        final comparable = getComparable('(1.0, 10.0)');

        expect(comparable.lowerRange, 1.1);
        expect(comparable.upperRange, 9.9);
      });
    });

    group('comparison tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (FloatRangeType, FloatRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(range: range1);
          final r2 = RangeType.createRange(range: range2);

          return (r1, r2) as (FloatRangeType, FloatRangeType);
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });

      group('greater than tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 1
          expect(gt('[11.0, 20.0]', '[1.0, 10.0]'), true);
          expect(gt('[15.0, 20.0]', '[1.0, 10.0]'), true);
        });

        test('should return false when the lower bound is less than the other',
            () {
          // Lower bounds are less than 1
          expect(gt('[-5.0, 20.0]', '[1.0, 10.0]'), false);
          expect(gt('[-1.0, 20.0]', '[1.0, 10.0]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Lower bounds have different inclusivity
          expect(gt('(10.0, 20.0]', '[10.0, 15.0]'), true);
          expect(gt('[10.0, 20.0]', '(10.0, 15.0]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(gt('[10.0, 20.0]', '[10.0, 15.0]'), true);
          expect(gt('(10.0, 20.0)', '(10.0, 15.0)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(gt('[10.0, 12.0]', '[10.0, 15.0]'), false);
          expect(gt('(10.0, 12.0)', '(10.0, 15.0)'), false);
        });

        test('should return false if values are equal', () {
          // Values are equal
          expect(gt('[1.0, 10.0]', '[1.0, 10.0]'), false);
          expect(gt('(1.0, 10.0)', '(1.0, 10.0)'), false);
        });
      });

      group('greater than or equal to tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 1
          expect(gte('[11.0, 20.0]', '[1.0, 10.0]'), true);
          expect(gte('[15.0, 20.0]', '[1.0, 10.0]'), true);
        });

        test('should return false if the lower bound is less than the other',
            () {
          // Lower bounds are less than 1
          expect(gte('[-5.0, 20.0]', '[1.0, 10.0]'), false);
          expect(gte('[-1.0, 20.0]', '[1.0, 10.0]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(gte('(10.0, 20.0]', '[10.0, 15.0]'), true);
          expect(gte('[10.0, 20.0]', '(10.0, 15.0]'), false);
        });

        test(
            'should true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bound of is greater or equal
          expect(gte('[10.0, 20.0]', '[10.0, 15.0]'), true);
          expect(gte('(10.0, 20.0)', '(10.0, 15.0)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bound of is greater or equal
          expect(gte('[10.0, 11.0]', '[10.0, 15.0]'), false);
          expect(gte('(10.0, 13.0)', '(10.0, 15.0)'), false);
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(gte('[1.0, 10.0]', '[1.0, 10.0]'), true);
          expect(gte('(1.0, 10.0)', '(1.0, 10.0)'), true);
        });
      });

      group('less than tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 11
          expect(lt('[1.0, 10.0]', '[11.0, 20.0]'), true);
          expect(lt('[5.0, 10.0]', '[11.0, 20.0]'), true);
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than -5
          expect(lt('[1.0, 10.0]', '[-5.0, 20.0]'), false);
          expect(lt('[5.0, 10.0]', '[-5.0, 20.0]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(lt('[10.0, 15.0]', '(10.0, 20.0]'), true);
          expect(lt('(10.0, 15.0]', '[10.0, 20.0]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(lt('[10.0, 15.0]', '[10.0, 20.0]'), true);
          expect(lt('(10.0, 15.0)', '(10.0, 20.0)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(lt('[10.0, 25.0]', '[10.0, 20.0]'), false);
          expect(lt('(10.0, 25.0)', '(10.0, 20.0)'), false);
        });

        test('should return false if ranges are equal', () {
          // Values are equal
          expect(lt('[1.0, 10.0]', '[1.0, 10.0]'), false);
          expect(lt('(1.0, 10.0)', '(1.0, 10.0)'), false);
        });
      });

      group('less than or equal to tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 11
          expect(lte('[1.0, 10.0]', '[11.0, 20.0]'), true);
          expect(lte('[5.0, 10.0]', '[11.0, 20.0]'), true);
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than -5
          expect(lte('[1.0, 10.0]', '[-5.0, 20.0]'), false);
          expect(lte('[5.0, 10.0]', '[-5.0, 20.0]'), false);
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(lte('[10.0, 15.0]', '(10.0, 20.0]'), true);
          expect(lte('(10.0, 15.0]', '[10.0, 20.0]'), false);
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(lte('[10.0, 15.0]', '[10.0, 20.0]'), true);
          expect(lte('(10.0, 15.0)', '(10.0, 20.0)'), true);
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(lte('[10.0, 25.0]', '[10.0, 20.0]'), false);
          expect(lte('(10.0, 25.0)', '(10.0, 20.0)'), false);
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(lte('[1.0, 10.0]', '[1.0, 10.0]'), true);
          expect(lte('(1.0, 10.0)', '(1.0, 10.0)'), true);
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal', () {
          // Values are equal
          expect(ceq('[10.0, 20.0]', '[10.0, 20.0]'), true);
          expect(ceq('(10.0, 20.0]', '(10.0, 20.0]'), true);
          expect(ceq('[10.0, 20.0)', '[10.0, 20.0)'), true);
          expect(ceq('(10.0, 20.0)', '(10.0, 20.0)'), true);
        });

        test('should return true if the ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[9.1, 20.9]', '(9.0, 21.0)'), true);
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(ceq('[10.0, 20.0]', '[30.0, 40.0]'), false);
        });
      });
    });

    group('comparison unbounded tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (FloatRangeType, FloatRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.float,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.float,
          );

          return (r1, r2) as (FloatRangeType, FloatRangeType);
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });
      group('greater than tests', () {
        test(
            'should return false when checking if a [,] range is greater than a [b,b] range',
            () {
          expect(gt('[,]', '[5.0,15.0]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than a [,b] range',
            () {
          expect(gt('[,]', '[,20.0]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than a [b,] range',
            () {
          expect(gt('[,]', '[10.0,]'), false);
        });

        test(
            'should return false when checking if a [,] range is greater than other [,] range',
            () {
          expect(gt('[,]', '[,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3.0,]', '[2.0,15.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 == 3
          expect(gt('[3.0,]', '[3.0,15.0]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 3 < 4
          expect(gt('[3.0,]', '[4.0,15.0]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3.0,]', '[2.0,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 == 3
          expect(gt('[3.0,]', '[3.0,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 < 4
          expect(gt('[3.0,]', '[4.0,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 > 2
          expect(gt('[3.0,]', '[,2.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 3 == 3
          expect(gt('[3.0,]', '[,3.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 < 4
          expect(gt('[3.0,]', '[,4.0]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gt('[3.0,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7.0]', '[4.0,6.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7.0]', '[4.0,7.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7.0]', '[4.0,8.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7.0]', '[6.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7.0]', '[7.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7.0]', '[8.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 > 6
          expect(gt('[,7.0]', '[6.0,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7.0]', '[7.0,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7.0]', '[8.0,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 7 > 6
          expect(gt('[,7.0]', '[,6.0]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gt('[,7.0]', '[,7.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gt('[,7.0]', '[,8.0]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gt('[,7.0]', '[,]'), false);
        });
      });
      group('greater than or equal to tests', () {
        test(
            'should return false when checking if a [,] range is greater than or equal to a [b,b] range',
            () {
          expect(gte('[,]', '[5.0,15.0]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to a [,b] range',
            () {
          expect(gte('[,]', '[,20.0]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than or equal to [b,] a range',
            () {
          expect(gte('[,]', '[10.0,]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to other [,] range',
            () {
          expect(gte('[,]', '[,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3.0,]', '[2.0,15.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Equal to because 3 == 3
          expect(gte('[3.0,]', '[3.0,15.0]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 3 < 4
          expect(gte('[3.0,]', '[4.0,15.0]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3.0,]', '[2.0,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Equal to because 3 == 3
          expect(gte('[3.0,]', '[3.0,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 3 < 4
          expect(gte('[3.0,]', '[4.0,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 > 2
          expect(gte('[3.0,]', '[,2.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 3 == 3
          expect(gte('[3.0,]', '[,3.0]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 3 < 4
          expect(gte('[3.0,]', '[,4.0]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gte('[3.0,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7.0]', '[4.0,6.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7.0]', '[4.0,7.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7.0]', '[4.0,8.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7.0]', '[6.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7.0]', '[7.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7.0]', '[8.0,20.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 > 6
          expect(gte('[,7.0]', '[6.0,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 7 == 7
          expect(gte('[,7.0]', '[7.0,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7.0]', '[8.0,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 7 > 6
          expect(gte('[,7.0]', '[,6.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Equal to because 7 == 7
          expect(gte('[,7.0]', '[,7.0]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 7 < 8
          expect(gte('[,7.0]', '[,8.0]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gte('[,7.0]', '[,]'), false);
        });
      });

      group('less than tests', () {
        test(
            'should return true when checking if a [,] range is less than a [b,b] range',
            () {
          expect(lt('[,]', '[5.0,15.0]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than a [,b] range',
            () {
          expect(lt('[,]', '[,20.0]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than a [b,] range',
            () {
          expect(lt('[,]', '[10.0,]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than other [,] range',
            () {
          expect(lt('[,]', '[,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 3 > 2
          expect(lt('[3.0,]', '[2.0,15.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 3 == 3
          expect(lt('[3.0,]', '[3.0,15.0]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 3 < 4
          expect(lt('[3.0,]', '[4.0,15.0]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 3 > 2
          expect(lt('[3.0,]', '[2.0,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 3 == 3
          expect(lt('[3.0,]', '[3.0,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 3 < 4
          expect(lt('[3.0,]', '[4.0,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 3 > 2
          expect(lt('[3.0,]', '[,2.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 3 == 3
          expect(lt('[3.0,]', '[,3.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 3 < 4
          expect(lt('[3.0,]', '[,4.0]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lt('[3.0,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7.0]', '[4.0,6.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7.0]', '[4.0,7.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7.0]', '[4.0,8.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7.0]', '[6.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7.0]', '[7.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7.0]', '[8.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 7 > 6
          expect(lt('[,7.0]', '[6.0,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 7 == 7
          expect(lt('[,7.0]', '[7.0,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7.0]', '[8.0,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 7 > 6
          expect(lt('[,7.0]', '[,6.0]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 7 == 7
          expect(lt('[,7.0]', '[,7.0]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 7 < 8
          expect(lt('[,7.0]', '[,8.0]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lt('[,7.0]', '[,]'), true);
        });
      });

      group('less than or equal to tests', () {
        test(
            'should return true when checking if a [,] range is less than or equal to a [b,b] range',
            () {
          expect(lte('[,]', '[5.0,15.0]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than or equal to a [,b] range',
            () {
          expect(lte('[,]', '[,20.0]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to a [b,] range',
            () {
          expect(lte('[,]', '[10.0,]'), true);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to other [,] range',
            () {
          expect(lte('[,]', '[,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 3 > 2
          expect(lte('[3.0,]', '[2.0,15.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 3 == 3
          expect(lte('[3.0,]', '[3.0,15.0]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 3 < 4
          expect(lte('[3.0,]', '[4.0,15.0]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 3 > 2
          expect(lte('[3.0,]', '[2.0,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 3 == 3
          expect(lte('[3.0,]', '[3.0,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 3 < 4
          expect(lte('[3.0,]', '[4.0,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 3 > 2
          expect(lte('[3.0,]', '[,2.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 3 == 3
          expect(lte('[3.0,]', '[,3.0]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 3 < 4
          expect(lte('[3.0,]', '[,4.0]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lte('[3.0,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7.0]', '[4.0,6.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7.0]', '[4.0,7.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7.0]', '[4.0,8.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7.0]', '[6.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7.0]', '[7.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7.0]', '[8.0,20.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 7 > 6
          expect(lte('[,7.0]', '[6.0,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 7 == 7
          expect(lte('[,7.0]', '[7.0,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7.0]', '[8.0,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 7 > 6
          expect(lte('[,7.0]', '[,6.0]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 7 == 7
          expect(lte('[,7.0]', '[,7.0]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 7 < 8
          expect(lte('[,7.0]', '[,8.0]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lte('[,7.0]', '[,]'), true);
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal with the same inclusivity',
            () {
          // Values are equal
          expect(ceq('[10.0,]', '[10.0,]'), true);
          expect(ceq('[,20.0]', '[,20.0]'), true);
          expect(ceq('[,]', '[,]'), true);
        });

        test(
            'should return true if [b,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[10.0,]', '[10.0,]'), true);
          expect(ceq('(10.0,]', '(10.0,]'), true);
          expect(ceq('[10.0,)', '[10.0,)'), true);
          expect(ceq('(10.0,)', '(10.0,)'), true);
        });

        test(
            'should return true if [,b] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,20.0]', '[,20.0]'), true);
          expect(ceq('(,20.0]', '(,20.0]'), true);
          expect(ceq('[,20.0)', '[,20.0)'), true);
          expect(ceq('(,20.0)', '(,20.0)'), true);
        });

        test(
            'should return true if [,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,]', '[,]'), true);
          expect(ceq('(,]', '(,]'), true);
          expect(ceq('[,)', '[,)'), true);
          expect(ceq('(,)', '(,)'), true);
        });

        test('should return true if a [,] range is compared against a (,)', () {
          // Values are equal
          expect(ceq('[,]', '(,)'), true);
        });

        test('should return true if the [b,] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[9.1,]', '(9.0,)'), true);
        });

        test('should return true if the [,b] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[,20.9]', '(,21.0)'), true);
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(ceq('[10.0,]', '[30.0,]'), false);
          expect(ceq('[,20.0]', '[,40.0]'), false);
        });
      });
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
      expect(
        () => RangeType.createRange(range: '[2022-01-01, 2022-12-31]'),
        returnsNormally,
      );

      expect(
        RangeType.createRange(range: '[2022-01-01, 2022-12-31]'),
        isA<DateRangeType>(),
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-12-31, 2022-01-01]'),
        throwsException,
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound with force type',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-12-31, 2022-01-01]',
          forceType: RangeDataType.date,
        ),
        throwsException,
      );
    });

    test(
        'should create a range successfuly if the lower bound is equal to the upper bound',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-01-01, 2022-01-01]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(2022-01-01, 2022-01-01]'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '[2022-01-01, 2022-01-01)'),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(range: '(2022-01-01, 2022-01-01)'),
        returnsNormally,
      );
    });

    test('should ensure that range is of date type', () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      expect(range.rangeDataType, RangeDataType.date);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-01-01, 2022-01-01T15:00:00]'),
        throwsException,
      );
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(range: '[2022-01-01, 2022-12-31]');
      expect(range.rawRangeString, '[2022-01-01,2022-12-31]');
    });

    test('should remove spaces from raw range string', () {
      final range =
          RangeType.createRange(range: '[      2022-01-01, 2022-12-31       ]');
      expect(range.rawRangeString, '[2022-01-01,2022-12-31]');
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

    group('unbounded range tests', () {
      late final DateRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.date,
          ) as DateRangeType;
        };
      });

      test('should be able to create a [,] range', () {
        expect(() => createRange('[,]'), returnsNormally);
        expect(createRange('[,]'), isA<DateRangeType>());
      });

      test('should be able to create a [b,] range', () {
        expect(() => createRange('[2022-01-01,]'), returnsNormally);
        expect(createRange('[2022-01-01,]'), isA<DateRangeType>());
      });

      test('should be able to create a [,b] range', () {
        expect(() => createRange('[,2022-12-31]'), returnsNormally);
        expect(createRange('[,2022-12-31]'), isA<DateRangeType>());
      });

      test('should create a [,] range with the correct type', () {
        final range = createRange('[,]');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test('should create a [b,] range with the correct type', () {
        final range = createRange('[2022-01-01,]');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test('should create a [,b] range with the correct type', () {
        final range = createRange('[,2022-12-31]');
        expect(range.rangeDataType, RangeDataType.date);
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
        final range = createRange('[2022-01-01,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1));
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values',
          () {
        final range = createRange('[,2022-12-31]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 12, 31));
      });

      test('should create a [,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[2022-01-01,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,2022-12-31]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [,] range with the correct raw range string', () {
        final range = createRange('[,]');
        expect(range.rawRangeString, '(,)');
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01,]');
        expect(range.rawRangeString, '[2022-01-01,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-12-31]');
        expect(range.rawRangeString, '(,2022-12-31]');
      });

      test('should return false when checking if a [,] range is empty', () {
        final range = createRange('[,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [,b] range is empty', () {
        final range = createRange('[,2022-12-31]');
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
        final range = createRange('[2022-01-01,]');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test(
          'should be able to infer the type when only the upper bound is specified',
          () {
        final range = createRange('[,2022-12-31]');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified',
          () {
        final range = createRange('[2022-01-01,2022-12-31]');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test('should throw an Exception when infering the type of a [,] range',
          () {
        expect(() => createRange('[,]'), throwsException);
      });

      test('should create a [b,] range with the correct lower and upper values',
          () {
        final range = createRange('[2022-01-01,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1));
        expect(range.upperRange, null);
      });

      test('should create a [,b] range with the correct lower and upper values',
          () {
        final range = createRange('[,2022-12-31]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 12, 31));
      });

      test(
          'should create a [b,b] range with the correct lower and upper values',
          () {
        final range = createRange('[2022-01-01,2022-12-31]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1));
        expect(range.upperRange, DateTime.utc(2022, 12, 31));
      });

      test('should create a [b,] range with the correct inclusivity', () {
        final range = createRange('[2022-01-01,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct correct inclusivity',
          () {
        final range = createRange('[,2022-12-31]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,b] range with the correct inclusivity', () {
        final range = createRange('[2022-01-01,2022-12-31]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01,]');
        expect(range.rawRangeString, '[2022-01-01,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-12-31]');
        expect(range.rawRangeString, '(,2022-12-31]');
      });

      test('should create a [b,b] range with the correct raw range string', () {
        final range = createRange('[2022-01-01,2022-12-31]');
        expect(range.rawRangeString, '[2022-01-01,2022-12-31]');
      });

      test('should return false when cheking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01,]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [,b] range is empty', () {
        final range = createRange('[,2022-12-31]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [b,b] range is empty', () {
        final range = createRange('[2022-01-01,2022-12-31]');
        expect(range.isEmpty, false);
      });
    });

    group('isInRange() tests', () {
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

    group('isInRange() unbounded tests', () {
      late final DateRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.date,
          ) as DateRangeType;
        };
      });

      test(
          'should return true when checking if any value is in range of [,] range',
          () {
        final range = createRange('[,]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 1)), true);
        expect(range.isInRange(DateTime.utc(2022, 12, 31)), true);
      });

      test(
          'should return true when checking if a value bigger than the lower range is within a [b,] range',
          () {
        final range = createRange('[2022-01-01,]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2)), true);
        expect(range.isInRange(DateTime.utc(2023, 1, 1)), true);
      });

      test(
          'should return false when checking if a value less than the lower range is within a [b,] range',
          () {
        final range = createRange('[2022-01-01,]');

        expect(range.isInRange(DateTime.utc(2021, 6, 15)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 2)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 1)), false);
      });

      test(
          'should return true when checking if a value less than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2)), true);
        expect(range.isInRange(DateTime.utc(2022, 3, 15)), true);
      });

      test(
          'should return false when checking if a value bigger than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31]');

        expect(range.isInRange(DateTime.utc(2023, 6, 15)), false);
        expect(range.isInRange(DateTime.utc(2023, 1, 1)), false);
        expect(range.isInRange(DateTime.utc(2023, 3, 15)), false);
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
          checkOverlap('[2023-01-01, 2023-01-10]', '[2023-01-05, 2023-01-15]'),
          true,
        );
      });

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(
          checkOverlap('[2023-01-01, 2023-01-10]', '[2023-01-03, 2023-01-08]'),
          true,
        );
      });

      test('should return true if ranges have the same start or end points ',
          () {
        // Ranges have the same start or end points
        expect(
          checkOverlap('[2023-01-01, 2023-01-10]', '[2023-01-10, 2023-01-15]'),
          true,
        );
        expect(
          checkOverlap('[2023-01-01, 2023-01-10]', '[2022-12-31, 2023-01-05]'),
          true,
        );
      });

      test('should return false if ranges touch but do not overlap', () {
        // Ranges touch but do not overlap
        expect(
          checkOverlap('[2023-01-01, 2023-01-10]', '(2023-01-10, 2023-01-20]'),
          false,
        );
      });

      test('should return false if ranges do not overlap', () {
        // Ranges don't overlap
        expect(
          checkOverlap('[2023-01-01, 2023-01-05]', '[2023-01-06, 2023-01-10]'),
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
    });

    group('overlaps() unbounded tests', () {
      late final bool Function(String range1, String range2) checkOverlap;

      setUpAll(() {
        checkOverlap = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.date,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.date,
          );
          return r1.overlaps(r2);
        };
      });

      test('should return true when checking if a [,] range overlaps any other',
          () {
        // Ranges overlap because an unbounded range overlaps any other range
        expect(checkOverlap('[,]', '[2022-01-01, 2022-12-31]'), true);
      });

      test(
          'should return true if the upper bound is greater than the other lower bound in a [,b] range',
          () {
        // Ranges overlap because 2023-01-01 > 2022-01-01
        expect(checkOverlap('[,2023-01-01]', '[2022-01-01,2022-12-31]'), true);
      });

      test(
          'should return false if the upper bound is less than the other lower bound in a [,b] range',
          () {
        // Ranges do not overlap because 2021-01-01 < 2022-01-01
        expect(checkOverlap('[,2021-01-01]', '[2022-01-01,2022-12-31]'), false);
      });

      test(
          'should return true if the lower bound is less than the other in a [b,] range',
          () {
        // Ranges overlap because 10 < 15
        expect(checkOverlap('[2021-01-01,]', '[2022-01-01,2022-12-31]'), true);
      });

      test(
          'should return false if the lower bound is greater than the other upper bound in a [b,] range',
          () {
        // Ranges do not overlap because 10 > 8
        expect(checkOverlap('[2023-01-01,]', '[2022-01-01,2022-12-31]'), false);
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
              '[2023-01-01, 2023-01-10]', '(2023-01-10, 2023-01-20)'),
          true,
        );
        expect(
          checkAdjacency(
              '[2023-01-01, 2023-01-10]', '[2023-01-11, 2023-01-20]'),
          true,
        );
      });

      test('should return false if ranges are not adjacent', () {
        // Two date ranges are not adjacent
        expect(
          checkAdjacency(
              '[2023-01-01, 2023-01-10]', '[2023-01-12, 2023-01-20]'),
          false,
        );
        expect(
          checkAdjacency(
              '[2023-01-01, 2023-01-10]', '[2023-01-21, 2023-01-30]'),
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
            forceType: RangeDataType.date,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.date,
          );
          return r1.isAdjacent(r2);
        };
      });
      test('should return false if unbounded ranges are tested for adjacency',
          () {
        expect(
          checkAdjacency('[,]', '[,]'),
          false,
        );
        expect(
          checkAdjacency('[,]', '[2022-01-01,2022-12-31]'),
          false,
        );
        expect(
          checkAdjacency('[,2022-12-31]', '[2022-01-01,2022-12-31]'),
          false,
        );
        expect(
          checkAdjacency('[2022-01-01,]', '[2022-01-01,2022-12-31]'),
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
          getComparable('[2022-01-01,2022-12-31]'),
          isA<RangeComparable<DateTime>>(),
        );
      });

      test('should return the correct comparable on [] ranges', () {
        final comparable = getComparable('[2022-01-01,2022-12-31]');

        expect(comparable.lowerRange, DateTime.utc(2022, 1, 1));
        expect(comparable.upperRange, DateTime.utc(2022, 12, 31));
      });

      test('should return the correct comparable on [) ranges', () {
        final comparable = getComparable('[2022-01-01,2022-12-31)');

        expect(comparable.lowerRange, DateTime.utc(2022, 1, 1));
        expect(comparable.upperRange, DateTime.utc(2022, 12, 30));
      });

      test('should return the correct comparable on (] ranges', () {
        final comparable = getComparable('(2022-01-01,2022-12-31]');

        expect(comparable.lowerRange, DateTime.utc(2022, 1, 2));
        expect(comparable.upperRange, DateTime.utc(2022, 12, 31));
      });

      test('should return the correct comparable on () ranges', () {
        final comparable = getComparable('(2022-01-01,2022-12-31)');

        expect(comparable.lowerRange, DateTime.utc(2022, 1, 2));
        expect(comparable.upperRange, DateTime.utc(2022, 12, 30));
      });
    });

    group('comparison tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });

      group('greater than tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01
          expect(
            gt('[2022-01-02, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gt('[2022-06-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
        });

        test('should return false when the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            gt('[2021-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            gt('[2021-06-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Lower bounds have different inclusivity
          expect(
            gt('(2022-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gt('[2022-01-01, 2023-01-01]', '(2022-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should return true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(
            gt('[2022-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gt('(2022-01-01, 2023-01-01)', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(
            gt('[2022-01-01, 2022-06-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            gt('(2022-01-01, 2022-06-01)', '(2022-01-01, 2022-12-31)'),
            false,
          );
        });

        test('should return false if values are equal', () {
          // Values are equal
          expect(
            gt('[2022-01-01, 2022-12-31]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            gt('(2022-01-01, 2022-12-31)', '(2022-01-01, 2022-12-31)'),
            false,
          );
        });
      });

      group('greater than or equal to tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01
          expect(
            gte('[2022-01-02, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gte('[2022-06-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
        });

        test('should return false if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            gte('[2021-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            gte('[2021-06-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(
            gte('(2022-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gte('[2022-01-01, 2023-01-01]', '(2022-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should true if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bound of is greater or equal
          expect(
            gte('[2022-01-01, 2023-01-01]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gte('(2022-01-01, 2023-01-01)', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });

        test(
            'should return false if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bound of is less or equal
          expect(
            gte('[2022-01-01, 2022-06-01]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            gte('(2022-01-01, 2022-06-01)', '(2022-01-01, 2022-12-31)'),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            gte('[2022-01-01, 2022-12-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            gte('(2022-01-01, 2022-12-31)', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });
      });

      group('less than tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            lt('[2021-01-01, 2022-11-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            lt('[2021-06-01, 2022-11-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01
          expect(
            lt('[2022-06-01, 2022-11-31]', '[2021-01-01, 2022-12-31]'),
            false,
          );
          expect(
            lt('[2022-06-01, 2022-11-31]', '[2021-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(
            lt('[2022-01-01, 2022-12-31]', '(2022-01-01, 2023-01-01]'),
            true,
          );
          expect(
            lt('(2022-01-01, 2022-12-31]', '[2022-01-01, 2023-01-01]'),
            false,
          );
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(
            lt('[2022-01-01, 2022-12-31]', '[2022-01-01, 2023-01-01]'),
            true,
          );
          expect(
            lt('(2022-01-01, 2022-12-31)', '(2022-01-01, 2023-01-01)'),
            true,
          );
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(
            lt('[2022-01-01, 2024-01-01]', '[2022-01-01, 2023-01-01]'),
            false,
          );
          expect(
            lt('(2022-01-01, 2024-01-01)', '(2022-01-01, 2023-01-01)'),
            false,
          );
        });

        test('should return false if ranges are equal', () {
          // Values are equal
          expect(
            lt('[2022-01-01, 2022-12-31]', '[2022-01-01, 2022-12-31]'),
            false,
          );
          expect(
            lt('(2022-01-01, 2022-12-31)', '(2022-01-01, 2022-12-31)'),
            false,
          );
        });
      });

      group('less than or equal to tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            lt('[2021-01-01, 2022-11-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            lt('[2021-06-01, 2022-11-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01
          expect(
            lt('[2022-06-01, 2022-11-31]', '[2021-01-01, 2022-12-31]'),
            false,
          );
          expect(
            lt('[2022-06-01, 2022-11-31]', '[2021-01-01, 2022-12-31]'),
            false,
          );
        });

        test(
            'should return the correct value when lower bounds have different inclusivity',
            () {
          // Ranges have different inclusivity
          expect(
            lt('[2022-01-01, 2022-12-31]', '(2022-01-01, 2023-01-01]'),
            true,
          );
          expect(
            lt('(2022-01-01, 2022-12-31]', '[2022-01-01, 2023-01-01]'),
            false,
          );
        });

        test(
            'should return true if the lower bound is equal but the upper bound is less',
            () {
          // Lower bounds are equal but the upper bounds are less
          expect(
            lt('[2022-01-01, 2022-12-31]', '[2022-01-01, 2023-01-01]'),
            true,
          );
          expect(
            lt('(2022-01-01, 2022-12-31)', '(2022-01-01, 2023-01-01)'),
            true,
          );
        });

        test(
            'should return false if the lower bound is equal but the upper bound is greater',
            () {
          // Lower bounds are equal but the upper bounds are greater
          expect(
            lt('[2022-01-01, 2024-01-01]', '[2022-01-01, 2023-01-01]'),
            false,
          );
          expect(
            lt('(2022-01-01, 2024-01-01)', '(2022-01-01, 2023-01-01)'),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            lte('[2022-01-01, 2022-12-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            lte('(2022-01-01, 2022-12-31)', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            ceq('[2022-01-01, 2022-12-31]', '[2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            ceq('(2022-01-01, 2022-12-31]', '(2022-01-01, 2022-12-31]'),
            true,
          );
          expect(
            ceq('[2022-01-01, 2022-12-31)', '[2022-01-01, 2022-12-31)'),
            true,
          );
          expect(
            ceq('(2022-01-01, 2022-12-31)', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });

        test('should return true if the ranges cover the same values', () {
          // Ranges cover same values
          expect(
            ceq('[2022-01-02, 2022-12-30]', '(2022-01-01, 2022-12-31)'),
            true,
          );
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(
            ceq('[2022-01-01, 2022-12-31]', '[2024-01-01, 2024-12-31]'),
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
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (DateRangeType, DateRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.date,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.date,
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });
      group('greater than tests', () {
        test(
            'should return false when checking if a [,] range is greater than a [b,b] range',
            () {
          expect(gt('[,]', '[2022-01-01, 2022-12-31]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than a [,b] range',
            () {
          expect(gt('[,]', '[,2023-01-01]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than a [b,] range',
            () {
          expect(gt('[,]', '[2022-01-01,]'), false);
        });

        test(
            'should return false when checking if a [,] range is greater than other [,] range',
            () {
          expect(gt('[,]', '[,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gt('[2022-01-01,]', '[2021-01-01,2024-00-00]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Greater than because 2022-01-01 == 2022-01-01
          expect(gt('[2022-01-01,]', '[2022-01-01,2024-00-00]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01 < 2023-01-01
          expect(gt('[2022-01-01,]', '[2023-01-01,2024-00-00]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gt('[2022-01-01,]', '[2021-01-01,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01 == 2022-01-01
          expect(gt('[2022-01-01,]', '[2022-01-01,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01 < 2023-01-01
          expect(gt('[2022-01-01,]', '[2023-01-01,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gt('[2022-01-01,]', '[,2021-01-01]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 == 2022-01-01
          expect(gt('[2022-01-01,]', '[,2022-01-01]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 < 2023-01-01
          expect(gt('[2022-01-01,]', '[,2023-01-01]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gt('[2022-01-01,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gt('[,2023-01-01]', '[2021-01-01,2022-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gt('[,2023-01-01]', '[2021-01-01,2023-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gt('[,2023-01-01]', '[2021-01-01,2024-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gt('[,2023-01-01]', '[2022-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gt('[,2023-01-01]', '[2023-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gt('[,2023-01-01]', '[2024-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gt('[,2023-01-01]', '[2022-01-01,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gt('[,2023-01-01]', '[2023-01-01,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gt('[,2023-01-01]', '[2024-01-01,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01 > 2022-01-01
          expect(gt('[,2023-01-01]', '[,2022-01-01]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gt('[,2023-01-01]', '[,2023-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gt('[,2023-01-01]', '[,2024-01-01]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gt('[,2023-01-01]', '[,]'), false);
        });
      });
      group('greater than or equal to tests', () {
        test(
            'should return false when checking if a [,] range is greater than or equal to a [b,b] range',
            () {
          expect(gte('[,]', '[2022-01-01,2022-12-31]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to a [,b] range',
            () {
          expect(gte('[,]', '[,2023-01-01]'), true);
        });

        test(
            'should return false when checking if a [,] range is greater than or equal to [b,] a range',
            () {
          expect(gte('[,]', '[2022-01-01,]'), false);
        });

        test(
            'should return true when checking if a [,] range is greater than or equal to other [,] range',
            () {
          expect(gte('[,]', '[,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gte('[2022-01-01,]', '[2021-01-01,2024-01-01]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Equal to because 2022-01-01 == 2022-01-01
          expect(gte('[2022-01-01,]', '[2022-01-01,2024-01-01]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01 < 2023-01-01
          expect(gte('[2022-01-01,]', '[2023-01-01,2024-01-01]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gte('[2022-01-01,]', '[2021-01-01,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Equal to because 2022-01-01 == 2022-01-01
          expect(gte('[2022-01-01,]', '[2022-01-01,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01 < 2023-01-01
          expect(gte('[2022-01-01,]', '[2023-01-01,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 > 2021-01-01
          expect(gte('[2022-01-01,]', '[,2021-01-01]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 == 2022-01-01
          expect(gte('[2022-01-01,]', '[,2022-01-01]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01 < 2023-01-01
          expect(gte('[2022-01-01,]', '[,2023-01-01]'), true);
        });

        test(
            'should return true when a [b,] range is compared against a completely unbounded range',
            () {
          // Greater than because [b,] is greater than [,]
          expect(gte('[2022-01-01,]', '[,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gte('[,2023-01-01]', '[2020-01-01,2022-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gte('[,2023-01-01]', '[2020-01-01,2023-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gte('[,2023-01-01]', '[2020-01-01,2024-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gte('[,2023-01-01]', '[2022-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gte('[,2023-01-01]', '[2023-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gte('[,2023-01-01]', '[2024-01-01,2025-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 > 2022-01-01
          expect(gte('[,2023-01-01]', '[2022-01-01,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 == 2023-01-01
          expect(gte('[,2023-01-01]', '[2023-01-01,]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gte('[,2023-01-01]', '[2024-01-01,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01 > 2022-01-01
          expect(gte('[,2023-01-01]', '[,2022-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Equal to because 2023-01-01 == 2023-01-01
          expect(gte('[,2023-01-01]', '[,2023-01-01]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01 < 2024-01-01
          expect(gte('[,2023-01-01]', '[,2024-01-01]'), false);
        });

        test(
            'should return false when a [,b] range is compared against a [,] range',
            () {
          // Not greater than because [,b] is not greater than [,]
          expect(gte('[,2023-01-01]', '[,]'), false);
        });
      });

      group('less than tests', () {
        test(
            'should return true when checking if a [,] range is less than a [b,b] range',
            () {
          expect(lt('[,]', '[2022-01-01,2022-12-31]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than a [,b] range',
            () {
          expect(lt('[,]', '[,2023-01-01]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than a [b,] range',
            () {
          expect(lt('[,]', '[2022-01-01,]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than other [,] range',
            () {
          expect(lt('[,]', '[,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lt('[2022-01-01,]', '[2021-01-01,2024-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lt('[2022-01-01,]', '[2022-01-01,2024-01-01]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01 < 2023-01-01
          expect(lt('[2022-01-01,]', '[2023-01-01,2024-01-01]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lt('[2022-01-01,]', '[2021-01-01,]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lt('[2022-01-01,]', '[2022-01-01,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01 < 2023-01-01
          expect(lt('[2022-01-01,]', '[2023-01-01,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lt('[2022-01-01,]', '[,2021-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lt('[2022-01-01,]', '[,2022-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 < 2023-01-01
          expect(lt('[2022-01-01,]', '[,2023-01-01]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lt('[2022-01-01,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lt('[,2023-01-01]', '[2020-01-01,2022-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lt('[,2023-01-01]', '[2020-01-01,2023-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lt('[,2023-01-01]', '[2020-01-01,2024-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lt('[,2023-01-01]', '[2022-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lt('[,2023-01-01]', '[2023-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lt('[,2023-01-01]', '[2024-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lt('[,2023-01-01]', '[2022-01-01,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lt('[,2023-01-01]', '[2023-01-01,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lt('[,2023-01-01]', '[2024-01-01,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01 > 2022-01-01
          expect(lt('[,2023-01-01]', '[,2022-01-01]'), false);
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01 == 2023-01-01
          expect(lt('[,2023-01-01]', '[,2023-01-01]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lt('[,2023-01-01]', '[,2024-01-01]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lt('[,2023-01-01]', '[,]'), true);
        });
      });

      group('less than or equal to tests', () {
        test(
            'should return true when checking if a [,] range is less than or equal to a [b,b] range',
            () {
          expect(lte('[,]', '[2022-01-01,2022-12-31]'), true);
        });

        test(
            'should return false when checking if a [,] range is less than or equal to a [,b] range',
            () {
          expect(lte('[,]', '[,2023-01-01]'), false);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to a [b,] range',
            () {
          expect(lte('[,]', '[2022-01-01,]'), true);
        });

        test(
            'should return true when checking if a [,] range is less than or equal to other [,] range',
            () {
          expect(lte('[,]', '[,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lte('[2022-01-01,]', '[2021-01-01,2024-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lte('[2022-01-01,]', '[2022-01-01,2024-01-01]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01 < 2023-01-01
          expect(lte('[2022-01-01,]', '[2023-01-01,2024-01-01]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lte('[2022-01-01,]', '[2021-01-01,]'), false);
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lte('[2022-01-01,]', '[2022-01-01,]'), true);
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01 < 2023-01-01
          expect(lte('[2022-01-01,]', '[2023-01-01,]'), true);
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 > 2021-01-01
          expect(lte('[2022-01-01,]', '[,2021-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 == 2022-01-01
          expect(lte('[2022-01-01,]', '[,2022-01-01]'), false);
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01 < 2023-01-01
          expect(lte('[2022-01-01,]', '[,2023-01-01]'), false);
        });

        test(
            'should return false when a [b,] range is compared against a [,] range',
            () {
          // False because [b,] is greater than [,]
          expect(lte('[2022-01-01,]', '[,]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lte('[,2023-01-01]', '[2020-01-01,2022-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lte('[,2023-01-01]', '[2020-01-01,2023-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lte('[,2023-01-01]', '[2020-01-01,2024-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lte('[,2023-01-01]', '[2022-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lte('[,2023-01-01]', '[2023-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lte('[,2023-01-01]', '[2024-01-01,2025-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 > 2022-01-01
          expect(lte('[,2023-01-01]', '[2022-01-01,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 == 2023-01-01
          expect(lte('[,2023-01-01]', '[2023-01-01,]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lte('[,2023-01-01]', '[2024-01-01,]'), true);
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01 > 2022-01-01
          expect(lte('[,2023-01-01]', '[,2022-01-01]'), false);
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01 == 2023-01-01
          expect(lte('[,2023-01-01]', '[,2023-01-01]'), true);
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01 < 2024-01-01
          expect(lte('[,2023-01-01]', '[,2024-01-01]'), true);
        });

        test(
            'should return true when a [,b] range is compared against a [,] range',
            () {
          // Less than because [,b] is not greater than [,]
          expect(lte('[,2023-01-01]', '[,]'), true);
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal with the same inclusivity',
            () {
          // Values are equal
          expect(ceq('[2022-01-01,]', '[2022-01-01,]'), true);
          expect(ceq('[,2022-12-31]', '[,2022-12-31]'), true);
          expect(ceq('[,]', '[,]'), true);
        });

        test(
            'should return true if [b,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[2022-01-01,]', '[2022-01-01,]'), true);
          expect(ceq('(2022-01-01,]', '(2022-01-01,]'), true);
          expect(ceq('[2022-01-01,)', '[2022-01-01,)'), true);
          expect(ceq('(2022-01-01,)', '(2022-01-01,)'), true);
        });

        test(
            'should return true if [,b] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,2022-12-31]', '[,2022-12-31]'), true);
          expect(ceq('(,2022-12-31]', '(,2022-12-31]'), true);
          expect(ceq('[,2022-12-31)', '[,2022-12-31)'), true);
          expect(ceq('(,2022-12-31)', '(,2022-12-31)'), true);
        });

        test(
            'should return true if [,] ranges are equal with different inclusivity',
            () {
          // Values are equal
          expect(ceq('[,]', '[,]'), true);
          expect(ceq('(,]', '(,]'), true);
          expect(ceq('[,)', '[,)'), true);
          expect(ceq('(,)', '(,)'), true);
        });

        test('should return true if a [,] range is compared against a (,)', () {
          // Values are equal
          expect(ceq('[,]', '(,)'), true);
        });

        test('should return true if the [b,] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[2022-01-02,]', '(2022-01-01,)'), true);
        });

        test('should return true if the [,b] ranges cover the same values', () {
          // Ranges cover same values
          expect(ceq('[,2022-12-30]', '(,2022-12-31)'), true);
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(ceq('[2022-01-01,]', '[2023-01-01,]'), false);
          expect(ceq('[,2022-12-31]', '[,2023-12-31]'), false);
        });
      });
    });
  });

  group('DateRangeType timestamp tests', () {
    test(
        'should successfuly create a range of timestamp type explicitly passing milliseconds',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000, 2022-01-01T15:00:00.999]',
        ),
        returnsNormally,
      );

      expect(
        RangeType.createRange(
          range: '[2022-01-01T00:00:00.000, 2022-12-31T00:00:00.000]',
        ),
        isA<DateRangeType>(),
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-12-31T00:00:00.000, 2022-01-01T00:00:00.000]',
        ),
        throwsException,
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound with force type',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-12-31T00:00:00.000, 2022-01-01T00:00:00.000]',
          forceType: RangeDataType.timestamp,
        ),
        throwsException,
      );
    });

    test(
        'should create a range successfuly if the lower bound is equal to the upper bound',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000, 2022-01-01T00:00:00.000]',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '(2022-01-01T00:00:00.000, 2022-01-01T00:00:00.000]',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000, 2022-01-01T00:00:00.000)',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '(2022-01-01T00:00:00.000, 2022-01-01T00:00:00.000)',
        ),
        returnsNormally,
      );
    });

    test(
        'should successfuly create a range of timestamp type omitting milliseconds',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00, 2022-01-01T15:00:00]',
        ),
        returnsNormally,
      );
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(range: '[2022-01-01T00:00:00.000, 20.0]'),
        throwsException,
      );
    });

    test(
        'should ensure that range is of timestamp type explicitly passing milliseconds',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000, 2022-01-01T15:00:00.999]',
      );
      expect(range.rangeDataType, RangeDataType.timestamp);
    });

    test('should ensure that range is of timestamp type omitting', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00, 2022-01-01T15:00:00]',
      );
      expect(range.rangeDataType, RangeDataType.timestamp);
    });

    test(
        'should return the correct raw range string explicitly passing milliseconds',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000, 2022-01-01T15:00:00.999]',
      );
      expect(range.rawRangeString,
          '[2022-01-01T00:00:00.000,2022-01-01T15:00:00.999]');
    });

    test('should return the correct raw range string omitting milliseconds',
        () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00, 2022-01-01T15:00:00]',
      );
      expect(
        range.rawRangeString,
        '[2022-01-01T00:00:00.000,2022-01-01T15:00:00.000]',
      );
    });

    test('should remove spaces from raw range string', () {
      final range = RangeType.createRange(
        range:
            '[      2022-01-01T00:00:00.000, 2022-01-01T15:00:00.999       ]',
      );
      expect(
        range.rawRangeString,
        '[2022-01-01T00:00:00.000,2022-01-01T15:00:00.999]',
      );
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(
        range: '[2022-01-01T00:00:00, 2022-01-01T15:00:00]',
      );
      final range2 = RangeType.createRange(
        range: '(2022-01-01T00:00:00, 2022-01-01T15:00:00)',
      );
      final range3 = RangeType.createRange(
        range: '[2022-01-01T00:00:00, 2022-01-01T15:00:00)',
      );
      final range4 = RangeType.createRange(
        range: '(2022-01-01T00:00:00, 2022-01-01T15:00:00]',
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
            forceType: RangeDataType.timestamp,
          ) as DateRangeType;
        };
      });

      test('should be able to create a [,] range', () {
        expect(() => createRange('[,]'), returnsNormally);
        expect(createRange('[,]'), isA<DateRangeType>());
      });

      test('should be able to create a [b,] range (omitting milliseconds)', () {
        expect(() => createRange('[2022-01-01T00:00:00,]'), returnsNormally);
        expect(createRange('[2022-01-01T00:00:00,]'), isA<DateRangeType>());
      });

      test('should be able to create a [b,] range (with milliseconds)', () {
        expect(
            () => createRange('[2022-01-01T00:00:00.999,]'), returnsNormally);
        expect(createRange('[2022-01-01T00:00:00.999,]'), isA<DateRangeType>());
      });

      test('should be able to create a [,b] range (omitting milliseconds)', () {
        expect(() => createRange('[,2022-01-01T15:00:00]'), returnsNormally);
        expect(createRange('[,2022-01-01T15:00:00]'), isA<DateRangeType>());
      });

      test('should be able to create a [,b] range (with milliseconds)', () {
        expect(
            () => createRange('[,2022-01-01T15:00:00.999]'), returnsNormally);
        expect(createRange('[,2022-01-01T15:00:00.999]'), isA<DateRangeType>());
      });

      test('should create a [,] range with the correct type', () {
        final range = createRange('[,]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should create a [b,] range with the correct type (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should create a [b,] range with the correct type (with milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00.999,]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should create a [,b] range with the correct type (omitting milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should create a [,b] range with the correct type (with milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should create a [,] range with the correct lower and upper bound values',
          () {
        final range = createRange('[,]');
        expect(range.lowerRange, null);
        expect(range.upperRange, null);
      });

      test(
          'should create a [b,] range with the correct lower and upper bound values (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0));
        expect(range.upperRange, null);
      });

      test(
          'should create a [b,] range with the correct lower and upper bound values (with milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00.999,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values (omitting milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0));
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values (with milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999]');
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
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [,] range with the correct raw range string', () {
        final range = createRange('[,]');
        expect(range.rawRangeString, '(,)');
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.rawRangeString, '[2022-01-01T00:00:00.000,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.rawRangeString, '(,2022-01-01T15:00:00.000]');
      });

      test('should return false when checking if a [,] range is empty', () {
        final range = createRange('[,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [,b] range is empty', () {
        final range = createRange('[,2022-01-01T15:00:00]');
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
          'should be able to infer the type when only the lower bound is specified (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should be able to infer the type when only the lower bound is specified (with milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00.999,]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should be able to infer the type when only the upper bound is specified (omitting milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should be able to infer the type when only the upper bound is specified (with milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,2022-01-01T15:00:00]');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified (with milliseconds)',
          () {
        final range = createRange(
          '[2022-01-01T00:00:00.000,2022-01-01T15:00:00.999]',
        );
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test('should throw an Exception when infering the type of a [,] range',
          () {
        expect(() => createRange('[,]'), throwsException);
      });

      test(
          'should create a [b,] range with the correct lower and upper values (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0));
        expect(range.upperRange, null);
      });

      test(
          'should create a [b,] range with the correct lower and upper values (with milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00.999,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper values (omitting milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0));
      });

      test(
          'should create a [,b] range with the correct lower and upper values (with milliseconds)',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0, 999));
      });

      test(
          'should create a [b,b] range with the correct lower and upper values (omitting milliseconds)',
          () {
        final range = createRange('[2022-01-01T00:00:00,2022-01-01T15:00:00]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0));
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0));
      });

      test(
          'should create a [b,b] range with the correct lower and upper values (with milliseconds)',
          () {
        final range =
            createRange('[2022-01-01T00:00:00.999,2022-01-01T15:00:00.999]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 0, 0, 0, 999));
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 15, 0, 0, 999));
      });

      test('should create a [b,] range with the correct inclusivity', () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct correct inclusivity',
          () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,b] range with the correct inclusivity', () {
        final range = createRange('[2022-01-01T00:00:00,2022-01-01T15:00:00]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.rawRangeString, '[2022-01-01T00:00:00.000,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.rawRangeString, '(,2022-01-01T15:00:00.000]');
      });

      test('should create a [b,b] range with the correct raw range string', () {
        final range = createRange('[2022-01-01T00:00:00,2022-01-01T15:00:00]');
        expect(
          range.rawRangeString,
          '[2022-01-01T00:00:00.000,2022-01-01T15:00:00.000]',
        );
      });

      test('should return false when cheking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01T00:00:00,]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [,b] range is empty', () {
        final range = createRange('[,2022-01-01T15:00:00]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [b,b] range is empty', () {
        final range = createRange('[2022-01-01T00:00:00,2022-01-01T15:00:00]');
        expect(range.isEmpty, false);
      });
    });

    group('inRange() tests', () {
      test(
          'should return the correct value when calling isInRange() on a inclusive range (omitting milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00]',
        );
        expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);
      });

      test(
          'should return the correct value when calling isInRange() on a inclusive range (with milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
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
          'should return the correct value when calling isInRange() on a exclusive range (omitting milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00)',
        );
        expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);
      });

      test(
          'should return the correct value when calling isInRange() on a exclusive range (with milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '(2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999)',
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
          'should return the correct value when calling isInRange() on a [) range (omitting milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '[2022-01-01T12:00:00, 2022-12-31T12:00:00)',
        );
        expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);
      });

      test(
          'should return the correct value when calling isInRange() on a [) range (with milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '[2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999)',
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
          'should return the correct value when calling isInRange() on a (] range (omitting milliseconds)',
          () {
        final range = RangeType.createRange(
          range: '(2022-01-01T12:00:00, 2022-12-31T12:00:00]',
        );
        expect(range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0)), false);
      });

      test(
          'should return the correct value when calling isInRange() on a (] range (with milliseconds)',
          () {
        final range2 = RangeType.createRange(
          range: '(2022-01-01T12:00:00.999, 2022-12-31T12:00:00.999]',
        );
        expect(
          range2.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
          true,
        );
        expect(
          range2.isInRange(DateTime.utc(2022, 1, 1, 12, 0, 0, 999)),
          false,
        );
        expect(
          range2.isInRange(DateTime.utc(2022, 12, 31, 12, 0, 0, 999)),
          true,
        );
        expect(
          range2.isInRange(DateTime.utc(2023, 1, 1, 12, 0, 0, 999)),
          false,
        );
        expect(
          range2.isInRange(DateTime.utc(2021, 12, 31, 12, 0, 0, 999)),
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
            forceType: RangeDataType.timestamp,
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
        final range = createRange('[2022-01-01T00:00:00,]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 0, 0, 0)), true);
      });

      test(
          'should return false when checking if a value less than the lower range is within a [b,] range',
          () {
        final range = createRange('[2022-01-01T00:00:00,]');

        expect(range.isInRange(DateTime.utc(2021, 6, 15, 0, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 2, 0, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 1, 0, 0, 0)), false);
      });

      test(
          'should return true when checking if a value less than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31T00:00:00]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 3, 15, 0, 0, 0)), true);
      });

      test(
          'should return false when checking if a value bigger than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31T00:00:00]');

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
            '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
            '[2023-01-01T10:00:00, 2023-01-01T15:00:00]',
          ),
          true,
        );
      });

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
            '[2023-01-01T09:00:00, 2023-01-01T11:00:00]',
          ),
          true,
        );
      });

      test('should return true if ranges have the same start or end points ',
          () {
        // Ranges have the same start or end points
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
            '[2023-01-01T08:00:00, 2023-01-01T14:00:00]',
          ),
          true,
        );
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
            '[2023-01-01T05:00:00, 2023-01-01T08:00:00]',
          ),
          true,
        );
      });

      test('should return false if ranges touch but do not overlap', () {
        // Ranges touch but do not overlap
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00, 2023-01-01T12:00:00]',
            '(2023-01-01T12:00:00, 2023-01-01T16:00:00]',
          ),
          false,
        );
      });

      test('should return false if ranges do not overlap', () {
        // Ranges don't overlap
        expect(
          checkOverlap(
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
    });

    group('overlaps() unbounded tests', () {
      late final bool Function(String range1, String range2) checkOverlap;

      setUpAll(() {
        checkOverlap = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.timestamp,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.timestamp,
          );
          return r1.overlaps(r2);
        };
      });

      test('should return true when checking if a [,] range overlaps any other',
          () {
        // Ranges overlap because an unbounded range overlaps any other range
        expect(
          checkOverlap('[,]', '[2022-01-01T00:00:00, 2022-12-31T00:00:00]'),
          true,
        );
      });

      test(
          'should return true if the upper bound is greater than the other lower bound in a [,b] range',
          () {
        // Ranges overlap because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
        expect(
          checkOverlap(
              '[,2023-01-01T00:00:00]', '[2022-01-01,2022-12-31T00:00:00]'),
          true,
        );
      });

      test(
          'should return false if the upper bound is less than the other lower bound in a [,b] range',
          () {
        // Ranges do not overlap because 2021-01-01T00:00:00 < 2022-01-01T00:00:00
        expect(
          checkOverlap(
              '[,2021-01-01T00:00:00]', '[2022-01-01,2022-12-31T00:00:00]'),
          false,
        );
      });

      test(
          'should return true if the lower bound is less than the other in a [b,] range',
          () {
        // Ranges overlap because 2021-01-01T00:00:00 < 2022-01-01T00:00:00
        expect(
          checkOverlap('[2021-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2022-12-31T00:00:00]'),
          true,
        );
      });

      test(
          'should return false if the lower bound is greater than the other upper bound in a [b,] range',
          () {
        // Ranges do not overlap because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
        expect(
          checkOverlap('[2023-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2022-12-31T00:00:00]'),
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
      });

      test('should return false if ranges are not adjacent', () {
        // Two date ranges are not adjacent
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

    group('isAdjacent() unbounded tests', () {
      late final bool Function(String range1, String range2) checkAdjacency;

      setUpAll(() {
        checkAdjacency = (String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.timestamp,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.timestamp,
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
            '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
          ),
          false,
        );
        expect(
          checkAdjacency(
            '[,2022-12-31T00:00:00]',
            '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
          ),
          false,
        );
        expect(
          checkAdjacency(
            '[2022-01-01T00:00:00,]',
            '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
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
          getComparable('[2022-01-01T00:00:00,2022-01-01T15:00:00]'),
          isA<RangeComparable<DateTime>>(),
        );
      });

      test(
          'should return the correct comparable on [] ranges (omitting milliseconds)',
          () {
        final comparable =
            getComparable('[2022-01-01T00:00:00,2022-01-01T15:00:00]');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 15, 0, 0),
        );
      });

      test(
          'should return the correct comparable on [] ranges (with milliseconds)',
          () {
        final comparable =
            getComparable('[2022-01-01T00:00:00.000,2022-01-01T15:00:00.999]');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 15, 0, 0, 999),
        );
      });

      test(
          'should return the correct comparable on [) ranges (omitting milliseconds)',
          () {
        final comparable =
            getComparable('[2022-01-01T00:00:00,2022-01-01T15:00:00)');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 59, 59, 999),
        );
      });

      test(
          'should return the correct comparable on [) ranges (with milliseconds)',
          () {
        final comparable =
            getComparable('[2022-01-01T00:00:00.000,2022-01-01T15:00:00.999)');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 15, 0, 0, 998),
        );
      });

      test(
          'should return the correct comparable on (] ranges (omitting milliseconds)',
          () {
        final comparable =
            getComparable('(2022-01-01T00:00:00,2022-01-01T15:00:00]');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0, 1),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 15, 0, 0),
        );
      });

      test(
          'should return the correct comparable on (] ranges (with milliseconds)',
          () {
        final comparable =
            getComparable('(2022-01-01T00:00:00.000,2022-01-01T15:00:00.999]');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0, 1),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 15, 0, 0, 999),
        );
      });

      test(
          'should return the correct comparable on () ranges (omitting milliseconds)',
          () {
        final comparable =
            getComparable('(2022-01-01T00:00:00,2022-01-01T15:00:00)');

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 0, 0, 0, 1),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 59, 59, 999),
        );
      });

      test(
          'should return the correct comparable on () ranges (with milliseconds)',
          () {
        final comparable =
            getComparable('(2022-01-01T00:00:00.000,2022-01-01T15:00:00.999)');

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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });

      group('greater than tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01
          expect(
            gt(
              '[2022-01-02T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gt(
              '[2022-06-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
        });

        test('should return false when the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            gt(
              '[2021-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            gt(
              '[2021-06-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gt(
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
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
              '[2022-01-01T00:00:00, 2022-06-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00, 2022-06-01T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            false,
          );
        });

        test('should return false if values are equal', () {
          // Values are equal
          expect(
            gt(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            false,
          );
        });
      });

      group('greater than or equal to tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01
          expect(
            gte(
              '[2022-01-02T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gte(
              '[2022-06-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            gte(
              '[2021-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            gte(
              '[2021-06-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gte(
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
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
              '[2022-01-01T00:00:00, 2022-06-01T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00, 2022-06-01T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            gte(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            true,
          );
        });
      });

      group('less than tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            lt(
              '[2021-01-01T00:00:00, 2022-11-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '[2021-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01
          expect(
            lt(
              '[2022-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2021-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            lt(
              '[2022-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2021-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
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
              '[2022-01-01T00:00:00, 2024-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2024-01-01T00:00:00)',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
            ),
            false,
          );
        });

        test('should return false if ranges are equal', () {
          // Values are equal
          expect(
            lt(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            false,
          );
        });
      });

      group('less than or equal to tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01
          expect(
            lt(
              '[2021-01-01T00:00:00, 2022-11-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '[2021-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01
          expect(
            lt(
              '[2022-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2021-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            false,
          );
          expect(
            lt(
              '[2022-06-01T00:00:00, 2022-11-31T00:00:00]',
              '[2021-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
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
              '[2022-01-01T00:00:00, 2024-01-01T00:00:00]',
              '[2022-01-01T00:00:00, 2023-01-01T00:00:00]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00, 2024-01-01T00:00:00)',
              '(2022-01-01T00:00:00, 2023-01-01T00:00:00)',
            ),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            lte(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            lte(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            true,
          );
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            ceq(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            ceq(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
              '(2022-01-01T00:00:00, 2022-12-31T00:00:00)',
            ),
            true,
          );
        });

        test('should return true if the ranges cover the same values', () {
          // Ranges cover same values
          expect(
            ceq(
              '[2022-01-01T00:00:00.001, 2022-12-31T00:00:00.998]',
              '(2022-01-01T00:00:00.000, 2022-12-31T00:00:00.999)',
            ),
            true,
          );
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(
            ceq(
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
              '[2024-01-01T00:00:00, 2024-12-31T00:00:00]',
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
      late final bool Function(String range1, String range2) ceq;

      setUpAll(() {
        (DateRangeType, DateRangeType) getRangePair(
            String range1, String range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.timestamp,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.timestamp,
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
              '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
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
          // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,2024-00-00T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2024-00-00T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,2024-00-00T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,]',
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
              '[2022-01-01T00:00:00,]',
              '[,2021-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gt(
              '[2022-01-01T00:00:00,]',
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
              '[,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2021-01-01T00:00:00,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2021-01-01T00:00:00,2023-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01 T00:00:00< 2024-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2021-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[,2023-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gt(
              '[,2023-01-01T00:00:00]',
              '[,2024-01-01T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
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
          // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Equal to because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Equal to because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[,2021-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            gte(
              '[2022-01-01T00:00:00,]',
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
              '[,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2023-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Equal to because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[,2023-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            gte(
              '[,2023-01-01T00:00:00]',
              '[,2024-01-01T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
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
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[,2021-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lt(
              '[2022-01-01T00:00:00,]',
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
              '[,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2023-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[,2023-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lt(
              '[,2023-01-01T00:00:00]',
              '[,2024-01-01T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,2022-12-31T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
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
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2021-01-01T00:00:00,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 > 2021-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[,2021-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 == 2022-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00 < 2023-01-01T00:00:00
          expect(
            lte(
              '[2022-01-01T00:00:00,]',
              '[,2023-01-01T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
              '[,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2022-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2023-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2020-01-01T00:00:00,2024-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,2025-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2023-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[2024-01-01T00:00:00,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00 > 2022-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[,2022-01-01T00:00:00]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00 == 2023-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[,2023-01-01T00:00:00]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01T00:00:00 < 2024-01-01T00:00:00
          expect(
            lte(
              '[,2023-01-01T00:00:00]',
              '[,2024-01-01T00:00:00]',
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
              '[,2023-01-01T00:00:00]',
              '[,]',
            ),
            true,
          );
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal with the same inclusivity',
            () {
          // Values are equal
          expect(
            ceq(
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00]',
              '[,2022-12-31T00:00:00]',
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
              '[2022-01-01T00:00:00,]',
              '[2022-01-01T00:00:00,]',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00,]',
              '(2022-01-01T00:00:00,]',
            ),
            true,
          );
          expect(
            ceq(
              '[2022-01-01T00:00:00,)',
              '[2022-01-01T00:00:00,)',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00,)',
              '(2022-01-01T00:00:00,)',
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
              '[,2022-12-31T00:00:00]',
              '[,2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            ceq(
              '(,2022-12-31T00:00:00]',
              '(,2022-12-31T00:00:00]',
            ),
            true,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00)',
              '[,2022-12-31T00:00:00)',
            ),
            true,
          );
          expect(
            ceq(
              '(,2022-12-31T00:00:00)',
              '(,2022-12-31T00:00:00)',
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
              '[2022-01-01T00:00:00.001,]',
              '(2022-01-01T00:00:00.000,)',
            ),
            true,
          );
        });

        test('should return true if the [,b] ranges cover the same values', () {
          // Ranges cover same values
          expect(
            ceq(
              '[,2022-12-31T00:00:00.998]',
              '(,2022-12-31T00:00:00.999)',
            ),
            true,
          );
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(
            ceq(
              '[2022-01-01T00:00:00,]',
              '[2023-01-01T00:00:00,]',
            ),
            false,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00]',
              '[,2023-12-31T00:00:00]',
            ),
            false,
          );
        });
      });
    });
  });

  group('DateRangeType timestamptz UTC', () {
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
        expect(
            () => createRange('[2022-01-01T00:00:00.999Z,]'), returnsNormally);
        expect(
          createRange('[2022-01-01T00:00:00.999Z,]'),
          isA<DateRangeType>(),
        );
      });

      test('should be able to create a [,b] range', () {
        expect(
            () => createRange('[,2022-01-01T15:00:00.999Z]'), returnsNormally);
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

      test('should throw an Exception when infering the type of a [,] range',
          () {
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

      test(
          'should create a [b,b] range with the correct lower and upper values',
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

      test('should create a [,b] range with the correct correct inclusivity',
          () {
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

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00.000Z, 2023-01-01T12:00:00.000Z]',
            '[2023-01-01T09:00:00.000Z, 2023-01-01T11:00:00.000Z]',
          ),
          true,
        );
      });

      test('should return true if ranges have the same start or end points ',
          () {
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

        test('should return false if the lower bound is less than the other',
            () {
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
        test('should return true if the lower bound is less than the other',
            () {
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
        test('should return true if the lower bound is less than the other',
            () {
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
  });

  group('DateRangeType timestamptz timezone offset', () {
    test('should successfuly create a range of UTC timestamptz type', () {
      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.999+01]',
        ),
        returnsNormally,
      );

      expect(
        RangeType.createRange(
          range: '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
        ),
        isA<DateRangeType>(),
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-12-31T00:00:00.000-01, 2022-01-01T00:00:00.000+01]',
        ),
        throwsException,
      );
    });

    test(
        'should throw an Exception if the lower bound is greater than the upper bound with force type',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-12-31T00:00:00.000-01, 2022-01-01T00:00:00.000+01]',
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
          range: '[2022-01-01T00:00:00.000-01, 2022-01-01T00:00:00.000-01]',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '(2022-01-01T00:00:00.000-01, 2022-01-01T00:00:00.000-01]',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000-01, 2022-01-01T00:00:00.000-01)',
        ),
        returnsNormally,
      );

      expect(
        () => RangeType.createRange(
          range: '(2022-01-01T00:00:00.000-01, 2022-01-01T00:00:00.000-01)',
        ),
        returnsNormally,
      );
    });

    test('should ensure that range is of UTC timestamptz type', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.999+01]',
      );
      expect(range.rangeDataType, RangeDataType.timestamptz);
    });

    test(
        'should throw an Exception when the second value does not match the type of the first',
        () {
      expect(
        () => RangeType.createRange(
          range: '[2022-01-01T00:00:00.000-01, 20.0]',
        ),
        throwsException,
      );
    });

    test('should return the correct raw range string', () {
      final range = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.999+01]',
      );
      expect(range.rawRangeString,
          '[2022-01-01T00:00:00.000-01:00,2022-01-01T15:00:00.999+01:00]');
    });

    test('should remove spaces from raw range string', () {
      final range = RangeType.createRange(
        range:
            '[      2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.999+01       ]',
      );
      expect(
        range.rawRangeString,
        '[2022-01-01T00:00:00.000-01:00,2022-01-01T15:00:00.999+01:00]',
      );
    });

    test('should successfuly create inclusive and exclusive ranges', () {
      final range1 = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.000+01]',
      );
      final range2 = RangeType.createRange(
        range: '(2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.000+01)',
      );
      final range3 = RangeType.createRange(
        range: '[2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.000+01)',
      );
      final range4 = RangeType.createRange(
        range: '(2022-01-01T00:00:00.000-01, 2022-01-01T15:00:00.000+01]',
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
        expect(() => createRange('[2022-01-01T00:00:00.999-01,]'),
            returnsNormally);
        expect(
          createRange('[2022-01-01T00:00:00.999-01,]'),
          isA<DateRangeType>(),
        );
      });

      test('should be able to create a [,b] range', () {
        expect(() => createRange('[,2022-01-01T15:00:00.999+01]'),
            returnsNormally);
        expect(
          createRange('[,2022-01-01T15:00:00.999+01]'),
          isA<DateRangeType>(),
        );
      });

      test('should create a [,] range with the correct type', () {
        final range = createRange('[,]');
        expect(range.rangeDataType, RangeDataType.timestamptz);
      });

      test('should create a [b,] range with the correct type', () {
        final range = createRange('[2022-01-01T00:00:00.999-01,]');
        expect(range.rangeDataType, RangeDataType.timestamptz);
      });

      test('should create a [,b] range with the correct type', () {
        final range = createRange('[,2022-01-01T15:00:00.999+01]');
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
        final range = createRange('[2022-01-01T00:00:00.999-01,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 1, 0, 0, 999));
        expect(range.upperRange, null);
      });

      test(
          'should create a [,b] range with the correct lower and upper bound values',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999+01]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 14, 0, 0, 999));
      });

      test('should create a [,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [b,] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[2022-01-01T00:00:00.000-01,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct inclusivity', () {
        // When a bound is unspecified, it is always converted to exclusive
        final range = createRange('[,2022-01-01T15:00:00.000+01]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [,] range with the correct raw range string', () {
        final range = createRange('[,]');
        expect(range.rawRangeString, '(,)');
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01T00:00:00.000-01,]');
        expect(range.rawRangeString, '[2022-01-01T00:00:00.000-01:00,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-01-01T15:00:00.000+01]');
        expect(range.rawRangeString, '(,2022-01-01T15:00:00.000+01:00]');
      });

      test('should return false when checking if a [,] range is empty', () {
        final range = createRange('[,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01T00:00:00.000-01,]');
        expect(range.isEmpty, false);
      });

      test('should return false when checking if a [,b] range is empty', () {
        final range = createRange('[,2022-01-01T15:00:00.000+01]');
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
        final range = createRange('[2022-01-01T00:00:00.999-01,]');
        expect(range.rangeDataType, RangeDataType.timestamptz);
      });

      test(
          'should be able to infer the type when only the upper bound is specified',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999+01]');
        expect(range.rangeDataType, RangeDataType.timestamptz);
      });

      test(
          'should be able to infer the type when both the upper and lower bounds are specified',
          () {
        final range = createRange(
          '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.999+01]',
        );
        expect(range.rangeDataType, RangeDataType.timestamptz);
      });

      test('should throw an Exception when infering the type of a [,] range',
          () {
        expect(() => createRange('[,]'), throwsException);
      });

      test('should create a [b,] range with the correct lower and upper values',
          () {
        final range = createRange('[2022-01-01T00:00:00.999-01,]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 1, 0, 0, 999));
        expect(range.upperRange, null);
      });

      test('should create a [,b] range with the correct lower and upper values',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999+01]');
        expect(range.lowerRange, null);
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 14, 0, 0, 999));
      });

      test(
          'should create a [b,b] range with the correct lower and upper values',
          () {
        final range = createRange(
            '[2022-01-01T00:00:00.999-01,2022-01-01T15:00:00.999+01]');
        expect(range.lowerRange, DateTime.utc(2022, 1, 1, 1, 0, 0, 999));
        expect(range.upperRange, DateTime.utc(2022, 1, 1, 14, 0, 0, 999));
      });

      test('should create a [b,] range with the correct inclusivity', () {
        final range = createRange('[2022-01-01T00:00:00.999-01,]');
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, false);
      });

      test('should create a [,b] range with the correct correct inclusivity',
          () {
        final range = createRange('[,2022-01-01T15:00:00.999+01]');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,b] range with the correct inclusivity', () {
        final range = createRange(
          '[2022-01-01T00:00:00.999-01,2022-01-01T15:00:00.999+01]',
        );
        expect(range.lowerRangeInclusive, true);
        expect(range.upperRangeInclusive, true);
      });

      test('should create a [b,] range with the correct raw range string', () {
        final range = createRange('[2022-01-01T00:00:00.000-01,]');
        expect(range.rawRangeString, '[2022-01-01T00:00:00.000-01:00,)');
      });

      test('should create a [,b] range with the correct raw range string', () {
        final range = createRange('[,2022-01-01T15:00:00.000+01]');
        expect(range.rawRangeString, '(,2022-01-01T15:00:00.000+01:00]');
      });

      test('should create a [b,b] range with the correct raw range string', () {
        final range = createRange(
          '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.000+01]',
        );
        expect(
          range.rawRangeString,
          '[2022-01-01T00:00:00.000-01:00,2022-01-01T15:00:00.000+01:00]',
        );
      });

      test('should return false when cheking if a [b,] range is empty', () {
        final range = createRange('[2022-01-01T00:00:00.000-01,]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [,b] range is empty', () {
        final range = createRange('[,2022-01-01T15:00:00.000+01]');
        expect(range.isEmpty, false);
      });

      test('should return false when cheking if a [b,b] range is empty', () {
        final range = createRange(
          '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.000+01]',
        );
        expect(range.isEmpty, false);
      });
    });

    group('isInRange() tests', () {
      test(
          'should return the correct value when calling isInRange() on a inclusive range',
          () {
        final range = RangeType.createRange(
          range: '[2022-01-01T12:00:00.999-01, 2022-12-31T12:00:00.999+01]',
        );
        expect(
          range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 1, 1, 13, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 12, 31, 11, 0, 0, 999)),
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
          range: '(2022-01-01T12:00:00.999-01, 2022-12-31T12:00:00.999+01)',
        );
        expect(
          range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 1, 1, 13, 0, 0, 999)),
          false,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 12, 31, 11, 0, 0, 999)),
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
          range: '[2022-01-01T12:00:00.999-01, 2022-12-31T12:00:00.999+01)',
        );
        expect(
          range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 1, 1, 13, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 12, 31, 11, 0, 0, 999)),
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
          range: '(2022-01-01T12:00:00.999-01, 2022-12-31T12:00:00.999+01]',
        );
        expect(
          range.isInRange(DateTime.utc(2022, 6, 15, 12, 0, 0, 999)),
          true,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 1, 1, 13, 0, 0, 999)),
          false,
        );
        expect(
          range.isInRange(DateTime.utc(2022, 12, 31, 11, 0, 0, 999)),
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
        final range = createRange('[2022-01-01T00:00:00-01,]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2023, 1, 1, 0, 0, 0)), true);
      });

      test(
          'should return false when checking if a value less than the lower range is within a [b,] range',
          () {
        final range = createRange('[2022-01-01T00:00:00-01,]');

        expect(range.isInRange(DateTime.utc(2021, 6, 15, 0, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 2, 0, 0, 0)), false);
        expect(range.isInRange(DateTime.utc(2021, 1, 1, 0, 0, 0)), false);
      });

      test(
          'should return true when checking if a value less than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31T00:00:00+01]');

        expect(range.isInRange(DateTime.utc(2022, 6, 15, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 1, 2, 0, 0, 0)), true);
        expect(range.isInRange(DateTime.utc(2022, 3, 15, 0, 0, 0)), true);
      });

      test(
          'should return false when checking if a value bigger than the upper range is within a [,b] range',
          () {
        final range = createRange('[,2022-12-31T00:00:00+01]');

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
            '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
            '[2023-01-01T10:00:00-01, 2023-01-01T15:00:00+01]',
          ),
          true,
        );
      });

      test('should return true if one range is completely within the other',
          () {
        // One range is completely within the other
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
            '[2023-01-01T09:00:00-01, 2023-01-01T11:00:00+01]',
          ),
          true,
        );
      });

      test('should return true if ranges have the same start or end points ',
          () {
        // Ranges have the same start or end points
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
            '[2023-01-01T08:00:00-01, 2023-01-01T14:00:00+01]',
          ),
          true,
        );
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
            '[2023-01-01T05:00:00+01, 2023-01-01T08:00:00-01]',
          ),
          true,
        );
      });

      test('should return false if ranges touch but do not overlap', () {
        // Ranges touch but do not overlap
        expect(
          checkOverlap(
            '[2023-01-01T08:00:00-01, 2023-01-01T12:00:00+01]',
            '[2023-01-01T12:00:00-01, 2023-01-01T16:00:00+01]',
          ),
          false,
        );
      });

      test('should return false if ranges do not overlap', () {
        // Ranges don't overlap
        expect(
          checkOverlap(
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
          range: '[2023-01-01T08:00:00-01, 2023-01-01T10:00:00+01]',
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
            '[2022-01-01T00:00:00-01, 2022-12-31T00:00:00+01]',
          ),
          true,
        );
      });

      test(
          'should return true if the upper bound is greater than the other lower bound in a [,b] range',
          () {
        // Ranges overlap because 2023-01-01T00:00:00-01 > 2022-01-01T00:00:00-01
        expect(
          checkOverlap(
            '[,2023-01-01T00:00:00-01]',
            '[2022-01-01T00:00:00-01,2022-12-31T00:00:00+01]',
          ),
          true,
        );
      });

      test(
          'should return false if the upper bound is less than the other lower bound in a [,b] range',
          () {
        // Ranges do not overlap because 2021-01-01T00:00:00-01 < 2022-01-01T00:00:00-01
        expect(
          checkOverlap(
            '[,2021-01-01T00:00:00-01]',
            '[2022-01-01T00:00:00-01,2022-12-31T00:00:00+01]',
          ),
          false,
        );
      });

      test(
          'should return true if the lower bound is less than the other in a [b,] range',
          () {
        // Ranges overlap because 2021-01-01T00:00:00-01 < 2022-01-01T00:00:00+01
        expect(
          checkOverlap(
            '[2021-01-01T00:00:00-01,]',
            '[2022-01-01T00:00:00-01,2022-12-31T00:00:00+01]',
          ),
          true,
        );
      });

      test(
          'should return false if the lower bound is greater than the other upper bound in a [b,] range',
          () {
        // Ranges do not overlap because 2023-01-01T00:00:00-01 > 2022-01-01T00:00:00+01
        expect(
          checkOverlap(
            '[2023-01-01T00:00:00-01,]',
            '[2022-01-01T00:00:00-01,2022-12-31T00:00:00+01]',
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
      });

      test('should return false if ranges are not adjacent', () {
        // Two date ranges are not adjacent
        expect(
          checkAdjacency(
            '[2023-01-01T00:00:00.000-01, 2023-01-10T00:00:00.000+01]',
            '[2023-01-12T00:00:00.000+01, 2023-01-20T00:00:00.000-01]',
          ),
          false,
        );
        expect(
          checkAdjacency(
            '[2023-01-01T00:00:00.000-01, 2023-01-10T00:00:00.000+01]',
            '[2023-01-21T00:00:00.000+01, 2023-01-30T00:00:00.000-01]',
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
            '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
          ),
          false,
        );
        expect(
          checkAdjacency(
            '[,2022-12-31T00:00:00.000-01]',
            '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
          ),
          false,
        );
        expect(
          checkAdjacency(
            '[2022-01-01T00:00:00.000-01,]',
            '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
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
            '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.000+01]',
          ),
          isA<RangeComparable<DateTime>>(),
        );
      });

      test('should return the correct comparable on [] ranges', () {
        final comparable = getComparable(
          '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.999+01]',
        );

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 1, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 0, 0, 999),
        );
      });

      test('should return the correct comparable on [) ranges', () {
        final comparable = getComparable(
          '[2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.999+01)',
        );

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 1, 0, 0, 0),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 0, 0, 998),
        );
      });

      test('should return the correct comparable on (] ranges', () {
        final comparable = getComparable(
          '(2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.999+01]',
        );

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 1, 0, 0, 1),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 0, 0, 999),
        );
      });

      test('should return the correct comparable on () ranges', () {
        final comparable = getComparable(
          '(2022-01-01T00:00:00.000-01,2022-01-01T15:00:00.999+01)',
        );

        expect(
          comparable.lowerRange,
          DateTime.utc(2022, 1, 1, 1, 0, 0, 1),
        );
        expect(
          comparable.upperRange,
          DateTime.utc(2022, 1, 1, 14, 0, 0, 998),
        );
      });
    });

    group('comparison tests', () {
      late final bool Function(String range1, String range2) gt;
      late final bool Function(String range1, String range2) gte;
      late final bool Function(String range1, String range2) lt;
      late final bool Function(String range1, String range2) lte;
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

        ceq = (range1, range2) {
          final (c1, c2) = getRangePair(range1, range2);
          return c1.getComparable() == c2.getComparable();
        };
      });

      group('greater than tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01T00:00:00-01
          expect(
            gt(
              '[2022-01-02T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gt(
              '[2022-06-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
        });

        test('should return false when the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01T00:00:00.000-01
          expect(
            gt(
              '[2021-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            gt(
              '[2021-06-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
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
              '[2022-01-01T00:00:00.000-01, 2022-06-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00.000-01, 2022-06-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            false,
          );
        });

        test('should return false if values are equal', () {
          // Values are equal
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            gt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            false,
          );
        });
      });

      group('greater than or equal to tests', () {
        test('should return true if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-02T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gte(
              '[2022-06-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[2021-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            gte(
              '[2021-06-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
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
              '[2022-01-01T00:00:00.000-01, 2022-06-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00.000-01, 2022-06-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            gte(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            true,
          );
        });
      });

      group('less than tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[2021-01-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '[2021-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            lt(
              '[2022-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
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
              '[2022-01-01T00:00:00.000-01, 2024-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2024-01-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
            ),
            false,
          );
        });

        test('should return false if ranges are equal', () {
          // Values are equal
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            false,
          );
        });
      });

      group('less than or equal to tests', () {
        test('should return true if the lower bound is less than the other',
            () {
          // Lower bounds are less than 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[2021-01-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '[2021-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
        });

        test('should return false if the lower bound is greater than the other',
            () {
          // Lower bounds are greater than 2021-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            lt(
              '[2022-06-01T00:00:00.000-01, 2022-11-31T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
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
              '[2022-01-01T00:00:00.000-01, 2024-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
          expect(
            lt(
              '(2022-01-01T00:00:00.000-01, 2024-01-01T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2023-01-01T00:00:00.000+01)',
            ),
            false,
          );
        });

        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            lte(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            true,
          );
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal', () {
          // Values are equal
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01)',
            ),
            true,
          );
        });

        test('should return true if the ranges cover the same values', () {
          // Ranges cover same values
          expect(
            ceq(
              '[2022-01-01T00:00:00.001-01, 2022-12-31T00:00:00.998+01]',
              '(2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.999+01)',
            ),
            true,
          );
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01, 2024-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01, 2022-12-31T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
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
          // Greater than because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,2024-00-00T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,2024-00-00T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,2024-00-00T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00-01 > 2021-01-01T00:00:00+01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2021-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000+01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000+01
          expect(
            gt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
              '[,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01,2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2021-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            gt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2024-01-01T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
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
          // Greater than because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // Equal to because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Not greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // Equal to because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Not greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000+01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2021-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000+01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // Greater than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000+01
          expect(
            gte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
              '[,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Greater than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Equal to because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Not greater than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            gte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2024-01-01T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
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
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000+01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2021-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000+01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000+01
          expect(
            lt(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
              '[,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2023-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            lt(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2024-01-01T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,2022-12-31T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
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
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the lower bound of the other [b,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,b] range',
            () {
          // Less than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2021-01-01T00:00:00.000-01,]',
            ),
            false,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is equal to the lower bound of the other [b,] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the lower bound of a [b,] range is less than the lower bound of the other [b,] range',
            () {
          // Less than because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000-01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is greater than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 > 2021-01-01T00:00:00.000+01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2021-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is equal to the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 == 2022-01-01T00:00:00.000+01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return false when the lower bound of a [b,] range is less than the upper bound of the other [,b] range',
            () {
          // False because 2022-01-01T00:00:00.000-01 < 2023-01-01T00:00:00.000+01
          expect(
            lte(
              '[2022-01-01T00:00:00.000-01,]',
              '[,2023-01-01T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
              '[,]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2022-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2020-01-01T00:00:00.000-01,2024-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,2025-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is greater than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the lower bound of a [b,] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000-01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[2024-01-01T00:00:00.000-01,]',
            ),
            true,
          );
        });

        test(
            'should return false when the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00.000+01 > 2022-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2022-01-01T00:00:00.000+01]',
            ),
            false,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
            () {
          // Not less than because 2023-01-01T00:00:00.000+01 == 2023-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2023-01-01T00:00:00.000+01]',
            ),
            true,
          );
        });

        test(
            'should return true when the upper bound of a [,b] range is less than the upper bound of a [,b] range',
            () {
          // Less than because 2023-01-01T00:00:00.000+01 < 2024-01-01T00:00:00.000+01
          expect(
            lte(
              '[,2023-01-01T00:00:00.000+01]',
              '[,2024-01-01T00:00:00.000+01]',
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
              '[,2023-01-01T00:00:00.000+01]',
              '[,]',
            ),
            true,
          );
        });
      });

      group('comparable equality', () {
        test('should return true if ranges are equal with the same inclusivity',
            () {
          // Values are equal
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00.000+01]',
              '[,2022-12-31T00:00:00.000+01]',
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
              '[2022-01-01T00:00:00.000-01,]',
              '[2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00.000-01,]',
              '(2022-01-01T00:00:00.000-01,]',
            ),
            true,
          );
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01,)',
              '[2022-01-01T00:00:00.000-01,)',
            ),
            true,
          );
          expect(
            ceq(
              '(2022-01-01T00:00:00.000-01,)',
              '(2022-01-01T00:00:00.000-01,)',
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
              '[,2022-12-31T00:00:00.000+01]',
              '[,2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            ceq(
              '(,2022-12-31T00:00:00.000+01]',
              '(,2022-12-31T00:00:00.000+01]',
            ),
            true,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00.000+01)',
              '[,2022-12-31T00:00:00.000+01)',
            ),
            true,
          );
          expect(
            ceq(
              '(,2022-12-31T00:00:00.000+01)',
              '(,2022-12-31T00:00:00.000+01)',
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
              '[2022-01-01T00:00:00.001-01,]',
              '(2022-01-01T00:00:00.000-01,)',
            ),
            true,
          );
        });

        test('should return true if the [,b] ranges cover the same values', () {
          // Ranges cover same values
          expect(
            ceq(
              '[,2022-12-31T00:00:00.998+01]',
              '(,2022-12-31T00:00:00.999+01)',
            ),
            true,
          );
        });

        test('should return false if ranges are different', () {
          // Ranges are different
          expect(
            ceq(
              '[2022-01-01T00:00:00.000-01,]',
              '[2023-01-01T00:00:00.000-01,]',
            ),
            false,
          );
          expect(
            ceq(
              '[,2022-12-31T00:00:00.000+01]',
              '[,2023-12-31T00:00:00.000+01]',
            ),
            false,
          );
        });
      });
    });
  });

  group('empty range tests', () {
    test(
        'should throw an Exception when trying to create a range without a force type',
        () {
      expect(() => RangeType.createRange(range: ''), throwsException);
    });

    group('IntegerRangeType tests', () {
      late final IntegerRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.integer,
          ) as IntegerRangeType;
        };
      });

      test('should successfuly create an empty range', () {
        expect(() => createRange(''), returnsNormally);
        expect(createRange(''), isA<IntegerRangeType>());
      });

      test('should ensure that the range is of integer type', () {
        final range = createRange('');
        expect(range.rangeDataType, RangeDataType.integer);
      });

      test(
          'should return false when getting the inclusivity of the lower and upper bounds',
          () {
        final range = createRange('');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should return an empty string when getting the raw range string',
          () {
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
        expect(range.isInRange(0), false);
        expect(range.isInRange(1), false);
        expect(range.isInRange(2), false);
        expect(range.isInRange(-1), false);
      });

      test(
          'should return false when checking if any other range overlaps an empty range',
          () {
        final emptyRange = createRange('');
        final intRange = createRange('[10, 20]');

        expect(emptyRange.overlaps(intRange), false);
        expect(intRange.overlaps(emptyRange), false);
      });

      test(
          'should return false when checking if any other range is adjacent of an empty range',
          () {
        final emptyRange = createRange('');
        final intRange = createRange('[10, 20]');

        expect(emptyRange.isAdjacent(intRange), false);
        expect(intRange.isAdjacent(emptyRange), false);
      });

      test(
          'should throw an Exception when trying to get the comparable of an empty range',
          () {
        final range = createRange('');
        expect(() => range.getComparable(), throwsException);
      });

      group('empty range comparisons', () {
        late final bool Function(String range1, String range2) gt;
        late final bool Function(String range1, String range2) gte;
        late final bool Function(String range1, String range2) lt;
        late final bool Function(String range1, String range2) lte;

        setUpAll(() {
          (IntegerRangeType, IntegerRangeType) getRangePair(
              String range1, String range2) {
            final r1 = RangeType.createRange(
              range: range1,
              forceType: RangeDataType.integer,
            );
            final r2 = RangeType.createRange(
              range: range2,
              forceType: RangeDataType.integer,
            );

            return (r1, r2) as (IntegerRangeType, IntegerRangeType);
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
          expect(gt('', '[10, 20]'), false);
          expect(gt('[10, 20]', ''), false);
        });

        test(
            'should return false when checking if an empty range is greater than or equal to any other',
            () {
          expect(gte('', '[10, 20]'), false);
          expect(gte('[10, 20]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than any other',
            () {
          expect(lt('', '[10, 20]'), false);
          expect(lt('[10, 20]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than  or equal to any other',
            () {
          expect(lte('', '[10, 20]'), false);
          expect(lte('[10, 20]', ''), false);
        });
      });
    });

    group('FloatRangeType tests', () {
      late final FloatRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.float,
          ) as FloatRangeType;
        };
      });

      test('should successfuly create an empty range', () {
        expect(() => createRange(''), returnsNormally);
        expect(createRange(''), isA<FloatRangeType>());
      });

      test('should ensure that the range is of integer type', () {
        final range = createRange('');
        expect(range.rangeDataType, RangeDataType.float);
      });

      test(
          'should return false when getting the inclusivity of the lower and upper bounds',
          () {
        final range = createRange('');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should return an empty string when getting the raw range string',
          () {
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
        expect(range.isInRange(0.0), false);
        expect(range.isInRange(1.0), false);
        expect(range.isInRange(2.0), false);
        expect(range.isInRange(-1.0), false);
      });

      test(
          'should return false when checking if any other range overlaps an empty range',
          () {
        final emptyRange = createRange('');
        final floatRange = createRange('[10.0, 20.0]');
        expect(emptyRange.overlaps(floatRange), false);
        expect(floatRange.overlaps(emptyRange), false);
      });

      test(
          'should return false when checking if any other range is adjacent of an empty range',
          () {
        final emptyRange = createRange('');
        final floatRange = createRange('[10.0, 20.0]');
        expect(emptyRange.isAdjacent(floatRange), false);
        expect(floatRange.isAdjacent(emptyRange), false);
      });

      test(
          'should return throw an Exception when trying to get the comparable of an empty range',
          () {
        final range = createRange('');
        expect(() => range.getComparable(), throwsException);
      });

      group('empty range comparisons', () {
        late final bool Function(String range1, String range2) gt;
        late final bool Function(String range1, String range2) gte;
        late final bool Function(String range1, String range2) lt;
        late final bool Function(String range1, String range2) lte;

        setUpAll(() {
          (FloatRangeType, FloatRangeType) getRangePair(
              String range1, String range2) {
            final r1 = RangeType.createRange(
              range: range1,
              forceType: RangeDataType.float,
            );
            final r2 = RangeType.createRange(
              range: range2,
              forceType: RangeDataType.float,
            );

            return (r1, r2) as (FloatRangeType, FloatRangeType);
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
          expect(gt('', '[10.0, 20.0]'), false);
          expect(gt('[10.0, 20.0]', ''), false);
        });

        test(
            'should return false when checking if an empty range is greater than or equal to any other',
            () {
          expect(gte('', '[10.0, 20.0]'), false);
          expect(gte('[10.0, 20.0]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than any other',
            () {
          expect(lt('', '[10.0, 20.0]'), false);
          expect(lt('[10.0, 20.0]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than  or equal to any other',
            () {
          expect(lte('', '[10.0, 20.0]'), false);
          expect(lte('[10.0, 20.0]', ''), false);
        });
      });
    });

    group('DateRangeType tests', () {
      late final DateRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.date,
          ) as DateRangeType;
        };
      });

      test('should successfuly create an empty range', () {
        expect(() => createRange(''), returnsNormally);
        expect(createRange(''), isA<DateRangeType>());
      });

      test('should ensure that the range is of integer type', () {
        final range = createRange('');
        expect(range.rangeDataType, RangeDataType.date);
      });

      test(
          'should return false when getting the inclusivity of the lower and upper bounds',
          () {
        final range = createRange('');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should return an empty string when getting the raw range string',
          () {
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
        expect(range.isInRange(DateTime.utc(2020, 01, 01)), false);
        expect(range.isInRange(DateTime.utc(2021, 01, 01)), false);
        expect(range.isInRange(DateTime.utc(2022, 01, 01)), false);
        expect(range.isInRange(DateTime.utc(2023, 01, 01)), false);
      });

      test(
          'should return false when checking if any other range overlaps an empty range',
          () {
        final emptyRange = createRange('');
        final dateRange = createRange('[2022-01-01, 2022-12-31]');
        expect(emptyRange.overlaps(dateRange), false);
        expect(dateRange.overlaps(emptyRange), false);
      });

      test(
          'should return false when checking if any other range is adjacent of an empty range',
          () {
        final emptyRange = createRange('');
        final dateRange = createRange('[2022-01-01, 2022-12-31]');
        expect(emptyRange.isAdjacent(dateRange), false);
        expect(dateRange.isAdjacent(emptyRange), false);
      });

      test(
          'should return throw an Exception when trying to get the comparable of an empty range',
          () {
        final range = createRange('');
        expect(() => range.getComparable(), throwsException);
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
              forceType: RangeDataType.date,
            );
            final r2 = RangeType.createRange(
              range: range2,
              forceType: RangeDataType.date,
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
          expect(gt('', '[2022-01-01, 2022-12-31]'), false);
          expect(gt('[2022-01-01, 2022-12-31]', ''), false);
        });

        test(
            'should return false when checking if an empty range is greater than or equal to any other',
            () {
          expect(gte('', '[2022-01-01, 2022-12-31]'), false);
          expect(gte('[2022-01-01, 2022-12-31]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than any other',
            () {
          expect(lt('', '[2022-01-01, 2022-12-31]'), false);
          expect(lt('[2022-01-01, 2022-12-31]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than  or equal to any other',
            () {
          expect(lte('', '[2022-01-01, 2022-12-31]'), false);
          expect(lte('[2022-01-01, 2022-12-31]', ''), false);
        });
      });
    });

    group('DateRangeType timestamp tests', () {
      late final DateRangeType Function(String range) createRange;

      setUpAll(() {
        createRange = (String rangeString) {
          return RangeType.createRange(
            range: rangeString,
            forceType: RangeDataType.timestamp,
          ) as DateRangeType;
        };
      });

      test('should successfuly create an empty range', () {
        expect(() => createRange(''), returnsNormally);
        expect(createRange(''), isA<DateRangeType>());
      });

      test('should ensure that the range is of integer type', () {
        final range = createRange('');
        expect(range.rangeDataType, RangeDataType.timestamp);
      });

      test(
          'should return false when getting the inclusivity of the lower and upper bounds',
          () {
        final range = createRange('');
        expect(range.lowerRangeInclusive, false);
        expect(range.upperRangeInclusive, false);
      });

      test('should return an empty string when getting the raw range string',
          () {
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
          '[2022-01-01T12:00:00, 2022-12-31T15:00:00]',
        );
        expect(emptyRange.overlaps(dateRange), false);
        expect(dateRange.overlaps(emptyRange), false);
      });

      test(
          'should return false when checking if any other range is adjacent of an empty range',
          () {
        final emptyRange = createRange('');
        final dateRange = createRange(
          '[2022-01-01T12:00:00, 2022-12-31T15:00:00]',
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
              forceType: RangeDataType.timestamp,
            );
            final r2 = RangeType.createRange(
              range: range2,
              forceType: RangeDataType.timestamp,
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
          expect(gt('', '[2022-01-01T12:00:00, 2022-12-31T15:00:00]'), false);
          expect(gt('[2022-01-01T12:00:00, 2022-12-31T15:00:00]', ''), false);
        });

        test(
            'should return false when checking if an empty range is greater than or equal to any other',
            () {
          expect(gte('', '[2022-01-01T12:00:00, 2022-12-31T15:00:00]'), false);
          expect(gte('[2022-01-01T12:00:00, 2022-12-31T15:00:00]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than any other',
            () {
          expect(lt('', '[2022-01-01T12:00:00, 2022-12-31T15:00:00]'), false);
          expect(lt('[2022-01-01T12:00:00, 2022-12-31T15:00:00]', ''), false);
        });

        test(
            'should return false when checking if an empty range is less than  or equal to any other',
            () {
          expect(lte('', '[2022-01-01T12:00:00, 2022-12-31T15:00:00]'), false);
          expect(lte('[2022-01-01T12:00:00, 2022-12-31T15:00:00]', ''), false);
        });
      });
    });

    group('DateRangeType UTC timestamptz tests', () {
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

      test('should return an empty string when getting the raw range string',
          () {
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
    });

    group('DateRangeType timestamptz with timezone offset tests', () {
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

      test('should return an empty string when getting the raw range string',
          () {
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
          '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
        );
        expect(emptyRange.overlaps(dateRange), false);
        expect(dateRange.overlaps(emptyRange), false);
      });

      test(
          'should return false when checking if any other range is adjacent of an empty range',
          () {
        final emptyRange = createRange('');
        final dateRange = createRange(
          '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
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
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
            ),
            false,
          );
          expect(
            gt(
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
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
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
            ),
            false,
          );
          expect(
            gte(
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
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
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
            ),
            false,
          );
          expect(
            lt(
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
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
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
            ),
            false,
          );
          expect(
            lte(
              '[2022-01-01T12:00:00-01, 2022-12-31T15:00:00+01]',
              '',
            ),
            false,
          );
        });
      });
    });
  });
}
