import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests remainder where both operands are positive.
//
// PostgreSQL and many programming languages use the remainder operation
// for remainder. Unlike the Euclidean remainder which requires non-negative
// values, the remainder operation uses the sign of the dividend.
//
// A remainder operation with a positive dividend always results in a positive
// value. For example:
//
// 10.remainder(3) = 1 -> 1 is a positive value
//
// Unlike integer division, a remainder operation may not always return a value of
// [Integer type]. This is because type casting occurs, converting the type with
// less precision to a type with more precision.
  group('positive remainder', () {
    test('should correctly perform remainder with BigInteger', () {
      final value1 = BigSerial(30);
      final value2 = BigInteger(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = BigSerial(30);
      final value2 = Integer(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = BigSerial(30);
      final value2 = SmallInteger(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with BigSerial', () {
      final value1 = BigSerial(30);
      final value2 = BigSerial(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Serial', () {
      final value1 = BigSerial(30);
      final value2 = Serial(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallSerial', () {
      final value1 = BigSerial(30);
      final value2 = SmallSerial(4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests remainder where the first operand is positive and the second is
// negative.
//
// The remainder method does not act like the Euclidean remainder, because
// the resultant value takes the sign of the dividend. Unlike the Euclidean
// remainder, which requires non-negative values.
//
// A remainder operation results in a positive value if the dividend is positive:
//
// 10.remainder(-3) = 1 -> The result is 1, a positive value
//
// Observations:
// - No tests for [Serial types], as their minimum {value} is 1, making it
//   impossible to store negative values.
  group('mixed sign remainder (positive + negative)', () {
    test('should correctly perform remainder with BigInteger', () {
      final value1 = BigSerial(30);
      final value2 = BigInteger(-4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = BigSerial(30);
      final value2 = Integer(-4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = BigSerial(30);
      final value2 = SmallInteger(-4);
      final expected = BigSerial(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if remainder of exact integer division will correctly result in
// zero.
//
// In remainder operations where the equivalent division yields a number
// without decimal places, the remainder result will be zero. For example:
//
// 30.remainder(2) = 0
//
// But due to the fact [Serial types] cannot hold non-positive values,
// everytime a remainder operation results in zero, it will throw a
// {RangeError}
  group('integer remainder (exact)', () {
    test('should be able to perform remainder with BigInteger', () {
      final value1 = BigSerial(50);
      final value2 = BigInteger(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should be able to perform remainder with Integer', () {
      final value1 = BigSerial(50);
      final value2 = Integer(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should be able to perform remainder with SmallInteger', () {
      final value1 = BigSerial(50);
      final value2 = SmallInteger(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should be able to perform remainder with BigSerial', () {
      final value1 = BigSerial(50);
      final value2 = BigSerial(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should be able to perform remainder with Serial', () {
      final value1 = BigSerial(50);
      final value2 = Serial(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should be able to perform remainder with SmallSerial', () {
      final value1 = BigSerial(50);
      final value2 = SmallSerial(2);
      expect(() => value1.remainder(value2), throwsRangeError);
    });
  });

// Tests if remainder of fractional integer division will correctly result
// in the remainder.
//
// In remainder operations where the equivalent division yields a number with
// decimal places, the remainder operation produces the remainder of that
// division. For example:
//
// 5.remainder(2) = 1
//
  group('integer remainder (fractional)', () {
    test('should correctly perform remainder with BigInteger', () {
      final value1 = BigSerial(5);
      final value2 = BigInteger(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = BigSerial(5);
      final value2 = Integer(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = BigSerial(5);
      final value2 = SmallInteger(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with BigSerial', () {
      final value1 = BigSerial(5);
      final value2 = BigSerial(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Serial', () {
      final value1 = BigSerial(5);
      final value2 = Serial(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallSerial', () {
      final value1 = BigSerial(5);
      final value2 = SmallSerial(2);
      final expected = BigSerial(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if remainder between a positive non-zero value and zero
// will throw an {ArgumentError}.
//
// In remainder operations, any number remainder zero results in an
// undefined outcome. For example:
//
// 10.remainder(0) = ? -> Undefined
//
// Programming languages address this by throwing an error when a
// remainder by zero is attempted.
//
// Observations:
// - No tests for [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero remainder by zero (positive + zero)', () {
    test(
        'should throw ArgumentError if performing remainder by BigInteger zero',
        () {
      final value1 = BigSerial(30);
      final value2 = BigInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if performing remainder by Integer zero',
        () {
      final value1 = BigSerial(30);
      final value2 = Integer(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing remainder by SmallInteger zero',
        () {
      final value1 = BigSerial(30);
      final value2 = SmallInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });
  });

// Tests if remainder between a positive non-zero value and a positive one
// will return zero.
//
// In remainder operations, any value remainder one results in zero. For
// example:
//
// 20.remainder(1) = 0
//
// But due to the fact [Serial types] cannot hold non-positive values,
// everytime a remainder operation results in zero, it will throw a
// {RangeError}
  group('remainder by one', () {
    test('should return zero when performing remainder by BigInteger one', () {
      final value1 = BigSerial(30);
      final value2 = BigInteger(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by Integer one', () {
      final value1 = BigSerial(30);
      final value2 = Integer(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by SmallInteger one',
        () {
      final value1 = BigSerial(30);
      final value2 = SmallInteger(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by BigSerial one', () {
      final value1 = BigSerial(30);
      final value2 = BigSerial(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by Serial one', () {
      final value1 = BigSerial(30);
      final value2 = Serial(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by SmallSerial one', () {
      final value1 = BigSerial(30);
      final value2 = SmallSerial(1);
      expect(() => value1.remainder(value2), throwsRangeError);
    });
  });

// Tests if remainder between a positive non-zero value and itself will
// return zero.
//
// In remainder operations, any value remainder itself results in zero.
// For example:
//
// 20.remainder(20) = 0
//
// But due to the fact [Serial types] cannot hold non-positive values,
// everytime a remainder operation results in zero, it will throw a
// {RangeError}
  group('remainder by itself (positive)', () {
    test('should return zero when performing remainder by BigInteger', () {
      final value1 = BigSerial(30);
      final value2 = BigInteger(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by Integer', () {
      final value1 = BigSerial(30);
      final value2 = Integer(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by SmallInteger', () {
      final value1 = BigSerial(30);
      final value2 = SmallInteger(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by BigSerial', () {
      final value1 = BigSerial(30);
      final value2 = BigSerial(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by Serial', () {
      final value1 = BigSerial(30);
      final value2 = Serial(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });

    test('should return zero when performing remainder by SmallSerial', () {
      final value1 = BigSerial(30);
      final value2 = SmallSerial(30);
      expect(() => value1.remainder(value2), throwsRangeError);
    });
  });
}
