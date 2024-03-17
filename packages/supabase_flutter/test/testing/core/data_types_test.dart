// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types.dart';

void main() {
  late final int Function(String binaryString) binary;

  setUpAll(() {
    binary = (binaryString) => int.parse(binaryString, radix: 2);
  });

  group('big integer tests', () {
    group('constants', () {
      test('should return the max positive value', () {
        expect(BigInteger.maxValue, 9223372036854775806);
      });

      test('should return the min positive value', () {
        expect(BigInteger.minValue, -9223372036854775807);
      });
    });

    group('constructor and clamping', () {
      test('should not clamp if the value is in range', () {
        expect(BigInteger(365).value, 365);
      });

      test('should clamp if the value overflows', () {
        expect(BigInteger(9223372036854775807).value, BigInteger.maxValue);
      });

      test('should clamp if the value underflows', () {
        expect(BigInteger(-9223372036854775808).value, BigInteger.minValue);
      });
    });

    group('equality', () {
      test('should return true if the value is equal to the other (BigInteger)',
          () {
        expect(BigInteger(20) == BigInteger(20), true);
      });

      test('should return true if the value is equal to the other (int)', () {
        expect(BigInteger(20) == 20, true);
      });

      test(
          'should return false if the value is not equal to the other (BigInteger)',
          () {
        expect(BigInteger(20) == BigInteger(30), false);
      });

      test('should return false if the value is not equal to the other (int)',
          () {
        expect(BigInteger(20) == 30, false);
      });
    });

    group('compareTo() method', () {
      test('should be able to compare to a BigInteger', () {
        expect(BigInteger(20).compareTo(BigInteger(30)), -1);
      });

      test('should be able to compare to an int', () {
        expect(BigInteger(20).compareTo(30), -1);
      });

      test('should return 1 if value is greater than the other', () {
        expect(BigInteger(20).compareTo(10), 1);
      });

      test('should return 0 if value is equal to the other', () {
        expect(BigInteger(20).compareTo(20), 0);
      });

      test('should return -1 if value is less than the other', () {
        expect(BigInteger(20).compareTo(30), -1);
      });
    });

    group('unary minus', () {
      test('should negate a positive value', () {
        final bigInt = BigInteger(20);
        expect(-bigInt, BigInteger(-20));
      });

      test('should inverse a negative value', () {
        final bigInt = BigInteger(-20);
        expect(-bigInt, BigInteger(20));
      });

      test('shoud clamp if you inverse the min value', () {
        final bigInt = BigInteger(BigInteger.minValue);
        expect(-bigInt, BigInteger(BigInteger.maxValue));
      });
    });

    group('addition operator', () {
      test('should be able to add a BigInteger', () {
        expect(BigInteger(20) + BigInteger(30), BigInteger(50));
      });

      test('should be add an int', () {
        expect(BigInteger(20) + 30, BigInteger(50));
      });

      test('should clamp if the addition overflows', () {
        expect(
          BigInteger(BigInteger.maxValue) + BigInteger(20),
          BigInteger(BigInteger.maxValue),
        );
      });

      test('should clamp if the addition underflows', () {
        expect(
          BigInteger(BigInteger.minValue) + BigInteger(-20),
          BigInteger(BigInteger.minValue),
        );
      });
    });

    group('subtraction operator', () {
      test('should be able subtract a BigInteger', () {
        expect(BigInteger(20) - BigInteger(30), BigInteger(-10));
      });

      test('should be able subtract an int', () {
        expect(BigInteger(20) - 30, BigInteger(-10));
      });

      test('should clamp if the subtraction overflows', () {
        expect(
          BigInteger(BigInteger.maxValue) - BigInteger(-20),
          BigInteger(BigInteger.maxValue),
        );
      });

      test('should clamp if the subtraction underflows', () {
        expect(
          BigInteger(BigInteger.minValue) - BigInteger(20),
          BigInteger(BigInteger.minValue),
        );
      });
    });

    group('multiplication operator', () {
      test('should be able to multiply a BigInteger', () {
        expect(BigInteger(2) * BigInteger(30), BigInteger(60));
      });

      test('should be able to multiply an int', () {
        expect(BigInteger(2) * 30, BigInteger(60));
      });

      test('should clamp if the multiplication overflows', () {
        expect(
          BigInteger(BigInteger.maxValue) * BigInteger(20),
          BigInteger(BigInteger.maxValue),
        );
      });

      test('should clamp if the multiplication underflows', () {
        expect(
          BigInteger(BigInteger.minValue) * BigInteger(-20),
          BigInteger(BigInteger.minValue),
        );
      });

      test('should return 0 if either a or b are 0', () {
        expect(
          BigInteger(0) * BigInteger(20),
          BigInteger(0),
        );
      });
    });

    group('integer division operator', () {
      test('should be able to divide a BigInteger', () {
        expect(BigInteger(5) ~/ BigInteger(2), BigInteger(2));
      });

      test('should be able to divide an int', () {
        expect(BigInteger(5) ~/ 2, BigInteger(2));
      });

      test('should throw an ArgumentError when dividing by 0', () {
        expect(() => BigInteger(5) ~/ BigInteger(0), throwsArgumentError);
      });
    });

    group('modulo operator', () {
      test('should be able to perform mod on a BigInteger', () {
        expect(BigInteger(5) % BigInteger(2), BigInteger(1));
      });

      test('should be able to perform mod on a int', () {
        expect(BigInteger(5) % 2, BigInteger(1));
      });

      test('should throw an ArgumentError when performing mod by 0', () {
        expect(() => BigInteger(5) % BigInteger(0), throwsArgumentError);
      });
    });

    group('less than operator', () {
      test(
          'should return true if BigInteger is less than the other (BigInteger)',
          () {
        expect(BigInteger(5) < BigInteger(8), true);
      });

      test('should return true if BigInteger is less than the other (int)', () {
        expect(BigInteger(5) < 8, true);
      });

      test(
          'should return false if BigInteger is greater than the other (BigInteger)',
          () {
        expect(BigInteger(5) < BigInteger(3), false);
      });

      test('should return false if BigInteger is greater than the other (int)',
          () {
        expect(BigInteger(5) < 3, false);
      });

      test('should return false if BigInteger is equal the other (BigInteger)',
          () {
        expect(BigInteger(5) < BigInteger(5), false);
      });

      test('should return false if BigInteger is equal the other (int)', () {
        expect(BigInteger(5) < 5, false);
      });

      test('should throw an ArgumentError when comparing to a non-integer type',
          () {
        expect(() => BigInteger(5) < 'sample', throwsArgumentError);
      });
    });

    group('greater than operator', () {
      test(
          'should return true if BigInteger is greater than the other (BigInteger)',
          () {
        expect(BigInteger(5) > BigInteger(3), true);
      });

      test('should return true if BigInteger is greater than the other (int)',
          () {
        expect(BigInteger(5) > 3, true);
      });

      test(
          'should return false if BigInteger is less than the other (BigInteger)',
          () {
        expect(BigInteger(5) > BigInteger(8), false);
      });

      test('should return false if BigInteger is less than the other (int)',
          () {
        expect(BigInteger(5) > 8, false);
      });

      test('should return false if BigInteger is equal the other (BigInteger)',
          () {
        expect(BigInteger(5) > BigInteger(5), false);
      });

      test('should return false if BigInteger is equal the other (int)', () {
        expect(BigInteger(5) > 5, false);
      });

      test(
          'should throw an ArgumentError when comparing BigInteger to a non-integer type',
          () {
        expect(() => BigInteger(5) > 'sample', throwsArgumentError);
      });
    });

    group('less than or equal to operator', () {
      test(
          'should return true if BigInteger is less than the other (BigInteger)',
          () {
        expect(BigInteger(5) <= BigInteger(8), true);
      });

      test('should return true if BigInteger is less than the other (int)', () {
        expect(BigInteger(5) <= 8, true);
      });

      test(
          'should return false if BigInteger is greater than the other (BigInteger)',
          () {
        expect(BigInteger(5) <= BigInteger(3), false);
      });
      test('should return false if BigInteger is greater than the other (int)',
          () {
        expect(BigInteger(5) <= 3, false);
      });

      test('should return true if BigInteger is equal the other (BigInteger)',
          () {
        expect(BigInteger(5) <= BigInteger(5), true);
      });

      test('should return true if BigInteger is equal the other (int)', () {
        expect(BigInteger(5) <= 5, true);
      });

      test(
          'should throw an ArgumentError when comparing BigInteger to a non-integer type',
          () {
        expect(() => BigInteger(5) <= 'sample', throwsArgumentError);
      });
    });

    group('greater than or equal to operator', () {
      test(
          'should return true if BigInteger is greater than the other (BigInteger)',
          () {
        expect(BigInteger(5) >= BigInteger(3), true);
      });

      test('should return true if BigInteger is greater than the other (int)',
          () {
        expect(BigInteger(5) >= 3, true);
      });

      test(
          'should return false if BigInteger is less than the other (BigInteger)',
          () {
        expect(BigInteger(5) >= BigInteger(8), false);
      });

      test('should return false if BigInteger is less than the other (int)',
          () {
        expect(BigInteger(5) >= 8, false);
      });

      test('should return true if BigInteger is equal the other (BigInteger)',
          () {
        expect(BigInteger(5) >= BigInteger(5), true);
      });

      test('should return true if BigInteger is equal the other (int)', () {
        expect(BigInteger(5) >= 5, true);
      });

      test(
          'should throw an ArgumentError when comparing BigInteger to a non-integer type',
          () {
        expect(() => BigInteger(5) >= 'sample', throwsArgumentError);
      });
    });

    group('bitwise AND operator', () {
      test('should perform a bitwise AND (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) & BigInteger(binary('101110')),
          BigInteger(binary('100100')),
        );
      });

      test('should perform a bitwise AND (int)', () {
        expect(
          BigInteger(binary('100101')) & binary('101110'),
          BigInteger(binary('100100')),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise AND with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) & 'sample',
          throwsArgumentError,
        );
      });
    });

    group('bitwise OR operator', () {
      test('should perform a bitwise OR (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) | BigInteger(binary('101110')),
          BigInteger(binary('101111')),
        );
      });

      test('should perform a bitwise OR (int)', () {
        expect(
          BigInteger(binary('100101')) | binary('101110'),
          BigInteger(binary('101111')),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise OR with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) | 'sample',
          throwsArgumentError,
        );
      });
    });

    group('bitwise XOR operator', () {
      test('should perform a bitwise XOR (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) ^ BigInteger(binary('101110')),
          BigInteger(binary('001011')),
        );
      });

      test('should perform a bitwise XOR (int)', () {
        expect(
          BigInteger(binary('100101')) ^ binary('101110'),
          BigInteger(binary('001011')),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise XOR with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) ^ 'sample',
          throwsArgumentError,
        );
      });
    });

    group('left shift operator', () {
      test('should perform a left shift (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) << BigInteger(2),
          BigInteger(binary('10010100')),
        );
      });

      test('should perform a left shift (int)', () {
        expect(
          BigInteger(binary('100101')) << 2,
          BigInteger(binary('10010100')),
        );
      });

      test('should clamp if left shift overflows', () {
        expect(
          BigInteger(BigInteger.maxValue) << 1,
          BigInteger(BigInteger.maxValue),
        );
      });

      test('should clamp if left shift underflows', () {
        expect(
          BigInteger(BigInteger.minValue) << 1,
          BigInteger(BigInteger.minValue),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise XOR with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) << 'sample',
          throwsArgumentError,
        );
      });
    });

    group('right shift operator', () {
      test('should perform a right shift (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) >> BigInteger(2),
          BigInteger(binary('001001')),
        );
      });

      test('should perform a right shift (int)', () {
        expect(
          BigInteger(binary('100101')) >> 2,
          BigInteger(binary('001001')),
        );
      });

      test(
          'should return 0 if right shifiting by a value greater than the number of bits',
          () {
        expect(
          BigInteger(binary('100101')) >> 70,
          BigInteger(0),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise XOR with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) >> 'sample',
          throwsArgumentError,
        );
      });
    });

    group('unsigned right shift operator', () {
      test('should perform an unsigned right shift (BigInteger)', () {
        expect(
          BigInteger(binary('100101')) >>> BigInteger(2),
          BigInteger(binary('001001')),
        );
      });

      test('should perform an unsigned right shift (int)', () {
        expect(
          BigInteger(binary('100101')) >>> 2,
          BigInteger(binary('001001')),
        );
      });

      test(
          'should return 0 if unsigned right shifiting by a value greater than the number of bits',
          () {
        expect(
          BigInteger(binary('100101')) >>> 70,
          BigInteger(0),
        );
      });

      test(
          'should throw an ArgumentError when performing a bitwise XOR with a non-int',
          () {
        expect(
          () => BigInteger(binary('100101')) >>> 'sample',
          throwsArgumentError,
        );
      });
    });
  });

  group('numeric tests', () {
    group('precision and scale', () {
      test('should return the precision', () {
        final numeric = Numeric(precision: 5, scale: 3, value: '0');
        expect(numeric.precision, 5);
      });

      test('should return the scale', () {
        final numeric = Numeric(precision: 5, scale: 3, value: '0');
        expect(numeric.scale, 3);
      });

      test('should allow null precision', () {
        final numeric = Numeric(value: '0');
        expect(numeric.precision, null);
      });

      test('should allow null scale if precision is given', () {
        final numeric = Numeric(precision: 5, value: '0');
        expect(numeric.precision, 5);
      });

      test('should throw ArgumentError if precision is negative', () {
        expect(() => Numeric(precision: -1, value: '0'), throwsArgumentError);
      });

      test('should throw ArgumentError if scale is given but precision is null',
          () {
        expect(() => Numeric(scale: 2, value: '0'), throwsArgumentError);
      });

      test(
          'should throw an ArgumentError if precision exceeds the maximum value',
          () {
        expect(
          () => Numeric(value: '1.5', precision: 700000),
          throwsArgumentError,
        );
      });

      test('should throw an ArgumentError if scale is greater than precision',
          () {
        expect(
          () => Numeric(value: '1.5', precision: 3, scale: 4),
          throwsArgumentError,
        );
      });
    });

    group('value clamping', () {
      test(
          'should treat the value normally if precision and scale are respected',
          () {
        final numeric = Numeric(value: '22.765', precision: 5, scale: 3);
        expect(numeric.rawValueString, '22.765');
      });

      test(
          'should add leading 0s if precision is greater than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.765', precision: 8, scale: 3);
        expect(numeric.rawValueString, '00022.765');
      });

      test(
          'should cut numbers if precision is less than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.765', precision: 4, scale: 3);
        expect(numeric.rawValueString, '2.765');
      });

      test(
          'should only consider the numbers after the fractional point if scale is equal to precision',
          () {
        final numeric = Numeric(value: '22.765', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.765');
      });

      test('should remove fractional part if scale is not specified', () {
        final numeric = Numeric(value: '22.765', precision: 3);
        expect(numeric.rawValueString, '022');
      });

      test(
          'should create value up to implementation limits if neither scale nor precision are specified',
          () {
        final numeric = Numeric(value: '93821382193821982913122.7653129');
        expect(numeric.rawValueString, '93821382193821982913122.7653129');
      });

      test(
          'should add trailing 0s if scale is greater than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.7', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.700');
      });

      test(
          'should cut numbers if scale is less than the length of numbers before the fraction point',
          () {
        final numeric = Numeric(value: '22.76598190', precision: 3, scale: 3);
        expect(numeric.rawValueString, '0.765');
      });

      test(
          'should round numbers to the nearest multiple of 10 if scale is negative',
          () {
        // 1300 because 10 ** 2 = 100, therefore rounding 1322 to the closest hundred is 1300
        final numeric =
            Numeric(value: '1322.76598190', precision: 3, scale: -2);
        expect(numeric.rawValueString, '1300');
      });

      test('should round to 0 if the negative scale is too great', () {
        // 1300 because 10 ** 2 = 100, therefore rounding 1322 to the closest hundred is 1300
        final numeric =
            Numeric(value: '1322.76598190', precision: 3, scale: -10);
        expect(numeric.rawValueString, '0');
      });
    });

    group('isUnconstrained getter', () {
      test('should return true if both scale and precision are null', () {
        expect(Numeric(value: '0').isUnconstrained, true);
      });

      test('should return false if scale or precision are given', () {
        expect(Numeric(precision: 10, value: '0').isUnconstrained, false);
      });
    });
  });
}
