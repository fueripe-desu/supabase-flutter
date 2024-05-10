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
      final value1 = SmallInteger(30);
      final value2 = BigInteger(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = SmallInteger(30);
      final value2 = Integer(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with BigSerial', () {
      final value1 = SmallInteger(30);
      final value2 = BigSerial(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Serial', () {
      final value1 = SmallInteger(30);
      final value2 = Serial(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallSerial', () {
      final value1 = SmallInteger(30);
      final value2 = SmallSerial(4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests remainder where both operands are negative.
//
// The remainder method does not act like the Euclidean remainder, because
// the resultant value takes the sign of the dividend. Unlike the Euclidean
// remainder, which requires non-negative values.
//
// A remainder operation results in a negative value if the dividend is negative:
//
// -10.remainder(-3) = -1 -> The result is -1, a negative value
//
// Observations:
// - No tests for [Serial types] as their minimum {value} is 1, making them unable
//   to store negative values.
  group('negative remainder', () {
    test('should correctly perform remainder with BigInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(-4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(-4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(-4);
      final expected = SmallInteger(-2);
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
      final value1 = SmallInteger(30);
      final value2 = BigInteger(-4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = SmallInteger(30);
      final value2 = Integer(-4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(-4);
      final expected = SmallInteger(2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests remainder where the first operand is negative and the second is
// positive.
//
// The remainder method does not act like the Euclidean remainder, because
// the resultant value takes the sign of the dividend. Unlike the Euclidean
// remainder, which requires non-negative values.
//
// A remainder operation results in a negative value if the dividend is negative:
//
// -10.remainder(3) = -1 -> The result is -1, a negative value
//
  group('mixed sign remainder (negative + positive)', () {
    test('should correctly perform remainder with BigInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with BigSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = BigSerial(4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Serial', () {
      final value1 = SmallInteger(-30);
      final value2 = Serial(4);
      final expected = SmallInteger(-2);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallSerial(4);
      final expected = SmallInteger(-2);
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
  group('integer remainder (exact)', () {
    test('should be able to perform remainder with BigInteger', () {
      final value1 = SmallInteger(50);
      final value2 = BigInteger(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform remainder with Integer', () {
      final value1 = SmallInteger(50);
      final value2 = Integer(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform remainder with SmallInteger', () {
      final value1 = SmallInteger(50);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform remainder with BigSerial', () {
      final value1 = SmallInteger(50);
      final value2 = BigSerial(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform remainder with Serial', () {
      final value1 = SmallInteger(50);
      final value2 = Serial(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform remainder with SmallSerial', () {
      final value1 = SmallInteger(50);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
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
      final value1 = SmallInteger(5);
      final value2 = BigInteger(2);
      final expected = SmallInteger(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Integer', () {
      final value1 = SmallInteger(5);
      final value2 = Integer(2);
      final expected = SmallInteger(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallInteger', () {
      final value1 = SmallInteger(5);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with BigSerial', () {
      final value1 = SmallInteger(5);
      final value2 = BigSerial(2);
      final expected = SmallInteger(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with Serial', () {
      final value1 = SmallInteger(5);
      final value2 = Serial(2);
      final expected = SmallInteger(1);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform remainder with SmallSerial', () {
      final value1 = SmallInteger(5);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(1);
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
      final value1 = SmallInteger(30);
      final value2 = BigInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if performing remainder by Integer zero',
        () {
      final value1 = SmallInteger(30);
      final value2 = Integer(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing remainder by SmallInteger zero',
        () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });
  });

// Tests if remainder between a negative non-zero value and zero
// will throw an {ArgumentError}.
//
// In remainder operations, any number remainder zero results in an
// undefined outcome. For example:
//
// -10.remainder(0) = ? -> Undefined
//
// Programming languages typically handle this by throwing an error
// when a remainder by zero is attempted.
//
// Observations:
// - Also, no tests for [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero remainder by zero (negative + zero)', () {
    test(
        'should throw ArgumentError if performing remainder by BigInteger zero',
        () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if performing remainder by Integer zero',
        () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing remainder by SmallInteger zero',
        () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });
  });

// Tests if remainder between a zero and a positive non-zero value
// will return zero.
//
// In remainder operations, zero remainder any non-zero number results
// in zero. For example:
//
// 0.remainder(20) = 0
//
// The example above does not result in an error because the first operand
// is zero. If, instead, the second operand were zero, it would lead to an
// error.
  group('zero remainder by non-zero (zero + positive)', () {
    test('should return zero if performing remainder by BigInteger', () {
      final value1 = SmallInteger(0);
      final value2 = BigInteger(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by Integer', () {
      final value1 = SmallInteger(0);
      final value2 = Integer(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by SmallInteger', () {
      final value1 = SmallInteger(0);
      final value2 = SmallInteger(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by BigSerial', () {
      final value1 = SmallInteger(0);
      final value2 = BigSerial(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by Serial', () {
      final value1 = SmallInteger(0);
      final value2 = Serial(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by SmallSerial', () {
      final value1 = SmallInteger(0);
      final value2 = SmallSerial(20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if remainder between a zero and a negative non-zero value
// will return zero.
//
// In remainder operations, zero remainder any non-zero number results in
// zero. For example:
//
// 0.remainder(-20) = 0
//
// The example above does not result in an error because the first operand
// is zero. If, however, the second operand were zero, it would lead to an \
// error.
//
// Observations:
// - No tests for [Serial types] since their minimum {value} is 1, and they
//   cannot store 0 as a value.
  group('zero remainder by non-zero (zero + negative)', () {
    test('should return zero if performing remainder by BigInteger', () {
      final value1 = SmallInteger(0);
      final value2 = BigInteger(-20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by Integer', () {
      final value1 = SmallInteger(0);
      final value2 = Integer(-20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing remainder by SmallInteger', () {
      final value1 = SmallInteger(0);
      final value2 = SmallInteger(-20);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if remainder between two zero values will throw an {ArgumentError}.
//
// In remainder operations, zero remainder zero is undefined. For example:
//
// 0.remainder(0) = ? -> Undefined
//
// Programming languages typically handle this scenario by throwing an error
// when an attempt is made to perform remainder by zero.
//
// Observations:
// - No tests for [Serial types] since their minimum {value} is 1, and thus
//   they cannot store 0 as a value.
  group('zero remainder by zero', () {
    test(
        'should throw ArgumentError if performing remainder by BigInteger zero',
        () {
      final value1 = SmallInteger(0);
      final value2 = BigInteger(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test('should throw ArgumentError if performing remainder by Integer zero',
        () {
      final value1 = SmallInteger(0);
      final value2 = Integer(0);
      expect(() => value1.remainder(value2), throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing remainder by SmallInteger zero',
        () {
      final value1 = SmallInteger(0);
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
  group('remainder by one', () {
    test('should return zero when performing remainder by BigInteger one', () {
      final value1 = SmallInteger(30);
      final value2 = BigInteger(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by Integer one', () {
      final value1 = SmallInteger(30);
      final value2 = Integer(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by SmallInteger one',
        () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by BigSerial one', () {
      final value1 = SmallInteger(30);
      final value2 = BigSerial(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by Serial one', () {
      final value1 = SmallInteger(30);
      final value2 = Serial(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by SmallSerial one', () {
      final value1 = SmallInteger(30);
      final value2 = SmallSerial(1);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
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
  group('remainder by itself (positive)', () {
    test('should return zero when performing remainder by BigInteger', () {
      final value1 = SmallInteger(30);
      final value2 = BigInteger(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by Integer', () {
      final value1 = SmallInteger(30);
      final value2 = Integer(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by SmallInteger', () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by BigSerial', () {
      final value1 = SmallInteger(30);
      final value2 = BigSerial(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by Serial', () {
      final value1 = SmallInteger(30);
      final value2 = Serial(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by SmallSerial', () {
      final value1 = SmallInteger(30);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if remainder between a negative non-zero value and itself will
// return zero.
//
// In remainder operations, any value remainder itself results in zero.
// For example:
//
// -20.remainder(-20) = 0
//
// Observations:
// - Additionally, no tests involve [Serial types] because their minimum
//   {value} is 1, thus they cannot store negative values.
  group('remainder by itself (negative)', () {
    test('should return zero when performing remainder by BigInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(-30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by Integer', () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(-30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing remainder by SmallInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(0);
      final operation = value1.remainder(value2);
      expect(operation.identicalTo(expected), true);
    });
  });
}
