import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/range_comparable.dart';
import 'package:supabase_flutter/src/testing/range_type.dart';

void main() {
  group('bound class tests', () {
    test(
        'should return false when checking the equality of a bound against a bound of other type',
        () {
      const intBound = Bound<int>(10);
      const doubleBound = Bound<double>(10.0);
      final dateTimeBound = Bound<DateTime>(DateTime(2022, 1, 1));

      expect(intBound == doubleBound, false);
      // ignore: unrelated_type_equality_checks
      expect(intBound == dateTimeBound, false);
    });

    group('int bounds', () {
      late final bool Function(int? bound1, int? bound2) eq;
      late final bool Function(int? bound1, int? bound2) gt;
      late final bool Function(int? bound1, int? bound2) gte;
      late final bool Function(int? bound1, int? bound2) lt;
      late final bool Function(int? bound1, int? bound2) lte;

      late final Bound<int> Function(int? bound, int addition) ad;
      late final Bound<int> Function(int? bound, int subtraction) sub;

      setUpAll(() {
        eq = (bound1, bound2) => Bound<int>(bound1) == Bound<int>(bound2);
        gt = (bound1, bound2) => Bound<int>(bound1) > Bound<int>(bound2);
        gte = (bound1, bound2) => Bound<int>(bound1) >= Bound<int>(bound2);
        lt = (bound1, bound2) => Bound<int>(bound1) < Bound<int>(bound2);
        lte = (bound1, bound2) => Bound<int>(bound1) <= Bound<int>(bound2);
        ad = (bound, addition) => Bound<int>(bound) + addition;
        sub = (bound, subtraction) => Bound<int>(bound) - subtraction;
      });

      group('greater than', () {
        test('should return false if bounds are equal', () {
          expect(gt(10, 10), false);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gt(null, 10), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gt(10, null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gt(20, 10), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gt(10, 20), false);
        });
      });

      group('greater than or equal to', () {
        test('should return true if bounds are equal', () {
          expect(gte(10, 10), true);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gte(null, 10), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gte(10, null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gte(20, 10), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gte(10, 20), false);
        });
      });

      group('less than', () {
        test('should return false if bounds are equal', () {
          expect(lt(10, 10), false);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lt(null, 10), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lt(10, null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lt(10, 20), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lt(20, 10), false);
        });
      });

      group('less than or equal to', () {
        test('should return false if bounds are equal', () {
          expect(lte(10, 10), true);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lte(null, 10), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lte(10, null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lte(10, 20), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lte(20, 10), false);
        });
      });

      group('bound equality', () {
        test('should return true if both bounds are unbounded', () {
          expect(eq(null, null), true);
        });

        test('should return false if one of the bounds is unbounded', () {
          expect(eq(10, null), false);
          expect(eq(null, 20), false);
        });

        test('should return true if bounds are equal', () {
          expect(eq(10, 10), true);
        });

        test('should return false if bounds are different', () {
          expect(eq(10, 20), false);
        });
      });

      group('bound addition', () {
        test('should return the same bound if it is unbounded', () {
          expect(ad(null, 10) == const Bound<int>(null), true);
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(ad(20, 10) == const Bound<int>(30), true);
        });
      });

      group('bound subtraction', () {
        test('should return the same bound if it is unbounded', () {
          expect(sub(null, 10) == const Bound<int>(null), true);
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(sub(20, 10) == const Bound<int>(10), true);
        });
      });
    });

    group('double bounds', () {
      late final bool Function(double? bound1, double? bound2) eq;
      late final bool Function(double? bound1, double? bound2) gt;
      late final bool Function(double? bound1, double? bound2) gte;
      late final bool Function(double? bound1, double? bound2) lt;
      late final bool Function(double? bound1, double? bound2) lte;

      late final Bound<double> Function(double? bound, double addition) ad;
      late final Bound<double> Function(double? bound, double subtraction) sub;

      setUpAll(() {
        eq = (bound1, bound2) => Bound<double>(bound1) == Bound<double>(bound2);
        gt = (bound1, bound2) => Bound<double>(bound1) > Bound<double>(bound2);
        gte =
            (bound1, bound2) => Bound<double>(bound1) >= Bound<double>(bound2);
        lt = (bound1, bound2) => Bound<double>(bound1) < Bound<double>(bound2);
        lte =
            (bound1, bound2) => Bound<double>(bound1) <= Bound<double>(bound2);
        ad = (bound, addition) => Bound<double>(bound) + addition;
        sub = (bound, subtraction) => Bound<double>(bound) - subtraction;
      });

      group('greater than', () {
        test('should return false if bounds are equal', () {
          expect(gt(10.0, 10.0), false);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gt(null, 10.0), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gt(10.0, null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gt(20.0, 10.0), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gt(10.0, 20.0), false);
        });
      });

      group('greater than or equal to', () {
        test('should return true if bounds are equal', () {
          expect(gte(10.0, 10.0), true);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gte(null, 10.0), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gte(10.0, null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gte(20.0, 10.0), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gte(10.0, 20.0), false);
        });
      });

      group('less than', () {
        test('should return false if bounds are equal', () {
          expect(lt(10.0, 10.0), false);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lt(null, 10.0), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lt(10.0, null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lt(10.0, 20.0), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lt(20.0, 10.0), false);
        });
      });

      group('less than or equal to', () {
        test('should return false if bounds are equal', () {
          expect(lte(10.0, 10.0), true);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lte(null, 10.0), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lte(10.0, null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lte(10.0, 20.0), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lte(20.0, 10.0), false);
        });
      });

      group('bound equality', () {
        test('should return true if both bounds are unbounded', () {
          expect(eq(null, null), true);
        });

        test('should return false if one of the bounds is unbounded', () {
          expect(eq(10.0, null), false);
          expect(eq(null, 20.0), false);
        });

        test('should return true if bounds are equal', () {
          expect(eq(10.0, 10.0), true);
        });

        test('should return false if bounds are different', () {
          expect(eq(10.0, 20.0), false);
        });
      });

      group('bound addition', () {
        test('should return the same bound if it is unbounded', () {
          expect(ad(null, 1.5) == const Bound<double>(null), true);
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(ad(20.0, 0.5) == const Bound<double>(20.5), true);
        });
      });

      group('bound subtraction', () {
        test('should return the same bound if it is unbounded', () {
          expect(sub(null, 1.5) == const Bound<double>(null), true);
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(sub(20.0, 0.5) == const Bound<double>(19.5), true);
        });
      });
    });

    group('datetime bounds', () {
      late final bool Function(DateTime? bound1, DateTime? bound2) eq;
      late final bool Function(DateTime? bound1, DateTime? bound2) gt;
      late final bool Function(DateTime? bound1, DateTime? bound2) gte;
      late final bool Function(DateTime? bound1, DateTime? bound2) lt;
      late final bool Function(DateTime? bound1, DateTime? bound2) lte;

      late final Bound<DateTime> Function(DateTime? bound, int addition) ad;
      late final Bound<DateTime> Function(DateTime? bound, int subtraction) sub;

      late final int msInDay;

      setUpAll(() {
        eq = (bound1, bound2) =>
            Bound<DateTime>(bound1) == Bound<DateTime>(bound2);
        gt = (bound1, bound2) =>
            Bound<DateTime>(bound1) > Bound<DateTime>(bound2);
        gte = (bound1, bound2) =>
            Bound<DateTime>(bound1) >= Bound<DateTime>(bound2);
        lt = (bound1, bound2) =>
            Bound<DateTime>(bound1) < Bound<DateTime>(bound2);
        lte = (bound1, bound2) =>
            Bound<DateTime>(bound1) <= Bound<DateTime>(bound2);
        ad = (bound, addition) => Bound<DateTime>(bound) + addition;
        sub = (bound, subtraction) => Bound<DateTime>(bound) - subtraction;

        msInDay = Duration.millisecondsPerDay;
      });

      group('greater than', () {
        test('should return false if bounds are equal', () {
          expect(gt(DateTime(2022, 1, 1), DateTime(2022, 1, 1)), false);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gt(null, DateTime(2022, 1, 1)), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gt(DateTime(2022, 1, 1), null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gt(DateTime(2022, 12, 31), DateTime(2022, 1, 1)), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gt(DateTime(2022, 1, 1), DateTime(2022, 12, 31)), false);
        });
      });

      group('greater than or equal to', () {
        test('should return true if bounds are equal', () {
          expect(gte(DateTime(2022, 1, 1), DateTime(2022, 1, 1)), true);
        });

        test(
            'should return false if an unbounded is compared against a bounded',
            () {
          expect(gte(null, DateTime(2022, 1, 1)), false);
        });

        test('should return true if a bounded is compared against an unbounded',
            () {
          expect(gte(DateTime(2022, 1, 1), null), true);
        });

        test('should return true if a bound is greater than the other', () {
          expect(gte(DateTime(2022, 12, 31), DateTime(2022, 1, 1)), true);
        });

        test('should return false if a bound is less than the other', () {
          expect(gte(DateTime(2022, 1, 1), DateTime(2022, 12, 31)), false);
        });
      });

      group('less than', () {
        test('should return false if bounds are equal', () {
          expect(lt(DateTime(2022, 1, 1), DateTime(2022, 1, 1)), false);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lt(null, DateTime(2022, 1, 1)), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lt(DateTime(2022, 1, 1), null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lt(DateTime(2022, 1, 1), DateTime(2022, 12, 31)), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lt(DateTime(2022, 12, 31), DateTime(2022, 1, 1)), false);
        });
      });

      group('less than or equal to', () {
        test('should return false if bounds are equal', () {
          expect(lte(DateTime(2022, 1, 1), DateTime(2022, 1, 1)), true);
        });

        test('should return true if an unbounded is compared against a bounded',
            () {
          expect(lte(null, DateTime(2022, 1, 1)), true);
        });

        test(
            'should return false if a bounded is compared against an unbounded',
            () {
          expect(lte(DateTime(2022, 1, 1), null), false);
        });

        test('should return true if a bound is less than the other', () {
          expect(lte(DateTime(2022, 1, 1), DateTime(2022, 12, 31)), true);
        });

        test('should return false if a bound is greater than the other', () {
          expect(lte(DateTime(2022, 12, 31), DateTime(2022, 1, 1)), false);
        });
      });

      group('bound equality', () {
        test('should return true if both bounds are unbounded', () {
          expect(eq(null, null), true);
        });

        test('should return false if one of the bounds is unbounded', () {
          expect(eq(DateTime(2022, 1, 1), null), false);
          expect(eq(null, DateTime(2022, 12, 31)), false);
        });

        test('should return true if bounds are equal', () {
          expect(eq(DateTime(2022, 1, 1), DateTime(2022, 1, 1)), true);
        });

        test('should return false if bounds are different', () {
          expect(eq(DateTime(2022, 1, 1), DateTime(2022, 12, 31)), false);
        });
      });

      group('bound addition', () {
        test('should return the same bound if it is unbounded', () {
          expect(
            ad(null, msInDay * 10) == const Bound<DateTime>(null),
            true,
          );
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(
            ad(DateTime(2022, 01, 01), msInDay * 20) ==
                Bound<DateTime>(DateTime(2022, 01, 21)),
            true,
          );
        });
      });

      group('bound subtraction', () {
        test('should return the same bound if it is unbounded', () {
          expect(
            sub(null, msInDay * 10) == const Bound<DateTime>(null),
            true,
          );
        });

        test('should return a new bound with the added amount if it is bounded',
            () {
          expect(
            sub(DateTime(2022, 12, 31), msInDay * 20) ==
                Bound<DateTime>(DateTime(2022, 12, 11)),
            true,
          );
        });
      });
    });
  });

  group('range comparable tests', () {
    test(
        'should throw an Exception when passing an unsupported value in isInRange()',
        () {
      final comparable = RangeComparable<int>(
        lowerRange: 10,
        upperRange: 20,
        rangeType: RangeDataType.integer,
      );

      expect(() => comparable.isInRange("invalid"), throwsException);
    });

    test(
        'should throw an Exception for checking if a comparable is greater than the other of different type',
        () {
      final comparable1 = RangeComparable<num>(
        lowerRange: 10,
        upperRange: 20,
        rangeType: RangeDataType.integer,
      );

      final comparable2 = RangeComparable<num>(
        lowerRange: 10.0,
        upperRange: 20.0,
        rangeType: RangeDataType.float,
      );

      expect(() => comparable1 > comparable2, throwsException);
    });

    test(
        'should throw an Exception for checking if a comparable is less than the other of different type',
        () {
      final comparable1 = RangeComparable<num>(
        lowerRange: 10,
        upperRange: 20,
        rangeType: RangeDataType.integer,
      );

      final comparable2 = RangeComparable<num>(
        lowerRange: 10.0,
        upperRange: 20.0,
        rangeType: RangeDataType.float,
      );

      expect(() => comparable1 < comparable2, throwsException);
    });
  });
}
