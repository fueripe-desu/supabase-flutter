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
      expect(SmallInteger(20) == BigInteger(20), true);
    });

    test('should return false if value is less than BigInteger', () {
      expect(SmallInteger(20) == BigInteger(30), false);
    });

    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(40) == BigInteger(30), false);
    });

    test('should return true if value is equal to Integer', () {
      expect(SmallInteger(20) == Integer(20), true);
    });

    test('should return false if value is less than Integer', () {
      expect(SmallInteger(20) == Integer(30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(40) == Integer(30), false);
    });

    test('should return true if value is equal to SmallInteger', () {
      expect(SmallInteger(20) == SmallInteger(20), true);
    });

    test('should return false if value is less than SmallInteger', () {
      expect(SmallInteger(20) == SmallInteger(30), false);
    });

    test('should return false if value is greter SmallInteger', () {
      expect(SmallInteger(40) == SmallInteger(30), false);
    });

    test('should return true if value is equal to BigSerial', () {
      expect(SmallInteger(20) == BigSerial(20), true);
    });

    test('should return false if value is less than BigSerial', () {
      expect(SmallInteger(20) == BigSerial(30), false);
    });

    test('should return false if value is greater than BigSerial', () {
      expect(SmallInteger(40) == BigSerial(30), false);
    });

    test('should return true if value is equal to Serial', () {
      expect(SmallInteger(20) == Serial(20), true);
    });

    test('should return false if value is less than Serial', () {
      expect(SmallInteger(20) == Serial(30), false);
    });

    test('should return false if value is greater than Serial', () {
      expect(SmallInteger(40) == Serial(30), false);
    });

    test('should return true if value is equal to SmallSerial', () {
      expect(SmallInteger(20) == SmallSerial(20), true);
    });

    test('should return false if value is less than SmallSerial', () {
      expect(SmallInteger(20) == SmallSerial(30), false);
    });

    test('should return false if value is greater than SmallSerial', () {
      expect(SmallInteger(40) == SmallSerial(30), false);
    });

    test('should return true if value is equal to int primitive', () {
      expect(SmallInteger(20) == 20, true);
    });

    test('should return false if value is less than int primitive', () {
      expect(SmallInteger(20) == 30, false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(40) == 30, false);
    });

    test('should return true if value is equal to double primitive', () {
      expect(SmallInteger(20) == 20.0, true);
    });

    test('should return false if value is less than double primitive', () {
      expect(SmallInteger(20) == 20.5, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(40) == 20.5, false);
    });

    test('should return true if value is lexicographically equal to string',
        () {
      expect(SmallInteger(20) == '20', true);
    });

    test('should return false if value is lexicographically less than string',
        () {
      expect(SmallInteger(20) == 'sample', false);
    });

    test(
        'should return false if value is lexicographically greater than string',
        () {
      expect(SmallInteger(200) == '199', false);
    });

    test('should return true if value is equal to Real', () {
      expect(SmallInteger(20) == Real(20), true);
    });

    test('should return false if value is less than Real', () {
      expect(SmallInteger(20) == Real(30), false);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(40) == Real(30), false);
    });

    test('should return true if value is equal to DoublePrecision', () {
      expect(SmallInteger(20) == DoublePrecision(20), true);
    });

    test('should return false if value is less than DoublePrecision', () {
      expect(SmallInteger(20) == DoublePrecision(30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(40) == DoublePrecision(30), false);
    });

    test('should return true if value is equal to int Numeric', () {
      final numeric = Numeric(value: '20', precision: 2, scale: 0);
      expect(SmallInteger(20) == numeric, true);
    });

    test('should return false if value is less than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(20) == numeric, false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return true if value is equal to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '20');
      expect(SmallInteger(20) == numeric, true);
    });

    test('should return false if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(20) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return true if value is equal to float Numeric', () {
      final numeric = Numeric(value: '20.0', precision: 3, scale: 1);
      expect(SmallInteger(20) == numeric, true);
    });

    test('should return false if value is less than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(20) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return true if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '20.0');
      expect(SmallInteger(20) == numeric, true);
    });

    test(
        'should return false if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(20) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return true if value is equal to int Decimal', () {
      final decimal = Decimal(value: '20', precision: 2, scale: 0);
      expect(SmallInteger(20) == decimal, true);
    });

    test('should return false if value is less than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(20) == decimal, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return true if value is equal to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '20');
      expect(SmallInteger(20) == decimal, true);
    });

    test('should return false if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(20) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return true if value is equal to float Decimal', () {
      final decimal = Decimal(value: '20.0', precision: 3, scale: 1);
      expect(SmallInteger(20) == decimal, true);
    });

    test('should return false if value is less than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(20) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return true if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '20.0');
      expect(SmallInteger(20) == decimal, true);
    });

    test(
        'should return false if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(20) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) == decimal, false);
    });
  });

// Tests if equality operator comparison works correctly with negative operands.
//
// This test group evaluates the correctness of the equality operator when used with
// negative operands across all supported data types in PostgreSQL. The primary focus
// is on verifying the correct result of comparisons and ensuring that they execute
// successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests involving [fractional arbitrary types] are conducted distinctively because
// an [Integer type] cannot be simultaneously greater than, equal to, or less than
// a [fractional arbitrary type]. Therefore, this test group specifically verifies
// whether the values are different, rather than attempting direct comparisons of
// magnitude or equality.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('negative comparison', () {
    test('should return true if value is equal to BigInteger', () {
      expect(SmallInteger(-20) == BigInteger(-20), true);
    });

    test('should return false if value is less than BigInteger', () {
      expect(SmallInteger(-30) == BigInteger(-20), false);
    });

    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(-20) == BigInteger(-30), false);
    });

    test('should return true if value is equal to Integer', () {
      expect(SmallInteger(-20) == Integer(-20), true);
    });

    test('should return false if value is less than Integer', () {
      expect(SmallInteger(-30) == Integer(-20), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(-20) == Integer(-30), false);
    });

    test('should return true if value is equal to SmallInteger', () {
      expect(SmallInteger(-20) == SmallInteger(-20), true);
    });

    test('should return false if value is less than SmallInteger', () {
      expect(SmallInteger(-30) == SmallInteger(-20), false);
    });

    test('should return false if value is greater than SmallInteger', () {
      expect(SmallInteger(-20) == SmallInteger(-30), false);
    });

    test('should return true if value is equal to int primitive', () {
      expect(SmallInteger(-20) == -20, true);
    });

    test('should return false if value is less than int primitive', () {
      expect(SmallInteger(-30) == -20, false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(-20) == -30, false);
    });

    test('should return true if value is equal to double primitive', () {
      expect(SmallInteger(-20) == -20.0, true);
    });

    test('should return false if value is less than double primitive', () {
      expect(SmallInteger(-30) == -20.5, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(-20) == -30.5, false);
    });

    test('should return true if value is lexicographically equal to string',
        () {
      expect(SmallInteger(-20) == '-20', true);
    });

    test('should return false if value is lexicographically less than string',
        () {
      expect(SmallInteger(-20) == 'sample', false);
    });

    test(
        'should return false if value is lexicographically greater than string',
        () {
      expect(SmallInteger(-200) == 'false', false);
    });

    test('should return true if value is equal to Real', () {
      expect(SmallInteger(-20) == Real(-20), true);
    });

    test('should return false if value is less than Real', () {
      expect(SmallInteger(-30) == Real(-20), false);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(-20) == Real(-30), false);
    });

    test('should return true if value is equal to DoublePrecision', () {
      expect(SmallInteger(-20) == DoublePrecision(-20), true);
    });

    test('should return false if value is less than DoublePrecision', () {
      expect(SmallInteger(-30) == DoublePrecision(-20), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(-20) == DoublePrecision(-30), false);
    });

    test('should return true if value is equal to int Numeric', () {
      final numeric = Numeric(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-20) == numeric, true);
    });

    test('should return false if value is less than int Numeric', () {
      final numeric = Numeric(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-30) == numeric, false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(-20) == numeric, false);
    });

    test('should return true if value is equal to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-20');
      expect(SmallInteger(-20) == numeric, true);
    });

    test('should return false if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-20');
      expect(SmallInteger(-30) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(-20) == numeric, false);
    });

    test('should return true if value is equal to float Numeric', () {
      final numeric = Numeric(value: '-20.0', precision: 3, scale: 1);
      expect(SmallInteger(-20) == numeric, true);
    });

    test('should return false if value is less than float Numeric', () {
      final numeric = Numeric(value: '-20.5', precision: 3, scale: 1);
      expect(SmallInteger(-30) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(-20) == numeric, false);
    });

    test('should return true if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-20.0');
      expect(SmallInteger(-20) == numeric, true);
    });

    test(
        'should return false if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-20.5');
      expect(SmallInteger(-30) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(-20) == numeric, false);
    });

    test('should return false if value is different from Numeric', () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) == numeric, false);
    });

    test('should return true if value is equal to int Decimal', () {
      final decimal = Decimal(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-20) == decimal, true);
    });

    test('should return false if value is less than int Decimal', () {
      final decimal = Decimal(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-30) == decimal, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(-20) == decimal, false);
    });

    test('should return true if value is equal to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-20');
      expect(SmallInteger(-20) == decimal, true);
    });

    test('should return false if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-20');
      expect(SmallInteger(-30) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(-20) == decimal, false);
    });

    test('should return true if value is equal to float Decimal', () {
      final decimal = Decimal(value: '-20.0', precision: 3, scale: 1);
      expect(SmallInteger(-20) == decimal, true);
    });

    test('should return false if value is less than float Decimal', () {
      final decimal = Decimal(value: '-20.5', precision: 3, scale: 1);
      expect(SmallInteger(-30) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(-20) == decimal, false);
    });

    test('should return true if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-20.0');
      expect(SmallInteger(-20) == decimal, true);
    });

    test(
        'should return false if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-20.5');
      expect(SmallInteger(-30) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(-20) == decimal, false);
    });

    test('should return false if value is different from Decimal', () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) == decimal, false);
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
      expect(SmallInteger(40) == BigInteger(-30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(40) == Integer(-30), false);
    });

    test('should return false if value is greater than SmallInteger', () {
      expect(SmallInteger(40) == SmallInteger(-30), false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(40) == -30, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(40) == -20.5, false);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(40) == Real(-30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(40) == DoublePrecision(-30), false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(40) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) == numeric, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(40) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(40) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) == decimal, false);
    });
  });

// Tests if equality operator comparison works correctly with the first operand being
// negative and the second operand being positive.
//
// This test group evaluates the correctness of the equality operator when used with
// mixed sign operands across all supported data types in PostgreSQL. The primary
// focus is on verifying the correct result of comparisons and ensuring that they
// execute successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and 1 results because a negative value is always less than
// a positive one, in every scenario.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Tests involving [fractional arbitrary types] are conducted distinctively because
// an [Integer type] cannot be simultaneously greater than, equal to, or less than
// a [fractional arbitrary type]. Therefore, this test group specifically verifies
// whether the values are different, rather than attempting direct comparisons of
// magnitude or equality.
  group('mixed sign comparison (negative + positive)', () {
    test('should return false if value is less than BigInteger', () {
      expect(SmallInteger(-40) == BigInteger(30), false);
    });

    test('should return false if value is less than Integer', () {
      expect(SmallInteger(-40) == Integer(30), false);
    });

    test('should return false if value is less than SmallInteger', () {
      expect(SmallInteger(-40) == SmallInteger(30), false);
    });

    test('should return false if value is less than BigSerial', () {
      expect(SmallInteger(-40) == BigSerial(30), false);
    });

    test('should return false if value is less than Serial', () {
      expect(SmallInteger(-40) == Serial(30), false);
    });

    test('should return false if value is less than SmallSerial', () {
      expect(SmallInteger(-40) == SmallSerial(30), false);
    });

    test('should return false if value is less than int primitive', () {
      expect(SmallInteger(-40) == 30, false);
    });

    test('should return false if value is less than double primitive', () {
      expect(SmallInteger(-40) == 20.5, false);
    });

    test('should return false if value is less than Real', () {
      expect(SmallInteger(-40) == Real(30), false);
    });

    test('should return false if value is less than DoublePrecision', () {
      expect(SmallInteger(-40) == DoublePrecision(30), false);
    });

    test('should return false if value is less than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(-40) == numeric, false);
    });

    test('should return false if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(-40) == numeric, false);
    });

    test('should return false if value is less than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(-40) == numeric, false);
    });

    test(
        'should return false if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(-40) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) == numeric, false);
    });

    test('should return false if value is less than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(-40) == decimal, false);
    });

    test('should return false if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(-40) == decimal, false);
    });

    test('should return false if value is less than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(-40) == decimal, false);
    });

    test(
        'should return false if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(-40) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) == decimal, false);
    });
  });

// Tests if equality operator comparison works correctly with the first operand being
// zero and the second operand being a positive value.
//
// This test group evaluates the correctness of the equality operator when used with
// a zero operand and a positive value, respectively, across all supported data
// types in PostgreSQL. The primary focus is on verifying the correct result of
// comparisons and ensuring that they execute successfully without errors or unexpected
// behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and 1 results because a zero value is always less than
// a positive one, in every scenario.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Tests involving [fractional arbitrary types] are conducted distinctively because
// an [Integer type] cannot be simultaneously greater than, equal to, or less than
// a [fractional arbitrary type]. Therefore, this test group specifically verifies
// whether the values are different, rather than attempting direct comparisons of
// magnitude or equality.
  group('zero with positive comparison', () {
    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(0) == BigInteger(30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(0) == Integer(30), false);
    });

    test('should return false if value is greter SmallInteger', () {
      expect(SmallInteger(0) == SmallInteger(30), false);
    });

    test('should return false if value is greater than BigSerial', () {
      expect(SmallInteger(0) == BigSerial(30), false);
    });

    test('should return false if value is greater than Serial', () {
      expect(SmallInteger(0) == Serial(30), false);
    });

    test('should return false if value is greater than SmallSerial', () {
      expect(SmallInteger(0) == SmallSerial(30), false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(0) == 30, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(0) == 20.5, false);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(0) == Real(30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(0) == DoublePrecision(30), false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(0) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(0) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(0) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(0) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) == decimal, false);
    });
  });

// Tests if equality operator comparison works correctly with the first operand being
// zero and the second operand being a negative value.
//
// This test group evaluates the correctness of the equality operator when used with
// a zero operand and a negative value, respectively, across all supported data
// types in PostgreSQL. The primary focus is on verifying the correct result of
// comparisons and ensuring that they execute successfully without errors or unexpected
// behavior for each data type.
//
// Observations:
// - Tests exclude the 0 and false results because a zero value is always greater than
// a negative one, in every scenario.
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
  group('zero with negative comparison', () {
    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(0) == BigInteger(-30), false);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(0) == Integer(-30), false);
    });

    test('should return false if value is greter SmallInteger', () {
      expect(SmallInteger(0) == SmallInteger(-30), false);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(0) == -30, false);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(0) == -20.5, false);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(0) == Real(-30), false);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(0) == DoublePrecision(-30), false);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(0) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) == numeric, false);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is different from fractional Numeric',
        () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) == numeric, false);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(0) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(0) == decimal, false);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) == decimal, false);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(0) == decimal, false);
    });

    test('should return false if value is different from fractional Decimal',
        () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) == decimal, false);
    });
  });

// Tests if equality operator works correctly with zero operands.
//
// This test group evaluates the correctness of the equality operator when used with
// zero operands across all supported data types in PostgreSQL. The primary focus
// is on verifying the correct result of comparisons and ensuring that they execute
// successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Tests exclude the 1 and false results because a zero value is always equal to
// another zero value, in every scenario.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - All [floating point types] are [integer-valued] because [fractional] values can
// not equate to an [Integer type].
//
// - There are no tests for [fractional arbitrary precision types] as they can not
// equate to an [Integer type].
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
  group('zero with zero comparison', () {
    test('should return true if value is greater than BigInteger', () {
      expect(SmallInteger(0) == BigInteger(0), true);
    });

    test('should return true if value is greater than Integer', () {
      expect(SmallInteger(0) == Integer(0), true);
    });

    test('should return true if value is greter SmallInteger', () {
      expect(SmallInteger(0) == SmallInteger(0), true);
    });

    test('should return true if value is greater than int primitive', () {
      expect(SmallInteger(0) == 0, true);
    });

    test('should return true if value is greater than double primitive', () {
      expect(SmallInteger(0) == 0, true);
    });

    test('should return true if value is greater than Real', () {
      expect(SmallInteger(0) == Real(0), true);
    });

    test('should return true if value is greater than DoublePrecision', () {
      expect(SmallInteger(0) == DoublePrecision(0), true);
    });

    test('should return true if value is greater than int Numeric', () {
      final numeric = Numeric(value: '0', precision: 2, scale: 0);
      expect(SmallInteger(0) == numeric, true);
    });

    test(
        'should return true if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '0');
      expect(SmallInteger(0) == numeric, true);
    });

    test('should return true if value is greater than float Numeric', () {
      final numeric = Numeric(value: '0.0', precision: 3, scale: 1);
      expect(SmallInteger(0) == numeric, true);
    });

    test(
        'should return true if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '0.0');
      expect(SmallInteger(0) == numeric, true);
    });

    test('should return true if value is greater than int Decimal', () {
      final decimal = Decimal(value: '0', precision: 2, scale: 0);
      expect(SmallInteger(0) == decimal, true);
    });

    test(
        'should return true if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '0');
      expect(SmallInteger(0) == decimal, true);
    });

    test('should return true if value is greater than float Decimal', () {
      final decimal = Decimal(value: '0.0', precision: 3, scale: 1);
      expect(SmallInteger(0) == decimal, true);
    });

    test(
        'should return true if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '0.0');
      expect(SmallInteger(0) == decimal, true);
    });
  });

  test('should return false if compared to an unsupported value', () {
    expect(SmallInteger(20) == DateTime(2022), false);
  });
}
