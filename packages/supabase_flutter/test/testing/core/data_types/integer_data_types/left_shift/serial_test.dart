import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests if the left shift operator functions correctly with positive values.
//
// This test group verifies the correctness of the left shift operator
// when applied to positive operands. The primary focus is to assess how left
// shifting affects the bit pattern of a positive number, specifically testing
// for correct bit displacement and overflow handling. The tests aim to confirm
// that the operation increases the operand's value exponentially by powers of
// two, without unintended side effects. Additionally, the tests examine whether
// type promotion remain consistent and predictable across different data types
// under these conditions.
  group('left shift tests (positive)', () {
    test('should shift correctly BigInteger', () {
      final value1 = Serial(229);
      final value2 = BigInteger(2);
      final expected = BigInteger(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = Serial(229);
      final value2 = Integer(2);
      final expected = Integer(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = Serial(229);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly BigSerial', () {
      final value1 = Serial(229);
      final value2 = BigSerial(2);
      final expected = BigSerial(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Serial', () {
      final value1 = Serial(229);
      final value2 = Serial(2);
      final expected = Serial(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallSerial', () {
      final value1 = Serial(229);
      final value2 = SmallSerial(2);
      final expected = Serial(916);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the left shift operator functions correctly when non-zero positive
// values are shifted by zero.
//
// This test group verifies the correctness of the left shift operator when
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
      final value1 = Serial(229);
      final value2 = BigInteger(0);
      final expected = BigInteger(229);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly Integer', () {
      final value1 = Serial(229);
      final value2 = Integer(0);
      final expected = Integer(229);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should shift correctly SmallInteger', () {
      final value1 = Serial(229);
      final value2 = SmallInteger(0);
      final expected = SmallInteger(229);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests left shift operations where the shift count exceeds the bit length of
// the data type, using modulo arithmetic.
//
// This test group assesses the correctness of the left shift operator when the
// second operand (shift count) is beyond the allowable limit for the data type.
// The tests confirm the behavior that the actual shift performed is equal to the
// shift count modulo the number of bits in the data type.
//
// Observations:
// - The modulo will be applied to the shift count by the number of bits in the
// most precise value. For example, if we one operand is {SmallInteger} and the
// other is {Integer}, the shift count will be divided by 32 because that's the
// size of a 4-byte {Integer}, then the value will be shifted by the remainder.
//
// - There are no tests where the first operand is negative because [Serial types],
// can not store negative values.
  group('shift count modulo', () {
    test(
        'should return the modulo of the BigInteger shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = BigInteger(66);
      final expected = BigInteger(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Integer shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = Integer(66);
      final expected = Integer(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallInteger shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = SmallInteger(66);
      final expected = SmallInteger(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the BigSerial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = BigSerial(66);
      final expected = BigSerial(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the Serial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = Serial(66);
      final expected = Serial(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return the modulo of the SmallSerial shift count by the number of bits when shifiting a positive value',
        () {
      final value1 = Serial(86);
      final value2 = SmallSerial(66);
      final expected = Serial(344);
      final operation = value1 << value2;
      expect(operation.identicalTo(expected), true);
    });
  });
}
