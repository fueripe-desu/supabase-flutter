// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
// Tests if less than or equal to operator comparison works correctly with positive
// operands.
//
// This test group evaluates the correctness of the less than or equal to operator when
// used with positive operands across all supported data types in PostgreSQL. The primary
// focus is on verifying the correct result of comparisons and ensuring that they execute
// successfully without errors or unexpected behavior for each data type.
//
// Observations:
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('positive comparison', () {
    test('should return true if value is equal to BigInteger', () {
      expect(SmallInteger(20) <= BigInteger(20), true);
    });

    test('should return true if value is less than BigInteger', () {
      expect(SmallInteger(20) <= BigInteger(30), true);
    });

    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(40) <= BigInteger(30), false);
    });

    test('should return true if value is equal to Integer', () {
      expect(SmallInteger(20) <= Integer(20), true);
    });

    test('should return true if value is less than Integer', () {
      expect(SmallInteger(20) <= Integer(30), true);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(40) <= Integer(30), false);
    });

    test('should return true if value is equal to SmallInteger', () {
      expect(SmallInteger(20) <= SmallInteger(20), true);
    });

    test('should return true if value is less than SmallInteger', () {
      expect(SmallInteger(20) <= SmallInteger(30), true);
    });

    test('should return false if value is greater than SmallInteger', () {
      expect(SmallInteger(40) <= SmallInteger(30), false);
    });

    test('should return true if value is equal to BigSerial', () {
      expect(SmallInteger(20) <= BigSerial(20), true);
    });

    test('should return true if value is less than BigSerial', () {
      expect(SmallInteger(20) <= BigSerial(30), true);
    });

    test('should return false if value is greater than BigSerial', () {
      expect(SmallInteger(40) <= BigSerial(30), false);
    });

    test('should return true if value is equal to Serial', () {
      expect(SmallInteger(20) <= Serial(20), true);
    });

    test('should return true if value is less than Serial', () {
      expect(SmallInteger(20) <= Serial(30), true);
    });

    test('should return false if value is greater than Serial', () {
      expect(SmallInteger(40) <= Serial(30), false);
    });

    test('should return true if value is equal to SmallSerial', () {
      expect(SmallInteger(20) <= SmallSerial(20), true);
    });

    test('should return true if value is less than SmallSerial', () {
      expect(SmallInteger(20) <= SmallSerial(30), true);
    });

    test('should return false if value is greater than SmallSerial', () {
      expect(SmallInteger(40) <= SmallSerial(30), false);
    });

    test('should return true if value is equal to int primitive', () {
      expect(SmallInteger(20) <= 20, true);
    });

    test('should return true if value is less than int primitive', () {
      expect(SmallInteger(20) <= 30, true);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(40) <= 30, false);
    });

    test('should return true if value is equal to double primitive', () {
      expect(SmallInteger(20) <= 20.0, true);
    });

    test('should return true if value is less than double primitive', () {
      expect(SmallInteger(20) <= 20.5, true);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(40) <= 20.5, false);
    });

    test('should return true if value is lexicographically equal to string',
        () {
      expect(SmallInteger(20) <= '20', true);
    });

    test('should return true if value is lexicographically less than string',
        () {
      expect(SmallInteger(20) <= 'sample', true);
    });

    test(
        'should return false if value is lexicographically greater than string',
        () {
      expect(SmallInteger(200) <= '199', false);
    });

    test('should return true if value is equal to Real', () {
      expect(SmallInteger(20) <= Real(20), true);
    });

    test('should return true if value is less than Real', () {
      expect(SmallInteger(20) <= Real(30), true);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(40) <= Real(30), false);
    });

    test('should return true if value is equal to DoublePrecision', () {
      expect(SmallInteger(20) <= DoublePrecision(20), true);
    });

    test('should return true if value is less than DoublePrecision', () {
      expect(SmallInteger(20) <= DoublePrecision(30), true);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(40) <= DoublePrecision(30), false);
    });

    test('should return true if value is equal to int Numeric', () {
      final numeric = Numeric(value: '20', precision: 2, scale: 0);
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return true if value is less than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return true if value is equal to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '20');
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return true if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(20) <= numeric, true);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return true if value is equal to float Numeric', () {
      final numeric = Numeric(value: '20.0', precision: 3, scale: 1);
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return true if value is less than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return true if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '20.0');
      expect(SmallInteger(20) <= numeric, true);
    });

    test('should return true if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(20) <= numeric, true);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return false if value is greater than fractional Numeric', () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return true if value is equal to int Decimal', () {
      final decimal = Decimal(value: '20', precision: 2, scale: 0);
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return true if value is less than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return true if value is equal to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '20');
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return true if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(20) <= decimal, true);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return true if value is equal to float Decimal', () {
      final decimal = Decimal(value: '20.0', precision: 3, scale: 1);
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return true if value is less than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return true if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '20.0');
      expect(SmallInteger(20) <= decimal, true);
    });

    test('should return true if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(20) <= decimal, true);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return false if value is greater than fractional Decimal', () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) <= decimal, false);
    });
  });

// Tests if less than or equal to operator comparison works correctly with negative
// operands.
//
// This test group evaluates the correctness of the less than or equal to operator
// when used with negative operands across all supported data types in PostgreSQL.
// The primary focus is on verifying the correct result of comparisons and ensuring
// that they execute successfully without errors or unexpected behavior for each
// data type.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('negative comparison', () {
    test('should return true if value is equal to BigInteger', () {
      expect(SmallInteger(-20) <= BigInteger(-20), true);
    });

    test('should return true if value is less than BigInteger', () {
      expect(SmallInteger(-30) <= BigInteger(-20), true);
    });

    test('should return false if value is greater than BigInteger', () {
      expect(SmallInteger(-20) <= BigInteger(-30), false);
    });

    test('should return true if value is equal to Integer', () {
      expect(SmallInteger(-20) <= Integer(-20), true);
    });

    test('should return true if value is less than Integer', () {
      expect(SmallInteger(-30) <= Integer(-20), true);
    });

    test('should return false if value is greater than Integer', () {
      expect(SmallInteger(-20) <= Integer(-30), false);
    });

    test('should return true if value is equal to SmallInteger', () {
      expect(SmallInteger(-20) <= SmallInteger(-20), true);
    });

    test('should return true if value is less than SmallInteger', () {
      expect(SmallInteger(-30) <= SmallInteger(-20), true);
    });

    test('should return false if value is greater than SmallInteger', () {
      expect(SmallInteger(-20) <= SmallInteger(-30), false);
    });

    test('should return true if value is equal to int primitive', () {
      expect(SmallInteger(-20) <= -20, true);
    });

    test('should return true if value is less than int primitive', () {
      expect(SmallInteger(-30) <= -20, true);
    });

    test('should return false if value is greater than int primitive', () {
      expect(SmallInteger(-20) <= -30, false);
    });

    test('should return true if value is equal to double primitive', () {
      expect(SmallInteger(-20) <= -20.0, true);
    });

    test('should return true if value is less than double primitive', () {
      expect(SmallInteger(-30) <= -20.5, true);
    });

    test('should return false if value is greater than double primitive', () {
      expect(SmallInteger(-20) <= -30.5, false);
    });

    test('should return true if value is lexicographically equal to string',
        () {
      expect(SmallInteger(-20) <= '-20', true);
    });

    test('should return true if value is lexicographically less than string',
        () {
      expect(SmallInteger(-20) <= 'sample', true);
    });

    test(
        'should return false if value is lexicographically greater than string',
        () {
      expect(SmallInteger(-200) <= '-1', false);
    });

    test('should return true if value is equal to Real', () {
      expect(SmallInteger(-20) <= Real(-20), true);
    });

    test('should return true if value is less than Real', () {
      expect(SmallInteger(-30) <= Real(-20), true);
    });

    test('should return false if value is greater than Real', () {
      expect(SmallInteger(-20) <= Real(-30), false);
    });

    test('should return true if value is equal to DoublePrecision', () {
      expect(SmallInteger(-20) <= DoublePrecision(-20), true);
    });

    test('should return true if value is less than DoublePrecision', () {
      expect(SmallInteger(-30) <= DoublePrecision(-20), true);
    });

    test('should return false if value is greater than DoublePrecision', () {
      expect(SmallInteger(-20) <= DoublePrecision(-30), false);
    });

    test('should return true if value is equal to int Numeric', () {
      final numeric = Numeric(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-20) <= numeric, true);
    });

    test('should return true if value is less than int Numeric', () {
      final numeric = Numeric(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-30) <= numeric, true);
    });

    test('should return false if value is greater than int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(-20) <= numeric, false);
    });

    test('should return true if value is equal to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-20');
      expect(SmallInteger(-20) <= numeric, true);
    });

    test('should return true if value is less than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-20');
      expect(SmallInteger(-30) <= numeric, true);
    });

    test(
        'should return false if value is greater than unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(-20) <= numeric, false);
    });

    test('should return true if value is equal to float Numeric', () {
      final numeric = Numeric(value: '-20.0', precision: 3, scale: 1);
      expect(SmallInteger(-20) <= numeric, true);
    });

    test('should return true if value is less than float Numeric', () {
      final numeric = Numeric(value: '-20.5', precision: 3, scale: 1);
      expect(SmallInteger(-30) <= numeric, true);
    });

    test('should return false if value is greater than float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(-20) <= numeric, false);
    });

    test('should return true if value is equal to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-20.0');
      expect(SmallInteger(-20) <= numeric, true);
    });

    test('should return true if value is less than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-20.5');
      expect(SmallInteger(-30) <= numeric, true);
    });

    test(
        'should return false if value is greater than unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(-20) <= numeric, false);
    });

    test('should return true if value is less than fractional Numeric', () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) <= numeric, true);
    });

    test('should return true if value is equal to int Decimal', () {
      final decimal = Decimal(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-20) <= decimal, true);
    });

    test('should return true if value is less than int Decimal', () {
      final decimal = Decimal(value: '-20', precision: 2, scale: 0);
      expect(SmallInteger(-30) <= decimal, true);
    });

    test('should return false if value is greater than int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(-20) <= decimal, false);
    });

    test('should return true if value is equal to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-20');
      expect(SmallInteger(-20) <= decimal, true);
    });

    test('should return true if value is less than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-20');
      expect(SmallInteger(-30) <= decimal, true);
    });

    test(
        'should return false if value is greater than unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(-20) <= decimal, false);
    });

    test('should return true if value is equal to float Decimal', () {
      final decimal = Decimal(value: '-20.0', precision: 3, scale: 1);
      expect(SmallInteger(-20) <= decimal, true);
    });

    test('should return true if value is less than float Decimal', () {
      final decimal = Decimal(value: '-20.5', precision: 3, scale: 1);
      expect(SmallInteger(-30) <= decimal, true);
    });

    test('should return false if value is greater than float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(-20) <= decimal, false);
    });

    test('should return true if value is equal to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-20.0');
      expect(SmallInteger(-20) <= decimal, true);
    });

    test('should return true if value is less than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-20.5');
      expect(SmallInteger(-30) <= decimal, true);
    });

    test(
        'should return false if value is greater than unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(-20) <= decimal, false);
    });

    test('should return true if value is greater than fractional Decimal', () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) <= decimal, true);
    });
  });

// Tests if less than or equal to operator comparison works correctly with the first
// operand being positive and the second operand being negative.
//
// This test group evaluates the correctness of the less than or equal to operator
// when used with mixed sign parameters across all supported data types in PostgreSQL.
// The primary focus is on verifying the correct result of comparisons and ensuring
// that they execute successfully without errors or unexpected behavior for each data
// type.
//
// A positive value is always greater than a negative value. Therefore, all tests
// results in false.
//
// Observations:
// - Less than and equal to tests are excluded from this group because they become
// redundant.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('mixed sign comparison (positive + negative)', () {
    test('should return false if value is compared to BigInteger', () {
      expect(SmallInteger(40) <= BigInteger(-30), false);
    });

    test('should return false if value is compared to Integer', () {
      expect(SmallInteger(40) <= Integer(-30), false);
    });

    test('should return false if value is compared to SmallInteger', () {
      expect(SmallInteger(40) <= SmallInteger(-30), false);
    });

    test('should return false if value is compared to int primitive', () {
      expect(SmallInteger(40) <= -30, false);
    });

    test('should return false if value is compared to double primitive', () {
      expect(SmallInteger(40) <= -20.5, false);
    });

    test('should return false if value is compared to Real', () {
      expect(SmallInteger(40) <= Real(-30), false);
    });

    test('should return false if value is compared to DoublePrecision', () {
      expect(SmallInteger(40) <= DoublePrecision(-30), false);
    });

    test('should return false if value is compared to int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(40) <= numeric, false);
    });

    test(
        'should return false if value is compared to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return false if value is compared to float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) <= numeric, false);
    });

    test(
        'should return false if value is compared to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return false if value is compared to fractional Numeric', () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) <= numeric, false);
    });

    test('should return false if value is compared to int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(40) <= decimal, false);
    });

    test(
        'should return false if value is compared to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return false if value is compared to float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(40) <= decimal, false);
    });

    test(
        'should return false if value is compared to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(40) <= decimal, false);
    });

    test('should return false if value is compared to fractional Decimal', () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(40) <= decimal, false);
    });
  });

// Tests if less than or equal to operator comparison works correctly with the first
// operand being negative and the second operand being positive.
//
// This test group evaluates the correctness of the less than or equal to operator
// when used with mixed sign operands across all supported data types in PostgreSQL.
// The primary focus is on verifying the correct result of comparisons and ensuring
// that they execute successfully without errors or unexpected behavior for each
// data type.
//
// A negative value is always less than a positive value. Therefore all tests results
// in true,
//
// Observations:
// - Greater than and equal to tests are excluded from this group because they become
// redundant.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('mixed sign comparison (negative + positive)', () {
    test('should return true if value is compared to BigInteger', () {
      expect(SmallInteger(-40) <= BigInteger(30), true);
    });

    test('should return true if value is compared to Integer', () {
      expect(SmallInteger(-40) <= Integer(30), true);
    });

    test('should return true if value is compared to SmallInteger', () {
      expect(SmallInteger(-40) <= SmallInteger(30), true);
    });

    test('should return true if value is compared to BigSerial', () {
      expect(SmallInteger(-40) <= BigSerial(30), true);
    });

    test('should return true if value is compared to Serial', () {
      expect(SmallInteger(-40) <= Serial(30), true);
    });

    test('should return true if value is compared to SmallSerial', () {
      expect(SmallInteger(-40) <= SmallSerial(30), true);
    });

    test('should return true if value is compared to int primitive', () {
      expect(SmallInteger(-40) <= 30, true);
    });

    test('should return true if value is compared to double primitive', () {
      expect(SmallInteger(-40) <= 20.5, true);
    });

    test('should return true if value is compared to Real', () {
      expect(SmallInteger(-40) <= Real(30), true);
    });

    test('should return true if value is compared to DoublePrecision', () {
      expect(SmallInteger(-40) <= DoublePrecision(30), true);
    });

    test('should return true if value is compared to int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(-40) <= numeric, true);
    });

    test('should return true if value is compared to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(-40) <= numeric, true);
    });

    test('should return true if value is compared to float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(-40) <= numeric, true);
    });

    test(
        'should return true if value is compared to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(-40) <= numeric, true);
    });

    test('should return true if value is compared to fractional Numeric', () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) <= numeric, true);
    });

    test('should return true if value is compared to int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(-40) <= decimal, true);
    });

    test('should return true if value is compared to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(-40) <= decimal, true);
    });

    test('should return true if value is compared to float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(-40) <= decimal, true);
    });

    test(
        'should return true if value is compared to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(-40) <= decimal, true);
    });

    test('should return true if value is compared to fractional Decimal', () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(-40) <= decimal, true);
    });
  });

// Tests if less than or equal to operator comparison works correctly with the first
// operand being zero and the second operand being a positive value.
//
// This test group evaluates the correctness of the less than or equal to operator when
// used with a zero operand and a positive value, respectively, across all supported
// data types in PostgreSQL. The primary focus is on verifying the correct result of
// comparisons and ensuring that they execute successfully without errors or unexpected
// behavior for each data type.
//
// Zero is always less than a positive non-zero value. Therefore, all tests return
// true.
//
// Observations:
// - Greater than and equal to tests are excluded from this group because they become
// redundant.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('zero with positive comparison', () {
    test('should return true if value is compared to BigInteger', () {
      expect(SmallInteger(0) <= BigInteger(30), true);
    });

    test('should return true if value is compared to Integer', () {
      expect(SmallInteger(0) <= Integer(30), true);
    });

    test('should return true if value is compared to SmallInteger', () {
      expect(SmallInteger(0) <= SmallInteger(30), true);
    });

    test('should return true if value is compared to BigSerial', () {
      expect(SmallInteger(0) <= BigSerial(30), true);
    });

    test('should return true if value is compared to Serial', () {
      expect(SmallInteger(0) <= Serial(30), true);
    });

    test('should return true if value is compared to SmallSerial', () {
      expect(SmallInteger(0) <= SmallSerial(30), true);
    });

    test('should return true if value is compared to int primitive', () {
      expect(SmallInteger(0) <= 30, true);
    });

    test('should return true if value is compared to double primitive', () {
      expect(SmallInteger(0) <= 20.5, true);
    });

    test('should return true if value is compared to Real', () {
      expect(SmallInteger(0) <= Real(30), true);
    });

    test('should return true if value is compared to DoublePrecision', () {
      expect(SmallInteger(0) <= DoublePrecision(30), true);
    });

    test('should return true if value is compared to int Numeric', () {
      final numeric = Numeric(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value is compared to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '30');
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value is compared to float Numeric', () {
      final numeric = Numeric(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) <= numeric, true);
    });

    test(
        'should return true if value is compared to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '30.5');
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value is compared to fractional Numeric', () {
      final numeric = Numeric(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value is compared to int Decimal', () {
      final decimal = Decimal(value: '30', precision: 2, scale: 0);
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value is compared to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '30');
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value is compared to float Decimal', () {
      final decimal = Decimal(value: '30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) <= decimal, true);
    });

    test(
        'should return true if value is compared to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '30.5');
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value is compared to fractional Decimal', () {
      final decimal = Decimal(value: '0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) <= decimal, true);
    });
  });

// Tests if less than or equal to operator comparison works correctly with the first
// operand being zero and the second operand being a negative value.
//
// This test group evaluates the correctness of the less than or equal to operator when
// used with a zero operand and a negative value, respectively, across all supported
// data types in PostgreSQL. The primary focus is on verifying the correct result of
// comparisons and ensuring that they execute successfully without errors or unexpected
// behavior for each data type.
//
// Zero is always greater than a negative non-zero value. Therefore, all tests return
// false.
//
// Observations:
// - Less than and equal to tests are excluded from this group because they become
// redundant.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - There are no tests with strings because there is no need to tests lexicographical
// comparison in such scenarios.
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('zero with negative comparison', () {
    test('should return false if value is compared to BigInteger', () {
      expect(SmallInteger(0) <= BigInteger(-30), false);
    });

    test('should return false if value is compared to Integer', () {
      expect(SmallInteger(0) <= Integer(-30), false);
    });

    test('should return false if value is compared to SmallInteger', () {
      expect(SmallInteger(0) <= SmallInteger(-30), false);
    });

    test('should return false if value is compared to int primitive', () {
      expect(SmallInteger(0) <= -30, false);
    });

    test('should return false if value is compared to double primitive', () {
      expect(SmallInteger(0) <= -20.5, false);
    });

    test('should return false if value is compared to Real', () {
      expect(SmallInteger(0) <= Real(-30), false);
    });

    test('should return false if value is compared to DoublePrecision', () {
      expect(SmallInteger(0) <= DoublePrecision(-30), false);
    });

    test('should return false if value is compared to int Numeric', () {
      final numeric = Numeric(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(0) <= numeric, false);
    });

    test(
        'should return false if value is compared to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '-30');
      expect(SmallInteger(0) <= numeric, false);
    });

    test('should return false if value is compared to float Numeric', () {
      final numeric = Numeric(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) <= numeric, false);
    });

    test(
        'should return false if value is compared to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '-30.5');
      expect(SmallInteger(0) <= numeric, false);
    });

    test('should return false if value is compared to fractional Numeric', () {
      final numeric = Numeric(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) <= numeric, false);
    });

    test('should return false if value is compared to int Decimal', () {
      final decimal = Decimal(value: '-30', precision: 2, scale: 0);
      expect(SmallInteger(0) <= decimal, false);
    });

    test(
        'should return false if value is compared to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '-30');
      expect(SmallInteger(0) <= decimal, false);
    });

    test('should return false if value is compared to float Decimal', () {
      final decimal = Decimal(value: '-30.5', precision: 3, scale: 1);
      expect(SmallInteger(0) <= decimal, false);
    });

    test(
        'should return false if value is compared to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '-30.5');
      expect(SmallInteger(0) <= decimal, false);
    });

    test('should return false if value is compared to fractional Decimal', () {
      final decimal = Decimal(value: '-0.35', precision: 2, scale: 2);
      expect(SmallInteger(0) <= decimal, false);
    });
  });

// Tests if less than or equal to operator works correctly with zero operands.
//
// This test group evaluates the correctness of the less than or equal to operator
// when used with zero operands across all supported data types in PostgreSQL. The
// primary focus is on verifying the correct result of comparisons and ensuring
// that they execute successfully without errors or unexpected behavior for each data type.
//
// Zero is always equal to zero. Therefore, all tests return true.
//
// Observations:
// - Less than and greater than tests are excluded from this group because they
// become redundant.
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
//
// - Only one test is conducted for the [fractional arbitrary precision type] because,
// given the operand signs in this test group, an [Integer type] can either be less than
// or greater than it. It is mathematically impossible for an [Integer type] to equate
// to any [fractional] value.
  group('zero with zero comparison', () {
    test('should return true if value compared to BigInteger', () {
      expect(SmallInteger(0) <= BigInteger(0), true);
    });

    test('should return true if value compared to Integer', () {
      expect(SmallInteger(0) <= Integer(0), true);
    });

    test('should return true if value compared to SmallInteger', () {
      expect(SmallInteger(0) <= SmallInteger(0), true);
    });

    test('should return true if value compared to int primitive', () {
      expect(SmallInteger(0) <= 0, true);
    });

    test('should return true if value compared to double primitive', () {
      expect(SmallInteger(0) <= 0, true);
    });

    test('should return true if value compared to Real', () {
      expect(SmallInteger(0) <= Real(0), true);
    });

    test('should return true if value compared to DoublePrecision', () {
      expect(SmallInteger(0) <= DoublePrecision(0), true);
    });

    test('should return true if value compared to int Numeric', () {
      final numeric = Numeric(value: '0', precision: 2, scale: 0);
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value compared to unconstrained int Numeric',
        () {
      final numeric = Numeric(value: '0');
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value compared to float Numeric', () {
      final numeric = Numeric(value: '0.0', precision: 3, scale: 1);
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value compared to unconstrained float Numeric',
        () {
      final numeric = Numeric(value: '0.0');
      expect(SmallInteger(0) <= numeric, true);
    });

    test('should return true if value compared to int Decimal', () {
      final decimal = Decimal(value: '0', precision: 2, scale: 0);
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value compared to unconstrained int Decimal',
        () {
      final decimal = Decimal(value: '0');
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value compared to float Decimal', () {
      final decimal = Decimal(value: '0.0', precision: 3, scale: 1);
      expect(SmallInteger(0) <= decimal, true);
    });

    test('should return true if value compared to unconstrained float Decimal',
        () {
      final decimal = Decimal(value: '0.0');
      expect(SmallInteger(0) <= decimal, true);
    });
  });

  group('general errors', () {
    test('should throw ArgumentError if compared to an unsupported value', () {
      expect(() => SmallInteger(20) <= DateTime(2022), throwsArgumentError);
    });
  });
}
