import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests if the right shift operator functions correctly with positive values.
//
// This test group verifies the correctness of the right shift operator
// when applied to positive operands. The primary focus is to assess how right
// shifting affects the bit pattern of a positive number, specifically testing
// for correct bit displacement and value reduction. The tests aim to confirm
// that the operation decreases the operand's value by powers of
// two, consistent with the expected mathematical properties of right shifts.
// Additionally, the tests examine whether type promotion remains consistent
// and predictable across different data types under these conditions.
  group('right shift tests (positive)', () {
    test('should shift correctly BigInteger', () {
      final value1 = SmallInteger(229);
      final value2 = BigInteger(2);
      final expected = BigInteger(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = SmallInteger(229);
      final value2 = Integer(2);
      final expected = Integer(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = SmallInteger(229);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly BigSerial', () {
      final value1 = SmallInteger(229);
      final value2 = BigSerial(2);
      final expected = SmallInteger(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Serial', () {
      final value1 = SmallInteger(229);
      final value2 = Serial(2);
      final expected = SmallInteger(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallSerial', () {
      final value1 = SmallInteger(229);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(57);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the right shift operator functions correctly with negative values.
//
// This test group verifies the correctness of the right shift operator when
// applied to negative operands. The primary focus of these tests is to determine
// how right shifting affects the bit pattern of a negative number, particularly
// assessing the impact on the sign bit and the overall value. The tests aim to
// confirm that the operation adheres to the rules of binary arithmetic, potentially
// leading to unexpected results due to the retention of the sign bit.
  group('right shift tests (negative)', () {
    test('should shift correctly BigInteger', () {
      final value1 = SmallInteger(-229);
      final value2 = BigInteger(2);
      final expected = BigInteger(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = SmallInteger(-229);
      final value2 = Integer(2);
      final expected = Integer(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = SmallInteger(-229);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly BigSerial', () {
      final value1 = SmallInteger(-229);
      final value2 = BigSerial(2);
      final expected = SmallInteger(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Serial', () {
      final value1 = SmallInteger(-229);
      final value2 = Serial(2);
      final expected = SmallInteger(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallSerial', () {
      final value1 = SmallInteger(-229);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(-58);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the right shift operator functions correctly when zero is shifted by
// non-zero positive values.
//
// This test group verifies the correctness of the right shift operator when
// zero is subjected to shifts by various non-zero positive integers. The primary
// aim is to confirm that shifting zero by any number of positions consistently
// results in zero, validating the fundamental behavior of bitwise shift operations.
  group('zero shifted by any value', () {
    test('should shift correctly BigInteger', () {
      final value1 = SmallInteger(0);
      final value2 = BigInteger(2);
      final expected = BigInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = SmallInteger(0);
      final value2 = Integer(2);
      final expected = Integer(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = SmallInteger(0);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly BigSerial', () {
      final value1 = SmallInteger(0);
      final value2 = BigSerial(2);
      final expected = SmallInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Serial', () {
      final value1 = SmallInteger(0);
      final value2 = Serial(2);
      final expected = SmallInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallSerial', () {
      final value1 = SmallInteger(0);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the right shift operator functions correctly when non-zero positive
// values are shifted by zero.
//
// This test group verifies the correctness of the right shift operator when
// applied to non-zero positive integers shifted by zero positions. The primary aim
// is to confirm that shifting any positive value by zero positions should result
// in the original value unchanged, validating the identity behavior of bitwise
// shift operations.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
// {value} is 1, and they cannot store zero values.
  group('any value shifted by zero (positive)', () {
    test('should shift correctly BigInteger', () {
      final value1 = SmallInteger(229);
      final value2 = BigInteger(0);
      final expected = BigInteger(229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = SmallInteger(229);
      final value2 = Integer(0);
      final expected = Integer(229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = SmallInteger(229);
      final value2 = SmallInteger(0);
      final expected = SmallInteger(229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the right shift operator functions correctly when non-zero negative
// values are shifted by zero.
//
// This test group verifies the correctness of the right shift operator when
// applied to non-zero negative integers shifted by zero positions. The primary aim
// is to confirm that shifting any negative value by zero positions should result
// in the original value unchanged, validating the identity behavior of bitwise
// shift operations.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
// {value} is 1, and they cannot store zero values.
  group('any value shifted by zero (negative)', () {
    test('should shift correctly BigInteger', () {
      final value1 = SmallInteger(-229);
      final value2 = BigInteger(0);
      final expected = BigInteger(-229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = SmallInteger(-229);
      final value2 = Integer(0);
      final expected = Integer(-229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = SmallInteger(-229);
      final value2 = SmallInteger(0);
      final expected = SmallInteger(-229);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the right shift operator functions correctly when values are shifted by
// the maximum amount allowed by their type.
//
// This test group verifies the correctness of the right shift operator when
// applied to values shifted by the maximum shift distance permissible for their
// respective types: 63 positions for {BigIntegers} and {BigSerials}, 31 for
// {Integers} and {Serials}, and 15 for {SmallIntegers} and {SmallSerials}. The
// primary aim is to assess how the system handles shifts that potentially reduce
// the value to zero, effectively clearing the type's storage.
  group('maximum shift', () {
    test('should return 0 when shifting a positive value by the amount of bits',
        () {
      final value1 = SmallInteger(1);
      final value2 = SmallInteger(15);
      final expected = SmallInteger(0);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return -1 when shifting a negative value by the amount of bits',
        () {
      final value1 = SmallInteger(-1);
      final value2 = SmallInteger(15);
      final expected = SmallInteger(-1);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests right shift operations where the shift count exceeds the bit length of
// the data type, using modulo arithmetic.
//
// This test group assesses the correctness of the right shift operator when the
// second operand (shift count) is beyond the allowable limit for the data type.
// The tests confirm the behavior that the actual shift performed is equal to the
// shift count modulo the number of bits in the data type. This ensures that excessive
// shift counts wrap around appropriately based on the data type's bit size.
//
// Observations:
// - The modulo will be applied to the shift count by the number of bits in the
// most precise value. For example, if one operand is {SmallInteger} and the
// other is {Integer}, the shift count will be divided by 32 because that's the
// size of a 4-byte {Integer}, and the value will then be shifted by the remainder.
  group('shift count modulo', () {
    test(
        'should return the modulo of the BigInteger shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = BigInteger(66);
      final expected = BigInteger(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the BigInteger shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = BigInteger(66);
      final expected = BigInteger(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Integer shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = Integer(66);
      final expected = Integer(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Integer shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = Integer(66);
      final expected = Integer(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallInteger shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = SmallInteger(66);
      final expected = SmallInteger(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallInteger shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = SmallInteger(66);
      final expected = SmallInteger(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the BigSerial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = BigSerial(66);
      final expected = SmallInteger(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the BigSerial shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = BigSerial(66);
      final expected = SmallInteger(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Serial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = Serial(66);
      final expected = SmallInteger(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Serial shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = Serial(66);
      final expected = SmallInteger(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallSerial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = SmallInteger(85);
      final value2 = SmallSerial(66);
      final expected = SmallInteger(21);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallSerial shift count by the number of bits when shifiting a negative value',
        () {
      final value1 = SmallInteger(-85);
      final value2 = SmallSerial(66);
      final expected = SmallInteger(-22);
      final operation = value1 >> value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests for error handling in right shift operations with inappropriate shift
// values.
//
// This test group evaluates the correctness and robustness of the right shift
// operator when shift amounts are negative. The tests aim to verify that the
// system appropriately handles these erroneous conditions, typically by throwing
// exceptions or following other defined error-handling protocols.
  group('general errors', () {
    test('should throw ArgumentError when shifting by a negative value', () {
      final value1 = SmallInteger(1);
      final value2 = SmallInteger(-4);
      expect(() => value1 >> value2, throwsArgumentError);
    });
  });
}
