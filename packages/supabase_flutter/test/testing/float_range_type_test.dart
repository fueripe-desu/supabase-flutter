import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_type/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type/range_type.dart';

void main() {
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

    test('should be able to create a [,] range with \'null\'', () {
      expect(() => createRange('[null,null]'), returnsNormally);
      expect(createRange('[null,null]'), isA<FloatRangeType>());
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

    test('should throw an Exception when infering the type of a [,] range', () {
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

    test('should create a [b,b] range with the correct lower and upper values',
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

    test('should create a [,b] range with the correct correct inclusivity', () {
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

    test('should return true if one range is completely within the other', () {
      // One range is completely within the other
      expect(checkOverlap('[1.0, 10.0]', '[3.0, 8.0]'), true);
    });

    test('should return true if ranges have the same start or end points ', () {
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

  group('strictlyLeftOf() tests', () {
    late final bool Function(String range1, String range2) strictlyLeftOf;

    setUpAll(() {
      strictlyLeftOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.strictlyLeftOf(r2);
      };
    });

    test(
        'should return true if the lower bound is less than the other upper bound',
        () {
      expect(strictlyLeftOf('[10.0, 20.0]', '[30.0, 40.0]'), true);
    });

    test(
        'should return false if the lower bound is equal to the other upper bound',
        () {
      expect(strictlyLeftOf('[10.0, 20.0]', '[20.0, 40.0]'), false);
    });

    test(
        'should return false if the lower bound is greater than the other upper bound',
        () {
      expect(strictlyLeftOf('[10.0, 30.0]', '[20.0, 40.0]'), false);
    });
  });

  group('strictlyLeftOf() unbounded tests', () {
    late final bool Function(String range1, String range2) strictlyLeftOf;

    setUpAll(() {
      strictlyLeftOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.strictlyLeftOf(r2);
      };
    });
    test('should return false if both are [,] ranges', () {
      expect(strictlyLeftOf('[,]', '[,]'), false);
    });

    test('should return false if a [,] range is checked against a [b,] range',
        () {
      expect(strictlyLeftOf('[,]', '[30.0,]'), false);
    });

    test('should return false if a [,] range is checked against a [,b] range',
        () {
      expect(strictlyLeftOf('[,]', '[,40.0]'), false);
    });

    test('should return false if a [,] range is checked against a [b,b] range',
        () {
      expect(strictlyLeftOf('[,]', '[30.0,40.0]'), false);
    });

    test('should return false if a [b,] range is checked against a [,] range',
        () {
      expect(strictlyLeftOf('[10.0,]', '[,]'), false);
    });

    test('should return false if a [,b] range is checked against a [,] range',
        () {
      expect(strictlyLeftOf('[,20.0]', '[,]'), false);
    });

    test('should return false if a [b,b] range is checked against a [,] range',
        () {
      expect(strictlyLeftOf('[10.0,20.0]', '[,]'), false);
    });

    test('should return false if a [b,] range is checked against a [b,] range',
        () {
      expect(strictlyLeftOf('[10.0,]', '[30.0,]'), false);
    });

    test('should return false if a [b,] range is checked against a [,b] range',
        () {
      expect(strictlyLeftOf('[10.0,]', '[,40.0]'), false);
    });

    test('should return false if a [b,] range is checked against a [b,b] range',
        () {
      expect(strictlyLeftOf('[10.0,]', '[30.0,40.0]'), false);
    });

    test(
        'should return true if the lower bound of a [,b] range is less than the upper bound of a [b,] range',
        () {
      expect(strictlyLeftOf('[,20.0]', '[30.0,]'), true);
    });

    test('should return false if a [,b] range is checked against a [,b] range',
        () {
      expect(strictlyLeftOf('[,20.0]', '[,40.0]'), false);
    });

    test(
        'should return true if the lower bound of a [,b] range is less than the upper bound of a [b,b] range',
        () {
      expect(strictlyLeftOf('[,20.0]', '[30.0,40.0]'), true);
    });
  });

  group('strictlyRighttOf() tests', () {
    late final bool Function(String range1, String range2) strictlyRightOf;

    setUpAll(() {
      strictlyRightOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.strictlyRightOf(r2);
      };
    });

    test(
        'should return true if the lower bound is greater than the other upper bound',
        () {
      expect(strictlyRightOf('[30.0, 40.0]', '[10.0, 20.0]'), true);
    });

    test(
        'should return false if the lower bound is equal to the other upper bound',
        () {
      expect(strictlyRightOf('[30.0, 40.0]', '[10.0, 40.0]'), false);
    });

    test(
        'should return false if the lower bound is less than the other upper bound',
        () {
      expect(strictlyRightOf('[30.0, 40.0]', '[20.0, 60.0]'), false);
    });
  });

  group('strictlyRightOf() unbounded tests', () {
    late final bool Function(String range1, String range2) strictlyRightOf;

    setUpAll(() {
      strictlyRightOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.strictlyRightOf(r2);
      };
    });
    test('should return false if both are [,] ranges', () {
      expect(strictlyRightOf('[,]', '[,]'), false);
    });

    test('should return false if a [,] range is checked against a [b,] range',
        () {
      expect(strictlyRightOf('[,]', '[10.0,]'), false);
    });

    test('should return false if a [,] range is checked against a [,b] range',
        () {
      expect(strictlyRightOf('[,]', '[,20.0]'), false);
    });

    test('should return false if a [,] range is checked against a [b,b] range',
        () {
      expect(strictlyRightOf('[,]', '[10.0,20.0]'), false);
    });

    test('should return false if a [b,] range is checked against a [,] range',
        () {
      expect(strictlyRightOf('[30.0,]', '[,]'), false);
    });

    test('should return false if a [,b] range is checked against a [,] range',
        () {
      expect(strictlyRightOf('[,40.0]', '[,]'), false);
    });

    test('should return false if a [b,b] range is checked against a [,] range',
        () {
      expect(strictlyRightOf('[30.0,40.0]', '[,]'), false);
    });

    test('should return false if a [b,] range is checked against a [b,] range',
        () {
      expect(strictlyRightOf('[30.0,]', '[10.0,]'), false);
    });

    test(
        'should return true if the lower bound of a [b,] range is greater than the upper bound of a [,b] range',
        () {
      expect(strictlyRightOf('[30.0,]', '[,20.0]'), true);
    });

    test(
        'should return true if the lower bound of a [b,] range is greater than the upper bound of a [b,b] range',
        () {
      expect(strictlyRightOf('[30.0,]', '[10.0,20.0]'), true);
    });

    test('should return false if a [,b] range is checked against a [b,] range',
        () {
      expect(strictlyRightOf('[,40.0]', '[10.0,]'), false);
    });

    test('should return false if a [,b] range is checked against a [,b] range',
        () {
      expect(strictlyRightOf('[,40.0]', '[,20.0]'), false);
    });

    test('should return false if a [,b] range is checked against a [b,b] range',
        () {
      expect(strictlyRightOf('[,40.0]', '[10.0,20.0]'), false);
    });
  });

  group('doesNotExtendToTheLeftOf() tests', () {
    late final bool Function(String range1, String range2)
        doesNotExtendToTheLeftOf;

    setUpAll(() {
      doesNotExtendToTheLeftOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.doesNotExtendToTheLeftOf(r2);
      };
    });

    test(
        'should return true if the lower bound is greater than the other lower bound',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0, 40.0]', '[10.0, 20.0]'), true);
    });

    test(
        'should return true if the lower bound is equal to the other lower bound',
        () {
      expect(doesNotExtendToTheLeftOf('[10.0, 40.0]', '[10.0, 20.0]'), true);
    });

    test(
        'should return false if the lower bound is less than the other lower bound',
        () {
      expect(doesNotExtendToTheLeftOf('[10.0, 40.0]', '[20.0, 60.0]'), false);
    });
  });

  group('doesNotExtendToTheLeftOf() unbounded tests', () {
    late final bool Function(String range1, String range2)
        doesNotExtendToTheLeftOf;

    setUpAll(() {
      doesNotExtendToTheLeftOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.doesNotExtendToTheLeftOf(r2);
      };
    });
    test('should return true if both are [,] ranges', () {
      expect(doesNotExtendToTheLeftOf('[,]', '[,]'), true);
    });

    test('should return false if a [,] range is checked against a [b,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,]', '[10.0,]'), false);
    });

    test('should return true if a [,] range is checked against a [,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,]', '[,20.0]'), true);
    });

    test('should return false if a [,] range is checked against a [b,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,]', '[10.0,20.0]'), false);
    });

    test('should return true if a [b,] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[,]'), true);
    });

    test('should return true if a [,b] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,40.0]', '[,]'), true);
    });

    test('should return true if a [b,b] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,40.0]', '[,]'), true);
    });

    test(
        'should return true if the lower bound of a [b,] range is greater than the lower bound a [b,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[10.0,]'), true);
    });

    test(
        'should return true if the lower bound of a [b,] range is equal to the lower bound a [b,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[30.0,]'), true);
    });

    test(
        'should return false if the lower bound of a [b,] range is less than the lower bound a [b,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[40.0,]'), false);
    });

    test('should return true if a [b,] range is checked against a [,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[,20.0]'), true);
    });

    test(
        'should return true if the lower bound of a [b,] range is greater than the lower bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[10.0,20.0]'), true);
    });

    test(
        'should return true if the lower bound of a [b,] range is equal to the lower bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[30.0,40.0]'), true);
    });

    test(
        'should return false if the lower bound of a [b,] range is equal to the lower bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[30.0,]', '[40.0,50.0]'), false);
    });

    test('should return false if a [,b] range is checked against a [b,] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,30.0]', '[10.0,]'), false);
    });

    test('should return false if a [,b] range is checked against a [,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,30.0]', '[,20.0]'), false);
    });

    test('should return false if a [,b] range is checked against a [b,b] range',
        () {
      expect(doesNotExtendToTheLeftOf('[,30.0]', '[10.0,20.0]'), false);
    });
  });

  group('doesNotExtendToTheRightOf() tests', () {
    late final bool Function(String range1, String range2)
        doesNotExtendToTheRightOf;

    setUpAll(() {
      doesNotExtendToTheRightOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.doesNotExtendToTheRightOf(r2);
      };
    });

    test(
        'should return true if the upper bound is less than the other upper bound',
        () {
      expect(doesNotExtendToTheRightOf('[10.0, 20.0]', '[30.0, 40.0]'), true);
    });

    test(
        'should return true if the upper bound is equal to the other upper bound',
        () {
      expect(doesNotExtendToTheRightOf('[10.0, 40.0]', '[30.0, 40.0]'), true);
    });

    test(
        'should return false if the upper bound is greater than the other upper bound',
        () {
      expect(doesNotExtendToTheRightOf('[10.0, 40.0]', '[30.0, 35.0]'), false);
    });
  });

  group('doesNotExtendToTheRightOf() unbounded tests', () {
    late final bool Function(String range1, String range2)
        doesNotExtendToTheRightOf;

    setUpAll(() {
      doesNotExtendToTheRightOf = (String range1, String range2) {
        final r1 = RangeType.createRange(
          range: range1,
          forceType: RangeDataType.float,
        );
        final r2 = RangeType.createRange(
          range: range2,
          forceType: RangeDataType.float,
        );
        return r1.doesNotExtendToTheRightOf(r2);
      };
    });
    test('should return true if both are [,] ranges', () {
      expect(doesNotExtendToTheRightOf('[,]', '[,]'), true);
    });

    test('should return true if a [,] range is checked against a [b,] range',
        () {
      expect(doesNotExtendToTheRightOf('[,]', '[30.0,]'), true);
    });

    test('should return false if a [,] range is checked against a [,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,]', '[,40.0]'), false);
    });

    test('should return false if a [,] range is checked against a [b,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,]', '[30.0,40.0]'), false);
    });

    test('should return true if a [b,] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheRightOf('[10.0,]', '[,]'), true);
    });

    test('should return true if a [,b] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[,]'), true);
    });

    test('should return true if a [b,b] range is checked against a [,] range',
        () {
      expect(doesNotExtendToTheRightOf('[10.0,20.0]', '[,]'), true);
    });

    test('should return true if a [b,] range is compared against a [b,] range',
        () {
      expect(doesNotExtendToTheRightOf('[10.0,]', '[30.0,]'), true);
    });

    test('should return false if a [b,] range is checked against a [,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[10.0,]', '[,40.0]'), false);
    });

    test(
        'should return false if a [b,] range is compared against a [b,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[10.0,]', '[30.0,40.0]'), false);
    });

    test('should return true if a [,b] range is checked against a [b,] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[30.0,]'), true);
    });

    test(
        'should return true if the upper bound of a [,b] range is less than the upper bound of a [,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[,40.0]'), true);
    });

    test(
        'should return true if the upper bound of a [,b] range is equal to the upper bound of a [,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[,20.0]'), true);
    });

    test(
        'should return false if the upper bound of a [,b] range is greater than the upper bound of a [,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[,10.0]'), false);
    });

    test(
        'should return true if the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[5.0,40.0]'), true);
    });

    test(
        'should return true if the upper bound of a [,b] range is equal to the upper bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[5.0,20.0]'), true);
    });

    test(
        'should return false if the upper bound of a [,b] range is less than the upper bound of a [b,b] range',
        () {
      expect(doesNotExtendToTheRightOf('[,20.0]', '[5.0,10.0]'), false);
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
    late final bool Function(String range1, String range2) eq;
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

      test('should return false if the lower bound is less than the other', () {
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
      test('should return true if the lower bound is less than the other', () {
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
      test('should return true if the lower bound is less than the other', () {
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

    group('range equality', () {
      late final bool Function(String range1, String range2) forceEq;
      late final bool Function(String range1, String range2) dynamicEq;

      setUpAll(() {
        forceEq = (range1, range2) {
          final r1 = RangeType.createRange(
            range: range1,
            forceType: RangeDataType.float,
          );
          final r2 = RangeType.createRange(
            range: range2,
            forceType: RangeDataType.float,
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
        expect(eq('[1.5, 10.5]', '[1.5, 10.5]'), true);
        expect(eq('(1.5, 10.5]', '(1.5, 10.5]'), true);
        expect(eq('[1.5, 10.5)', '[1.5, 10.5)'), true);
        expect(eq('(1.5, 10.5)', '(1.5, 10.5)'), true);
      });

      test('should return false if ranges have different values', () {
        expect(eq('[1.5, 10.5]', '[5.5, 20.5]'), false);
        expect(eq('(1.5, 10.5]', '(5.5, 20.5]'), false);
        expect(eq('[1.5, 10.5)', '[5.5, 20.5)'), false);
        expect(eq('(1.5, 10.5)', '(5.5, 20.5)'), false);
      });

      test(
          'should return false if ranges have the same lower bound but a different upper bound',
          () {
        expect(eq('[1.5, 10.5]', '[1.5, 20.5]'), false);
        expect(eq('(1.5, 10.5]', '(1.5, 20.5]'), false);
        expect(eq('[1.5, 10.5)', '[1.5, 20.5)'), false);
        expect(eq('(1.5, 10.5)', '(1.5, 20.5)'), false);
      });

      test(
          'should return false if ranges have the same upper bound but a different lower bound',
          () {
        expect(eq('[1.5, 20.5]', '[5.5, 20.5]'), false);
        expect(eq('(1.5, 20.5]', '(5.5, 20.5]'), false);
        expect(eq('[1.5, 20.5)', '[5.5, 20.5)'), false);
        expect(eq('(1.5, 20.5)', '(5.5, 20.5)'), false);
      });

      test(
          'should return false if ranges cover the same values but are not the same',
          () {
        expect(eq('(1.0, 10.0)', '[1.1, 9.9]'), false);
      });

      test('should return true if ranges have the same infinity values', () {
        expect(forceEq('[-infinity, 20.5]', '[-infinity, 20.5]'), true);
        expect(forceEq('[10.5, infinity]', '[10.5, infinity]'), true);
        expect(
          forceEq('[-infinity, infinity]', '[-infinity, infinity]'),
          true,
        );
      });

      test('should return false if ranges have different infinity values', () {
        expect(forceEq('[-infinity, 20.5]', '[10.5, infinity]'), false);
        expect(forceEq('[-infinity, 20.5]', '[-infinity, infinity]'), false);

        expect(forceEq('[10.5, infinity]', '[-infinity, 20.5]'), false);
        expect(forceEq('[10.5, infinity]', '[-infinity, infinity]'), false);

        expect(forceEq('[-infinity, infinity]', '[10.5, infinity]'), false);
        expect(forceEq('[-infinity, infinity]', '[-infinity, 20.5]'), false);
      });

      test('should return false if ranges have a different inclusivity', () {
        expect(eq('[1.5, 10.5]', '(1.5, 10.5]'), false);
        expect(eq('[1.5, 10.5]', '[1.5, 10.5)'), false);
        expect(eq('[1.5, 10.5]', '(1.5, 10.5)'), false);

        expect(eq('(1.5, 10.5]', '[1.5, 10.5]'), false);
        expect(eq('(1.5, 10.5]', '[1.5, 10.5)'), false);
        expect(eq('(1.5, 10.5]', '(1.5, 10.5)'), false);

        expect(eq('[1.5, 10.5)', '[1.5, 10.5]'), false);
        expect(eq('[1.5, 10.5)', '(1.5, 10.5]'), false);
        expect(eq('[1.5, 10.5)', '(1.5, 10.5)'), false);

        expect(eq('(1.5, 10.5)', '[1.5, 10.5]'), false);
        expect(eq('(1.5, 10.5)', '[1.5, 10.5)'), false);
        expect(eq('(1.5, 10.5)', '(1.5, 10.5]'), false);
      });

      test('should return false if ranges are of different types', () {
        // Float != Integer
        expect(dynamicEq('[1.5, 10.5]', '[1, 10]'), false);

        // Float != Date
        expect(dynamicEq('[1.5, 10.5]', '[2022-01-01, 2022-12-31]'), false);

        // Float != Timestamp
        expect(
          dynamicEq(
            '[1.5, 10.5]',
            '[2022-01-01T00:00:00, 2022-12-31T00:00:00]',
          ),
          false,
        );

        // Float != UTC Timestamptz
        expect(
          dynamicEq(
            '[1.5, 10.5]',
            '[2022-01-01T00:00:00Z, 2022-12-31T00:00:00Z]',
          ),
          false,
        );

        // Float != Timestamptz
        expect(
          dynamicEq(
            '[1.5, 10.5]',
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
        expect(forceEq('[1.5, 20.5]', ''), false);
        expect(forceEq('(1.5, 20.5]', ''), false);
        expect(forceEq('[1.5, 20.5)', ''), false);
        expect(forceEq('(1.5, 20.5)', ''), false);
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
    late final bool Function(String range1, String range2) eq;
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

    group('range equality', () {
      test('should return true if the ranges have the same values', () {
        expect(eq('[1.5,]', '[1.5,]'), true);
        expect(eq('(1.5,]', '(1.5,]'), true);
        expect(eq('[1.5,)', '[1.5,)'), true);
        expect(eq('(1.5,)', '(1.5,)'), true);

        expect(eq('[,10.5]', '[,10.5]'), true);
        expect(eq('(,10.5]', '(,10.5]'), true);
        expect(eq('[,10.5)', '[,10.5)'), true);
        expect(eq('(,10.5)', '(,10.5)'), true);

        expect(eq('[,]', '[,]'), true);
        expect(eq('(,]', '(,]'), true);
        expect(eq('[,)', '[,)'), true);
        expect(eq('(,)', '(,)'), true);

        expect(eq('[1.5,]', '[1.5,)'), true);
        expect(eq('[,10.5]', '(,10.5]'), true);

        expect(eq('[,]', '(,)'), true);
        expect(eq('[,]', '(,]'), true);
        expect(eq('[,]', '[,)'), true);
      });

      test('should return false if the ranges have different values', () {
        expect(eq('[1.5,]', '[10.5,]'), false);
        expect(eq('[1.5,]', '[,10.5]'), false);
        expect(eq('[1.5,]', '[,]'), false);

        expect(eq('[,10.5]', '[1.5,]'), false);
        expect(eq('[,10.5]', '[,1.5]'), false);
        expect(eq('[,10.5]', '[,]'), false);

        expect(eq('[,]', '[1.5,]'), false);
        expect(eq('[,]', '[,10.5]'), false);
      });

      test(
          'should return false if values are equal but the inclusivity is different',
          () {
        expect(eq('[1.5,]', '(1.5,]'), false);
        expect(eq('[1.5,]', '(1.5,)'), false);

        expect(eq('[,10.5]', '[,10.5)'), false);
        expect(eq('[,10.5]', '(,10.5)'), false);
      });

      test(
          'should return false if ranges cover the same values but are not the same',
          () {
        expect(eq('(1.0,)', '[1.1,]'), false);

        expect(eq('(,10.0)', '[,9.9]'), false);
      });

      test('should return true if ranges have the same infinity values', () {
        expect(eq('[-infinity,]', '[-infinity,]'), true);
        expect(eq('[,infinity]', '[,infinity]'), true);
      });

      test('should return false if ranges have different infinity values', () {
        expect(eq('[1.5,]', '[-infinity,]'), false);
        expect(eq('[1.5,]', '[,infinity]'), false);

        expect(eq('[,10.5]', '[-infinity,]'), false);
        expect(eq('[,10.5]', '[,infinity]'), false);
      });

      test(
          'should return false if any range is compared against an empty range',
          () {
        expect(eq('[1.5,]', ''), false);
        expect(eq('[,10.5]', ''), false);
        expect(eq('[,]', ''), false);
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

  group('empty range tests', () {
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

  group('infinite range tests', () {
    late final FloatRangeType Function(String range) createRange;

    setUpAll(() {
      createRange = (String rangeString) {
        return RangeType.createRange(
          range: rangeString,
        ) as FloatRangeType;
      };
    });

    test('should be able to create a [b,i] range', () {
      expect(() => createRange('[10.5, infinity]'), returnsNormally);
    });

    test('should ensure that a [b,i] range is of float type', () {
      final range = createRange('[10.5, infinity]');
      expect(range.rangeDataType, RangeDataType.float);
    });

    test('should be able to create a [i,b] range', () {
      expect(() => createRange('[-infinity, 20.5]'), returnsNormally);
    });

    test('should ensure that a [i,b] range is of float type', () {
      final range = createRange('[-infinity, 20.5]');
      expect(range.rangeDataType, RangeDataType.float);
    });

    test('should be able to create a [i,i] range', () {
      expect(
        () => RangeType.createRange(
          range: '[-infinity, infinity]',
          forceType: RangeDataType.float,
        ),
        returnsNormally,
      );
    });
  });
}
