// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests if equality operator comparison works correctly with positive operands.
//
// This test group evaluates the correctness of the equality opeartor when used with
// positive parameters across all supported data types in PostgreSQL. The primary focus
// is on verifying the correct result of comparisons and ensuring that they execute
// successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests involving [fractional arbitrary types] are conducted distinctively because
// an [Integer type] cannot be simultaneously greater than, equal to, or less than
// a [fractional arbitrary type]. Therefore, this test group specifically verifies
// whether the values are different, rather than attempting direct comparisons of
// magnitude or equality.
  group('positive comparison', () {
    test('should return true if value is equal to BigInteger', () {
      expect(Serial(20) == BigInteger(20), true);
    });

    test('should return false if value is less than BigInteger', () {
      expect(Serial(20) == BigInteger(30), false);
    });

    test('should return false if value is greater than BigInteger', () {
      expect(Serial(40) == BigInteger(30), false);
    });

    test('should return true if value is equal to Integer', () {
      expect(Serial(20) == Integer(20), true);
    });

    test('should return false if value is less than Integer', () {
      expect(Serial(20) == Integer(30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(Serial(40) == Integer(30), false);
    });

    test('should return true if value is equal to SmallInteger', () {
      expect(Serial(20) == SmallInteger(20), true);
    });

    test('should return false if value is less than SmallInteger', () {
      expect(Serial(20) == SmallInteger(30), false);
    });

    test('should return false if value is greter SmallInteger', () {
      expect(Serial(40) == SmallInteger(30), false);
    });

    test('should return true if value is equal to BigSerial', () {
      expect(Serial(20) == BigSerial(20), true);
    });

    test('should return false if value is less than BigSerial', () {
      expect(Serial(20) == BigSerial(30), false);
    });

    test('should return false if value is greater than BigSerial', () {
      expect(Serial(40) == BigSerial(30), false);
    });

    test('should return true if value is equal to Serial', () {
      expect(Serial(20) == Serial(20), true);
    });

    test('should return false if value is less than Serial', () {
      expect(Serial(20) == Serial(30), false);
    });

    test('should return false if value is greater than Serial', () {
      expect(Serial(40) == Serial(30), false);
    });

    test('should return true if value is equal to SmallSerial', () {
      expect(Serial(20) == SmallSerial(20), true);
    });

    test('should return false if value is less than SmallSerial', () {
      expect(Serial(20) == SmallSerial(30), false);
    });

    test('should return false if value is greater than SmallSerial', () {
      expect(Serial(40) == SmallSerial(30), false);
    });

    test('should return true if value is equal to int primitive', () {
      expect(Serial(20) == 20, true);
    });

    test('should return false if value is less than int primitive', () {
      expect(Serial(20) == 30, false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(Serial(40) == 30, false);
    });

    test('should return true if value is equal to double primitive', () {
      expect(Serial(20) == 20.0, true);
    });

    test('should return false if value is less than double primitive', () {
      expect(Serial(20) == 20.5, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(Serial(40) == 20.5, false);
    });

    test('should return true if value is lexicographically equal to string',
        () {
      expect(Serial(20) == '20', true);
    });

    test('should return false if value is lexicographically less than string',
        () {
      expect(Serial(20) == 'sample', false);
    });

    test(
        'should return false if value is lexicographically greater than string',
        () {
      expect(Serial(200) == '199', false);
    });

    test('should return true if value is equal to Real', () {
      expect(Serial(20) == Real(20), true);
    });

    test('should return false if value is less than Real', () {
      expect(Serial(20) == Real(30), false);
    });

    test('should return false if value is greater than Real', () {
      expect(Serial(40) == Real(30), false);
    });

    test('should return true if value is equal to DoublePrecision', () {
      expect(Serial(20) == DoublePrecision(20), true);
    });

    test('should return false if value is less than DoublePrecision', () {
      expect(Serial(20) == DoublePrecision(30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(Serial(40) == DoublePrecision(30), false);
    });

    test('should return true if value is equal to int Numeric', () {
      final numeric = Numeric(value: '20', precision: 2, scale: 0);
      expect(Serial(20) == numeric, true);
    });

    test('should return false if value is less than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(Serial(20) == numeric, false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(Serial(40) == numeric, false);
    });

    test('should return true if value is equal to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '20');
      expect(Serial(20) == numeric, true);
    });

    test('should return false if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(Serial(20) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(Serial(40) == numeric, false);
    });

    test('should return true if value is equal to float Numeric', () {
      final numeric = Numeric(value: '20.0', precision: 3, scale: 1);
      expect(Serial(20) == numeric, true);
    });

    test('should return false if value is less than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(Serial(20) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(Serial(40) == numeric, false);
    });

    test('should return true if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '20.0');
      expect(Serial(20) == numeric, true);
    });

    test(
        'should return false if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(Serial(20) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(Serial(40) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(Serial(40) == numeric, false);
    });

    test('should return true if value is equal to int Decimal', () {
      final decimal = Decimal(value: '20', precision: 2, scale: 0);
      expect(Serial(20) == decimal, true);
    });

    test('should return false if value is less than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(Serial(20) == decimal, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(Serial(40) == decimal, false);
    });

    test('should return true if value is equal to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '20');
      expect(Serial(20) == decimal, true);
    });

    test('should return false if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(Serial(20) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(Serial(40) == decimal, false);
    });

    test('should return true if value is equal to float Decimal', () {
      final decimal = Decimal(value: '20.0', precision: 3, scale: 1);
      expect(Serial(20) == decimal, true);
    });

    test('should return false if value is less than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(Serial(20) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(Serial(40) == decimal, false);
    });

    test('should return true if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '20.0');
      expect(Serial(20) == decimal, true);
    });

    test(
        'should return false if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(Serial(20) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(Serial(40) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(Serial(40) == decimal, false);
    });
  });

// Tests if equality operator comparison works correctly with the first operand being
// positive and the second operand being negative.
//
// This test group evaluates the correctness of the equality operator when used with
// mixed sign parameters across all supported data types in PostgreSQL. The primary
// focus is on verifying the correct result of comparisons and ensuring that they
// execute successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and false results because a positive value is always greater
// than a negative one, in every scenario.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Tests involving [fractional arbitrary types] are conducted distinctively because
// an [Integer type] cannot be simultaneously greater than, equal to, or less than
// a [fractional arbitrary type]. Therefore, this test group specifically verifies
// whether the values are different, rather than attempting direct comparisons of
// magnitude or equality.
  group('mixed sign comparison (positive + negative)', () {
    test('should return false if value is greater than BigInteger', () {
      expect(Serial(40) == BigInteger(-30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(Serial(40) == Integer(-30), false);
    });

    test('should return false if value is greater than SmallInteger', () {
      expect(Serial(40) == SmallInteger(-30), false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(Serial(40) == -30, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(Serial(40) == -20.5, false);
    });

    test('should return false if value is greater than Real', () {
      expect(Serial(40) == Real(-30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(Serial(40) == DoublePrecision(-30), false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(Serial(40) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(Serial(40) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(Serial(40) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(Serial(40) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(Serial(40) == numeric, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(Serial(40) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(Serial(40) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(Serial(40) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(Serial(40) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(Serial(40) == decimal, false);
    });
  });

  test('should return false if compared to an unsupported value', () {
    expect(Serial(20) == DateTime(2022), false);
  });
}
