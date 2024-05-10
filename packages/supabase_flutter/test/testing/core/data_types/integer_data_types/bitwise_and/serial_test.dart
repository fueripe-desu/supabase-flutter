import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  late final int Function(String binaryString) binary;

  setUpAll(() {
    binary = (binaryString) {
      final cleaned = binaryString.replaceAll(' ', '');
      return int.parse(cleaned, radix: 2);
    };
  });

// Tests if the bitwise AND operator functions correctly with values where all bits
// are set to 1.
//
// This test group verifies the correctness of the bitwise AND operator when applied
// to operands whose all bits are set to 1, typically representing the maximum positive
// value for the operand's type. The focus of these tests is not only on the correctness
// of the resulting value but also on whether type promotion operates as expected under
// these conditions.
  group('all bits set (positive)', () {
    test('should retain all bits from BigInteger', () {
      const bitValue = (1 << 31) - 1;
      final value1 = Serial(bitValue - 1);
      final value2 = BigInteger(bitValue - 1);
      final expected = BigInteger(bitValue - 1);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain all bits from Integer', () {
      const bitValue = (1 << 31) - 1;
      final value1 = Serial(bitValue);
      final value2 = Integer(bitValue);
      final expected = Integer(bitValue);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain all bits from SmallInteger', () {
      const bitValue = (1 << 15) - 1;
      final value1 = Serial(bitValue);
      final value2 = SmallInteger(bitValue);
      final expected = SmallInteger(bitValue);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain all bits from BigSerial', () {
      const bitValue = (1 << 31) - 1;
      final value1 = Serial(bitValue - 1);
      final value2 = BigSerial(bitValue - 1);
      final expected = BigSerial(bitValue - 1);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain all bits from Serial', () {
      const bitValue = (1 << 31) - 1;
      final value1 = Serial(bitValue);
      final value2 = Serial(bitValue);
      final expected = Serial(bitValue);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain all bits from SmallInteger', () {
      const bitValue = (1 << 15) - 1;
      final value1 = Serial(bitValue);
      final value2 = SmallSerial(bitValue);
      final expected = Serial(bitValue);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with positive operands having
// mixed bit settings.
//
// This test group verifies the correctness of the bitwise AND operator when applied
// to positive operands with differing bit settings—one with all bits set (representing
// the maximum possible value for the type) and the other with no bits set (representing
// zero). The focus of these tests is to confirm that the resulting value of such
// operations is zero, as any value ANDed with zero should yield zero. The tests also
// examine if type promotion and the behavior of bitwise operations across different
// data types are handled as expected under these conditions.
//
// Observations:
// - Tests where the first operand is zero or less are excluded from this group because
// [Serial type], as the first operand, cannot have a minimum {value} of zero or less,
// making such tests impossible. Therefore, only tests where the first operand represents
// the maximum value are included.
  group('mixed bits set (positive)', () {
    test('should return 0 when performing bitwise with zero BigInteger', () {
      const allBits = (1 << 31) - 1;
      const noBits = 0 << 31;
      final value1 = Serial(allBits - 1);
      final value2 = BigInteger(noBits);
      final expected = BigInteger(noBits);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with zero Integer', () {
      const allBits = (1 << 31) - 1;
      const noBits = 0 << 31;
      final value1 = Serial(allBits);
      final value2 = Integer(noBits);
      final expected = Integer(noBits);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with zero SmallInteger', () {
      const allBits = (1 << 15) - 1;
      const noBits = 0 << 15;
      final value1 = Serial(allBits);
      final value2 = SmallInteger(noBits);
      final expected = SmallInteger(noBits);
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with operands having
// alternating bit patterns.
//
// This test group verifies the correctness of the bitwise AND operator when
// applied to operands with complementary alternating bit patterns, such as
// '01010101' and '10101010'. The focus of these tests is to confirm that the
// resulting value from bitwise AND operations between such patterns is zero, as
// each bit in one operand is the logical complement of the corresponding bit in
// the other operand. Additionally, these tests examine whether type promotion
// and the behavior of bitwise operations across different data types are consistent
// and as expected under these conditions.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
// {value} is 1, and they cannot store negative values.
  group('alternating 1s and 0s', () {
    test('should return 0 when performing bitwise with BigInteger', () {
      final value1 = Serial(binary('10101010'));
      final value2 = BigInteger(binary('01010101'));
      final expected = BigInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with Integer', () {
      final value1 = Serial(binary('10101010'));
      final value2 = Integer(binary('01010101'));
      final expected = Integer(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with SmallInteger', () {
      final value1 = Serial(binary('10101010'));
      final value2 = SmallInteger(binary('01010101'));
      final expected = SmallInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with operands having
// random alternating bit patterns.
//
// This test group verifies the correctness of the bitwise AND operator when
// applied to operands with randomly alternating bit patterns, such as
// '10110100' and '01001011'. The focus of these tests is to confirm that the
// resulting value from bitwise AND operations between such patterns is zero,
// as no corresponding bits in the two operands are both set to 1 simultaneously.
// These tests also evaluate whether type promotion and the consistency of bitwise
// operations across different data types are maintained under these conditions.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
// {value} is 1, and they cannot store negative values.
  group('random alternating patterns', () {
    test('should return 0 when performing bitwise with BigInteger', () {
      final value1 = Serial(binary('10110100'));
      final value2 = BigInteger(binary('01001011'));
      final expected = BigInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with Integer', () {
      final value1 = Serial(binary('10110100'));
      final value2 = Integer(binary('01001011'));
      final expected = Integer(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with SmallInteger', () {
      final value1 = Serial(binary('10110100'));
      final value2 = SmallInteger(binary('01001011'));
      final expected = SmallInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with operands having
// random overlapping bit patterns.
//
// This test group verifies the correctness of the bitwise AND operator when
// applied to operands with randomly overlapping bit patterns, such as
// '00101011' and '00001110'. The focus of these tests is to confirm that the
// resulting value from bitwise AND operations between such patterns yields a
// non-zero value, as some corresponding bits in the two operands are set to 1
// simultaneously. These tests also evaluate whether type promotion and the
// consistency of bitwise operations across different data types are maintained
// under these conditions.

  group('random overlapping patterns', () {
    test('should return 10 when performing bitwise with BigInteger', () {
      final value1 = Serial(binary('00101011'));
      final value2 = BigInteger(binary('00001110'));
      final expected = BigInteger(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 10 when performing bitwise with Integer', () {
      final value1 = Serial(binary('00101011'));
      final value2 = Integer(binary('00001110'));
      final expected = Integer(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 10 when performing bitwise with SmallInteger', () {
      final value1 = Serial(binary('00101011'));
      final value2 = SmallInteger(binary('00001110'));
      final expected = SmallInteger(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 10 when performing bitwise with BigSerial', () {
      final value1 = Serial(binary('00101011'));
      final value2 = BigSerial(binary('00001110'));
      final expected = BigSerial(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 10 when performing bitwise with Serial', () {
      final value1 = Serial(binary('00101011'));
      final value2 = Serial(binary('00001110'));
      final expected = Serial(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 10 when performing bitwise with SmallSerial', () {
      final value1 = Serial(binary('00101011'));
      final value2 = SmallSerial(binary('00001110'));
      final expected = Serial(binary('00001010'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with operands
// featuring non-overlapping single bits.
//
// This test group verifies the correctness of the bitwise AND operator
// when applied to operands with non-overlapping single bits, such as
// '00000001' and '00000010'. The focus of these tests is to confirm that
// the resulting value from bitwise AND operations between such patterns
// is zero, as there are no corresponding bits set to 1 in both operands
// simultaneously. These tests also assess whether type promotion and the
// consistency of bitwise operations across different data types are
// effectively maintained under these conditions.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
// {value} is 1, and they cannot store negative values.
  group('non-overlapping single bit', () {
    test('should return 0 when performing bitwise with BigInteger', () {
      final value1 = Serial(binary('00000001'));
      final value2 = BigInteger(binary('00000010'));
      final expected = BigInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with Integer', () {
      final value1 = Serial(binary('00000001'));
      final value2 = Integer(binary('00000010'));
      final expected = Integer(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 0 when performing bitwise with SmallInteger', () {
      final value1 = Serial(binary('00000001'));
      final value2 = SmallInteger(binary('00000010'));
      final expected = SmallInteger(binary('00000000'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if the bitwise AND operator functions correctly with operands
// featuring overlapping single bits.
//
// This test group verifies the correctness of the bitwise AND operator
// when applied to operands with overlapping single bits, such as
// '00000001' and '00000001'. The focus of these tests is to confirm that
// the resulting value from bitwise AND operations between such identical
// bit patterns is identical to the operands themselves, resulting in a
// non-zero value, as the corresponding bit in both operands is set to 1.
// These tests also assess whether type promotion and the consistency of
// bitwise operations across different data types are effectively
// maintained under these conditions.
  group('single bit value', () {
    test('should return 1 when performing bitwise with BigInteger', () {
      final value1 = Serial(binary('00000001'));
      final value2 = BigInteger(binary('00000001'));
      final expected = BigInteger(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 1 when performing bitwise with Integer', () {
      final value1 = Serial(binary('00000001'));
      final value2 = Integer(binary('00000001'));
      final expected = Integer(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 1 when performing bitwise with SmallInteger', () {
      final value1 = Serial(binary('00000001'));
      final value2 = SmallInteger(binary('00000001'));
      final expected = SmallInteger(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 1 when performing bitwise with BigSerial', () {
      final value1 = Serial(binary('00000001'));
      final value2 = BigSerial(binary('00000001'));
      final expected = BigSerial(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 1 when performing bitwise with Serial', () {
      final value1 = Serial(binary('00000001'));
      final value2 = Serial(binary('00000001'));
      final expected = Serial(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return 1 when performing bitwise with SmallSerial', () {
      final value1 = Serial(binary('00000001'));
      final value2 = SmallSerial(binary('00000001'));
      final expected = Serial(binary('00000001'));
      final operation = value1 & value2;
      expect(operation.identicalTo(expected), true);
    });
  });

  group('general errors', () {
    test(
        'should throw ArgumentError when using bitwise AND with invalid operands',
        () {
      expect(
        () => Serial(binary('00000000')) & 'sample',
        throwsArgumentError,
      );
    });
  });
}
