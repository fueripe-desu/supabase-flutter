import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

// Glossary:
//
// "arbitrary precision type" -> Refers to a Numeric or a Decimal.
//
// "arbitrary precision type with negative scale" -> Refers to a
// [Numeric with negative scale] or a [Decimal with negative scale].
//
// "Decimal with negative scale" -> Same as [Numeric with negative scale] but for
// a {Decimal}.
//
// "float" -> Refers to a value that contains a floating point. This term is
// generally used to describe a [float Numeric] or a [float Decimal], but it can
// also refer to other floating point types like [Real] and [DoublePrecision], or
// even Dart's {double} primitive.
//
// "float Decimal" -> Same as [float Numeric] but for a {Decimal}.
//
// "float Numeric" -> Refers to a {Numeric} that has a {scale} greater than 0 and
// less than {precision}, meaning its {value} contains a fractional part and an
// integer part. For example:
//
// Numeric(value: '3.14', precision: 3, scale: 2)
//
// The {Numeric} cited in the example above has a {value} of 3.14, in which contains
// an integer part (3) and a fractional part (0.14).
//
// "float zero Numeric" -> Refers to a [float Numeric] with the value of zero.
//
// "float zero Decimal" -> Refers to a [float Decimal] with the value of zero.
//
// "floating point types" -> Refers to a {Real} or a {DoublePrecision}, and less
// commonly to Dart's {double} primitive.
//
// "fractional" -> Refers to a value that has or represents a decimal part. This term
// is generally used to describe a [fractional Numeric], [fractional Decimal],
// [fractional Real], [fractional DoublePrecision] or a [fractional double].
//
// "fractional arbitrary precision type" -> Refers to a [fractional Numeric] or a
// [fractional Decimal].
//
// "fractional double" -> Refers to a {double} that has a fractional part other than
// '.0'. For example, 10.3, 40.8, 123.5
//
// "fractional DoublePrecision" -> Refers to a {DoublePrecision} with a
// [fractional double] as value.
//
// "fractional floating point type" -> Refers to a {Real} or a {DoublePrecision} that
// has a [fractional double] as value.
//
// "fractional Numeric" -> Refers to a {Numeric} that has {precision} equal to {scale},
// meaning it contains a {value} between 0 and 1 that does not have an integer part,
// it also contains a placeholder 0 that is not counted as significant digit.
// For example:
//
// Numeric(value: '0.35', precision: 2, scale: 2)
//
// The {Numeric} cited in the example above has a {value} of 0.35, in which the 0 is
// just a placeholder and is not counted as digit, so it represents a "null" integer
// part, and 0.35 as the fractional part.
//
// "fractional Real" -> Refers to a {Real} with a [fractional double] as value.
//
// "int Decimal" -> Same as [int Numeric] but for a {Decimal}.
//
// "int Numeric" -> Refers to a {Numeric} that has {scale} 0, meaning it contains a
// {value} without a decimal point. For example:
//
// Numeric(value '10', precision: 2, scale: 0)
//
// The {Numeric} cited in the example above has a {value} of 10, in which does not
// have a fractional part, and {scale} is 0 assuring {value} is an integer.
//
// "int zero Decimal" -> Refers to an [int Decimal] with the value of zero.
//
// "int zero Numeric" -> Refers to an [int Numeric] with the value of zero.
//
// "Integer type" -> Refers to any of the types that derive from {Integer}. For
// example, {BigInteger}, {Integer}, {SmallInteger}, {BigSerial}, {Serial},
// {SmallSerial}.
//
// "integer-valued double" -> A {double} that ends in '.0', therefore representing
// a value without a decimal part. For example, 10.0, 40.0, 123.0
//
// "integer-valued DoublePrecision" -> Refers to a {DoublePrecision} with an
// [integer-valued double] as value.
//
// "integer-valued Real" -> Refers to a {Real} with an [integer-valued double] as
// value.
//
// "Numeric with negative scale" -> Refers to a {Numeric} that has a {scale} less
// than 0, meaning it will round its {value} to the closest 100, utilizing the
// following calculation: 10 to the power of abs({scale}), and then rounding its
// {value} to the result. For example:
//
// Numeric(value: '2231', precision: 4, scale: -3)
//
// This {Numeric} cited in the example above will be rounded to 2000, because 10
// to the power of abs(-3) is equal to 1000, therefore, if we round 2231 to the
// closest 1000 it will result in 2000.
//
// "Serial type" -> Refers to a value that can be of type {SmallSerial}, {Serial}
// or {BigSerial}.
//
// "unconstrained" -> Refers to a value that has no bounds. This term is generally
// used to describe an [unconstrained Numeric] or an [unconstrained Decimal].
//
// "unconstrained float Decimal" -> Same as [unconstrained float Numeric] but for
// a {Decimal}.
//
// "unconstrained float Numeric" -> Refers to a [float Numeric] that is
// [unconstrained], meaning both {scale} and {precision} are {null}. For example:
//
// Numeric(value: '3.14')
//
// In the {Numeric} cited above, {value} has a decimal part and neither {scale} nor
// {precision} were specified, so they default to {null}.
//
// "unconstrained int Decimal" -> Same as [unconstrained int Numeric] but for a
// {decimal}.
//
// "unconstrained int Numeric" -> Refers to an [int Numeric] that is [unconstrained],
// meaning both {scale} and {precision} are {null}. For example:
//
// Numeric(value: '10')
//
// In the {Numeric} cited above, {value} has no decimal part and neither {scale} nor
// {precision} were specified, so they default to {null}.
//

void main() {
// Tests subtraction where both operands are positive.
//
// This group of tests evaluates the behavior of subtraction operations
// when both operands are positive, across all supported data types, in
// accordance with PostgreSQL's general rules for numeric operations.
//
// The primary focus of these tests is on the resulting value from the
// operation, rather than the final data type; type casting issues are
// addressed in a separate test group within this file.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types] as such
// configurations are infeasible. An [arbitrary precision type] cannot be
// simultaneously [unconstrained] and [fractional]. Attempting this leads to the
// type defaulting to [float] instead of [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> [Fractional]
//   Numeric(value: '3.14', precision: 3, scale: 2) -> [Float]
//   Numeric(value: '0.13') -> [Float], because '0' is treated as a significant digit
//
// - A similar limitation applies to [arbitrary precision types with negative scale],
// as specifying a {scale} inherently constrains the type:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to 1000
//   Numeric(value: '1349') -> [Unconstrained int Numeric] with the {value} of 1349
//
  group('positive subtraction', () {
    test('should correctly subtract BigInteger', () {
      final value1 = BigInteger(30);
      final value2 = BigInteger(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Integer', () {
      final value1 = BigInteger(30);
      final value2 = Integer(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallInteger', () {
      final value1 = BigInteger(30);
      final value2 = SmallInteger(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract BigSerial', () {
      final value1 = BigInteger(30);
      final value2 = BigSerial(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Serial', () {
      final value1 = BigInteger(30);
      final value2 = Serial(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallSerial', () {
      final value1 = BigInteger(30);
      final value2 = SmallSerial(20);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int', () {
      final value1 = BigInteger(30);
      const value2 = 20;
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued double', () {
      final value1 = BigInteger(30);
      const value2 = 20.0;
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional double', () {
      final value1 = BigInteger(30);
      const value2 = 20.5;
      final expected = Real(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued Real', () {
      final value1 = BigInteger(30);
      final value2 = Real(20.0);
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Real', () {
      final value1 = BigInteger(30);
      final value2 = Real(20.5);
      final expected = Real(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued DoublePrecision', () {
      final value1 = BigInteger(30);
      final value2 = DoublePrecision(20.0);
      final expected = DoublePrecision(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional DoublePrecision', () {
      final value1 = BigInteger(30);
      final value2 = DoublePrecision(20.5);
      final expected = DoublePrecision(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '20');
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '20.5');
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Numeric with negative scale', () {
      final value1 = BigInteger(1950);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '950', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '20');
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '20.5');
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Decimal with negative scale', () {
      final value1 = BigInteger(1950);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '950', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests subtraction where both operands are negative.
//
// This test suite examines the correct handling of subtraction operations
// when both operands are negative, across all supported data types. These
// tests are conducted in accordance with PostgreSQL's established rules
// for numeric operations.
//
// The primary focus of these tests is on assessing the resulting value from
// the subtraction, rather than the data type of the result. Issues related
// to type casting are handled separately in another test group within this
// file.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types] as such
// configurations are infeasible. An [arbitrary precision type] cannot be
// simultaneously [unconstrained] and [fractional]. Attempting this leads to the
// type defaulting to [float] instead of [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> [Fractional]
//   Numeric(value: '3.14', precision: 3, scale: 2) -> [Float]
//   Numeric(value: '0.13') -> [Float], because '0' is treated as a significant digit
//
// - A similar limitation applies to [arbitrary precision types with negative scale],
// as specifying a {scale} inherently constrains the type:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to 1000
//   Numeric(value: '1349') -> [Unconstrained int Numeric] with the {value} of 1349
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('negative subtraction', () {
    test('should correctly subtract BigInteger', () {
      final value1 = BigInteger(-50);
      final value2 = BigInteger(-30);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Integer', () {
      final value1 = BigInteger(-50);
      final value2 = Integer(-30);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallInteger', () {
      final value1 = BigInteger(-50);
      final value2 = SmallInteger(-30);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int', () {
      final value1 = BigInteger(-50);
      const value2 = -30;
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued double', () {
      final value1 = BigInteger(-50);
      const value2 = -30.0;
      final expected = Real(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional double', () {
      final value1 = BigInteger(-50);
      const value2 = -30.5;
      final expected = Real(-19.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued Real', () {
      final value1 = BigInteger(-50);
      final value2 = Real(-30.0);
      final expected = Real(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Real', () {
      final value1 = BigInteger(-50);
      final value2 = Real(-30.5);
      final expected = Real(-19.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued DoublePrecision', () {
      final value1 = BigInteger(-50);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional DoublePrecision', () {
      final value1 = BigInteger(-50);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(-19.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Numeric with negative scale', () {
      final value1 = BigInteger(-1950);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-950', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Decimal with negative scale', () {
      final value1 = BigInteger(-1950);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-950', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests subtraction where the first operand is positive and the second is negative.
//
// This group of tests verifies the correct behavior of subtraction operations
// when the first operand is positive and the second is negative. The tests
// ensure compliance with PostgreSQL's general rules across all supported
// data types.
//
// The primary focus of these tests is on the resulting value of the operation,
// rather than the data type of the result. Type casting concerns are addressed
// in a separate test group within this file.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types] as such
// configurations are infeasible. An [arbitrary precision type] cannot be
// simultaneously [unconstrained] and [fractional]. Attempting this leads to the
// type defaulting to [float] instead of [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> [Fractional]
//   Numeric(value: '3.14', precision: 3, scale: 2) -> [Float]
//   Numeric(value: '0.13') -> [Float], because '0' is treated as a significant digit
//
// - A similar limitation applies to [arbitrary precision types with negative scale],
// as specifying a {scale} inherently constrains the type:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to 1000
//   Numeric(value: '1349') -> [Unconstrained int Numeric] with the {value} of 1349
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('mixed sign subtraction (positive + negative)', () {
    test('should correctly subtract BigInteger', () {
      final value1 = BigInteger(50);
      final value2 = BigInteger(-30);
      final expected = BigInteger(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Integer', () {
      final value1 = BigInteger(50);
      final value2 = Integer(-30);
      final expected = BigInteger(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallInteger', () {
      final value1 = BigInteger(50);
      final value2 = SmallInteger(-30);
      final expected = BigInteger(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int', () {
      final value1 = BigInteger(50);
      const value2 = -30;
      final expected = BigInteger(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued double', () {
      final value1 = BigInteger(50);
      const value2 = -30.0;
      final expected = Real(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional double', () {
      final value1 = BigInteger(50);
      const value2 = -30.5;
      final expected = Real(80.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract a integer-valued Real', () {
      final value1 = BigInteger(50);
      final value2 = Real(-30.0);
      final expected = Real(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract a fractional Real', () {
      final value1 = BigInteger(50);
      final value2 = Real(-30.5);
      final expected = Real(80.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract a integer-valued DoublePrecision', () {
      final value1 = BigInteger(50);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(80);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract a fractional DoublePrecision', () {
      final value1 = BigInteger(50);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(80.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '80', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '80', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '80.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '80.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Numeric', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Numeric with negative scale', () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '1050', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '80', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '80', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '80.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '80.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Decimal', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Decimal with negative scale', () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '1050', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests subtraction where the first operand is negative and the second is positive.
//
// This group of tests evaluates the correct behavior of subtraction operations
// when the first operand is negative and the second is positive. These tests
// ensure that the operations adhere to PostgreSQL's general rules across all
// supported data types.
//
// The primary focus of these tests is on the resulting value of the operation,
// rather than the final type; type casting issues are addressed separately
// in another test group within this file.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types] as such
// configurations are infeasible. An [arbitrary precision type] cannot be
// simultaneously [unconstrained] and [fractional]. Attempting this leads to the
// type defaulting to [float] instead of [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> [Fractional]
//   Numeric(value: '3.14', precision: 3, scale: 2) -> [Float]
//   Numeric(value: '0.13') -> [Float], because '0' is treated as a significant digit
//
// - A similar limitation applies to [arbitrary precision types with negative scale],
// as specifying a {scale} inherently constrains the type:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to 1000
//   Numeric(value: '1349') -> [Unconstrained int Numeric] with the {value} of 1349
//
  group('mixed sign subtraction (negative + positive)', () {
    test('should correctly subtract BigInteger', () {
      final value1 = BigInteger(-20);
      final value2 = BigInteger(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Integer', () {
      final value1 = BigInteger(-20);
      final value2 = Integer(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallInteger', () {
      final value1 = BigInteger(-20);
      final value2 = SmallInteger(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract BigSerial', () {
      final value1 = BigInteger(-20);
      final value2 = BigSerial(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract Serial', () {
      final value1 = BigInteger(-20);
      final value2 = Serial(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract SmallSerial', () {
      final value1 = BigInteger(-20);
      final value2 = SmallSerial(30);
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int', () {
      final value1 = BigInteger(-20);
      const value2 = 30;
      final expected = BigInteger(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued double', () {
      final value1 = BigInteger(-20);
      const value2 = 30.0;
      final expected = Real(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional double', () {
      final value1 = BigInteger(-20);
      const value2 = 30.5;
      final expected = Real(-50.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued Real', () {
      final value1 = BigInteger(-20);
      final value2 = Real(30.0);
      final expected = Real(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Real', () {
      final value1 = BigInteger(-20);
      final value2 = Real(30.5);
      final expected = Real(-50.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract integer-valued DoublePrecision', () {
      final value1 = BigInteger(-20);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(-50);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional DoublePrecision', () {
      final value1 = BigInteger(-20);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(-50.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '-50', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '-50', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-50.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '-50.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Numeric with negative scale', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-1050', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract int Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '-50', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained int Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '-50', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract float Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-50.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract unconstrained float Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '-50.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly subtract fractional Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly subtract Decimal with negative scale', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-1050', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtraction of positive operands yields a positive result correctly.
//
// This group of tests confirms that the subtraction of two positive operands
// results in a positive outcome when performed correctly. A positive result
// occurs under the following condition:
//
// The minuend (the number from which another number is subtracted) is greater
// than the subtrahend (the number that is subtracted). For example:
// 10 - 3, because 10 > 3, thus, 10 - 3 = 7, resulting in a positive outcome.
//
// The focus of these tests is on the arithmetic outcome in terms of value and
// sign, rather than data type integrity; type casting concerns are handled
// separately in another test group within this file.
  group('positive result tests (positive + positive)', () {
    test('should return positive value when subtracting BigInteger', () {
      final value1 = BigInteger(40);
      final value2 = BigInteger(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting Integer', () {
      final value1 = BigInteger(40);
      final value2 = Integer(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting SmallInteger', () {
      final value1 = BigInteger(40);
      final value2 = SmallInteger(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting BigSerial', () {
      final value1 = BigInteger(40);
      final value2 = BigSerial(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting Serial', () {
      final value1 = BigInteger(40);
      final value2 = Serial(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting SmallSerial', () {
      final value1 = BigInteger(40);
      final value2 = SmallSerial(30);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int primitive', () {
      final value1 = BigInteger(40);
      const value2 = 30;
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(40);
      const value2 = 30.0;
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional double', () {
      final value1 = BigInteger(40);
      const value2 = 30.5;
      final expected = Real(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(40);
      final value2 = Real(30.0);
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Real', () {
      final value1 = BigInteger(40);
      final value2 = Real(30.5);
      final expected = Real(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(40);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(40);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '0.14', precision: 2, scale: 2);
      final expected = Numeric(value: '39.86', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Numeric',
        () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(2000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '1000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '0.14', precision: 2, scale: 2);
      final expected = Decimal(value: '39.86', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Decimal',
        () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(2000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '1000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtraction of positive operands yields a negative result correctly.
//
// This group of tests checks that subtraction between two positive operands
// can correctly yield a negative result. This occurs only under the following condition:
//
// The minuend (the number from which another number is subtracted) is less than
// the subtrahend (the number that is subtracted). For example:
// 3 - 10, because 3 < 10, therefore, 3 - 10 = -7, resulting in a negative outcome.
//
// The focus of these tests is on the resulting value and sign, rather than the
// final data type; type casting concerns are addressed separately in another
// test group within this file.
//
// Observations:
// - Tests do not cover [fractional arbitrary precision types] for negative results
// as the minuend must be less than the subtrahend to produce such outcomes, and
// creating a situation where a positive integer is less than a positive fractional
// is not possible.
  group('negative result tests (positive + positive)', () {
    test('should return negative value when subtracting BigInteger', () {
      final value1 = BigInteger(30);
      final value2 = BigInteger(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting Integer', () {
      final value1 = BigInteger(30);
      final value2 = Integer(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting SmallInteger', () {
      final value1 = BigInteger(30);
      final value2 = SmallInteger(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting BigSerial', () {
      final value1 = BigInteger(30);
      final value2 = BigSerial(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting Serial', () {
      final value1 = BigInteger(30);
      final value2 = Serial(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting SmallSerial', () {
      final value1 = BigInteger(30);
      final value2 = SmallSerial(40);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int primitive', () {
      final value1 = BigInteger(30);
      const value2 = 40;
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(30);
      const value2 = 40.0;
      final expected = Real(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional double', () {
      final value1 = BigInteger(30);
      const value2 = 40.5;
      final expected = Real(-10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(30);
      final value2 = Real(40.0);
      final expected = Real(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Real', () {
      final value1 = BigInteger(30);
      final value2 = Real(40.5);
      final expected = Real(-10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(30);
      final value2 = DoublePrecision(40.0);
      final expected = DoublePrecision(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(30);
      final value2 = DoublePrecision(40.5);
      final expected = DoublePrecision(-10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '40', precision: 2, scale: 0);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '40');
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Numeric', () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '40.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(30);
      final value2 = Numeric(value: '40.5');
      final expected = Numeric(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(100);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '40', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '40');
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Decimal', () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '40.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(30);
      final value2 = Decimal(value: '40.5');
      final expected = Decimal(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(100);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if positive subtraction yields a zero result correctly.
//
// This group of tests verifies that subtraction between two positive operands
// can correctly yield a zero result. This outcome is only possible when:
//
// The minuend (the number from which another number is subtracted) is equal to
// the subtrahend (the number that is subtracted). For example:
// 10 - 10, because 10 == 10, therefore, 10 - 10 = 0, resulting in a zero outcome.
//
// The focus of these tests is on the resulting value and sign, rather than the
// final data type; type casting is assessed separately in another test group
// within this file.
//
// Observations:
// - There are no tests for [fractional arbitrary precision types] or
// [fractional floating point types] to yield a zero result, as it is not feasible
// to equate these types with integers in a way that results in zero unless their
// fractional part is exactly zero.
  group('zero result tests (positive + positive)', () {
    test('should return zero value when subtracting BigInteger', () {
      final value1 = BigInteger(40);
      final value2 = BigInteger(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting Integer', () {
      final value1 = BigInteger(40);
      final value2 = Integer(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting SmallInteger', () {
      final value1 = BigInteger(40);
      final value2 = SmallInteger(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting BigSerial', () {
      final value1 = BigInteger(40);
      final value2 = BigSerial(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting Serial', () {
      final value1 = BigInteger(40);
      final value2 = Serial(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting SmallSerial', () {
      final value1 = BigInteger(40);
      final value2 = SmallSerial(40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int primitive', () {
      final value1 = BigInteger(40);
      const value2 = 40;
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting double primitive', () {
      final value1 = BigInteger(40);
      const value2 = 40.0;
      final expected = Real(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting integer-valued Real', () {
      final value1 = BigInteger(40);
      final value2 = Real(40.0);
      final expected = Real(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(40);
      final value2 = DoublePrecision(40.0);
      final expected = DoublePrecision(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '40', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '40');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '40.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '40.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return zero value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(1000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '40', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '40');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '40.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '40.0');
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return zero value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(1000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if negative subtraction yields a positive result correctly.
//
// This group of tests verifies that the subtraction of two negative operands
// can yield a positive result correctly. A positive result occurs when:
//
// The minuend (the number from which another number is subtracted) is less negative
// than the subtrahend (the number that is subtracted). For example:
// -3 - (-10), because abs(-3) < abs(-10), thus -3 - (-10) = 7, resulting in a
// positive outcome of 7.
//
// The focus of these tests is on the resulting value and sign, rather than on the
// final data type; type casting issues are addressed separately in another test
// group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('positive result tests (negative + negative)', () {
    test('should return positive value when subtracting BigInteger', () {
      final value1 = BigInteger(-30);
      final value2 = BigInteger(-40);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting Integer', () {
      final value1 = BigInteger(-30);
      final value2 = Integer(-40);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting SmallInteger', () {
      final value1 = BigInteger(-30);
      final value2 = SmallInteger(-40);
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int primitive', () {
      final value1 = BigInteger(-30);
      const value2 = -40;
      final expected = BigInteger(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(-30);
      const value2 = -40.0;
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional double', () {
      final value1 = BigInteger(-30);
      const value2 = -40.5;
      final expected = Real(10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(-30);
      final value2 = Real(-40.0);
      final expected = Real(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Real', () {
      final value1 = BigInteger(-30);
      final value2 = Real(-40.5);
      final expected = Real(10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(-30);
      final value2 = DoublePrecision(-40.0);
      final expected = DoublePrecision(10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(-30);
      final value2 = DoublePrecision(-40.5);
      final expected = DoublePrecision(10.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Numeric', () {
      final value1 = BigInteger(-30);
      final value2 = Numeric(value: '-40', precision: 2, scale: 0);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(-30);
      final value2 = Numeric(value: '-40');
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Numeric', () {
      final value1 = BigInteger(-30);
      final value2 = Numeric(value: '-40.5', precision: 3, scale: 1);
      final expected = Numeric(value: '10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(-30);
      final value2 = Numeric(value: '-40.5');
      final expected = Numeric(value: '10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(-100);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Decimal', () {
      final value1 = BigInteger(-30);
      final value2 = Decimal(value: '-40', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(-30);
      final value2 = Decimal(value: '-40');
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Decimal', () {
      final value1 = BigInteger(-30);
      final value2 = Decimal(value: '-40.5', precision: 3, scale: 1);
      final expected = Decimal(value: '10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(-30);
      final value2 = Decimal(value: '-40.5');
      final expected = Decimal(value: '10.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(-100);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if negative subtraction yields a negative result correctly.
//
// This group of tests verifies that the subtraction of two negative operands
// results in a negative outcome correctly. A negative result occurs when:
//
// The minuend (the number from which another number is subtracted) is more negative
// than the subtrahend (the number that is subtracted). For example:
// -10 - (-3), because abs(-10) > abs(-3), thus -10 - (-3) = -7, resulting in a
// negative outcome of -7.
//
// The focus of these tests is on the resulting value and sign, rather than on the
// final data type; issues related to type casting are addressed separately in another
// test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('negative result tests (negative + negative)', () {
    test('should return negative value when subtracting BigInteger', () {
      final value1 = BigInteger(-40);
      final value2 = BigInteger(-30);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting Integer', () {
      final value1 = BigInteger(-40);
      final value2 = Integer(-30);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting SmallInteger', () {
      final value1 = BigInteger(-40);
      final value2 = SmallInteger(-30);
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int primitive', () {
      final value1 = BigInteger(-40);
      const value2 = -30;
      final expected = BigInteger(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(-40);
      const value2 = -30.0;
      final expected = Real(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional double', () {
      final value1 = BigInteger(-40);
      const value2 = -30.5;
      final expected = Real(-9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(-40);
      final value2 = Real(-30.0);
      final expected = Real(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Real', () {
      final value1 = BigInteger(-40);
      final value2 = Real(-30.5);
      final expected = Real(-9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(-40);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(-10);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(-40);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(-9.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Numeric',
        () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(-1900);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Decimal',
        () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(-1900);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-900', precision: 3, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if negative subtraction yields a zero result correctly.
//
// This test suite checks that subtraction between two negative operands
// correctly yields a zero result. This occurs only when:
//
// The minuend (the number from which another number is subtracted) is exactly
// equal to the subtrahend (the number that is subtracted). For example:
// -10 - (-10), because abs(-10) == abs(-10), thus -10 - (-10) = 0, resulting in a
// zero outcome.
//
// The focus of these tests is on the resulting value and sign, rather than on the
// final data type; type casting issues are handled separately in another test
// group within this file.
//
// Observations:
// - There are no tests for [fractional arbitrary precision types] or
// [fractional floating point types] to yield a zero result, as it is not feasible
// to equate these types with integers in a way that results in zero unless their
// fractional part is exactly zero.
//
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store zero values.
  group('zero result tests (negative + negative)', () {
    test('should return zero value when subtracting BigInteger', () {
      final value1 = BigInteger(-40);
      final value2 = BigInteger(-40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting Integer', () {
      final value1 = BigInteger(-40);
      final value2 = Integer(-40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting SmallInteger', () {
      final value1 = BigInteger(-40);
      final value2 = SmallInteger(-40);
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int primitive', () {
      final value1 = BigInteger(-40);
      const value2 = -40;
      final expected = BigInteger(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting integer-valued double', () {
      final value1 = BigInteger(-40);
      const value2 = -40.0;
      final expected = Real(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting integer-valued Real', () {
      final value1 = BigInteger(-40);
      final value2 = Real(-40.0);
      final expected = Real(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(-40);
      final value2 = DoublePrecision(-40.0);
      final expected = DoublePrecision(0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-40', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-40');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-40.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '-40.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return zero value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(-1000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting int Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-40', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-40');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '40.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero value when subtracting float Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '-40.0');
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return zero value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(-1000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtraction where the first operand is positive and the
// second is negative yields a positive result correctly.
//
// This group of tests confirms that subtracting a negative value from
// a positive value consistently results in a positive outcome. This
// occurs because subtracting a negative is mathematically equivalent
// to adding its positive counterpart:
//
// For example, 5 - (-3) calculates as 5 + 3, resulting in 8 -> 8 is
// a positive value.
//
// The focus of these tests is on the resulting value and sign, not on
// the final data type; type casting considerations are addressed
// separately in another test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store zero values.
  group('positive result tests (positive + negative)', () {
    test('should return positive value when subtracting BigInteger', () {
      final value1 = BigInteger(40);
      final value2 = BigInteger(-30);
      final expected = BigInteger(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting Integer', () {
      final value1 = BigInteger(40);
      final value2 = Integer(-30);
      final expected = BigInteger(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting SmallInteger', () {
      final value1 = BigInteger(40);
      final value2 = SmallInteger(-30);
      final expected = BigInteger(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int primitive', () {
      final value1 = BigInteger(40);
      const value2 = -30;
      final expected = BigInteger(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(40);
      const value2 = -30.0;
      final expected = Real(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional double', () {
      final value1 = BigInteger(40);
      const value2 = -30.5;
      final expected = Real(70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(40);
      final value2 = Real(-30.0);
      final expected = Real(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Real', () {
      final value1 = BigInteger(40);
      final value2 = Real(-30.5);
      final expected = Real(70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(40);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(40);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Numeric', () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(40);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Numeric',
        () {
      final value1 = BigInteger(50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(2000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '3000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting int Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting float Decimal', () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(40);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when subtracting fractional Decimal',
        () {
      final value1 = BigInteger(50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should return positive value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(2000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '3000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtraction where the first operand is negative and the
// second is positive yields a negative result correctly.
//
// This group of tests verifies that subtracting a positive value from
// a negative value results in a deeper negative outcome. This occurs
// consistently across different scenarios where the operands have
// distinct signs. For example:
//
// -5 - 3 = -8 -> The result, -8, confirms the expected negative value.
//
// The primary focus of these tests is on the resulting value and sign,
// rather than on the final data type; type casting issues are addressed
// separately in another test group within this file.
  group('negative result tests (negative + positive)', () {
    test('should return negative value when subtracting BigInteger', () {
      final value1 = BigInteger(-40);
      final value2 = BigInteger(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting Integer', () {
      final value1 = BigInteger(-40);
      final value2 = Integer(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting SmallInteger', () {
      final value1 = BigInteger(-40);
      final value2 = SmallInteger(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting BigSerial', () {
      final value1 = BigInteger(-40);
      final value2 = BigSerial(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting Serial', () {
      final value1 = BigInteger(-40);
      final value2 = Serial(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting SmallSerial', () {
      final value1 = BigInteger(-40);
      final value2 = SmallSerial(30);
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int primitive', () {
      final value1 = BigInteger(-40);
      const value2 = 30;
      final expected = BigInteger(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued double',
        () {
      final value1 = BigInteger(-40);
      const value2 = 30.0;
      final expected = Real(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional double', () {
      final value1 = BigInteger(-40);
      const value2 = 30.5;
      final expected = Real(-70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting integer-valued Real',
        () {
      final value1 = BigInteger(-40);
      final value2 = Real(30.0);
      final expected = Real(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Real', () {
      final value1 = BigInteger(-40);
      final value2 = Real(30.5);
      final expected = Real(-70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting integer-valued DoublePrecision',
        () {
      final value1 = BigInteger(-40);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(-70);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting fractional DoublePrecision',
        () {
      final value1 = BigInteger(-40);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(-70.5);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '-70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '-70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Numeric', () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '-70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Numeric',
        () {
      final value1 = BigInteger(-40);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-40.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when fractional Numeric', () {
      final value1 = BigInteger(-50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Numeric with negative scale',
        () {
      final value1 = BigInteger(-2000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-3000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting int Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '-70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '-70', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting float Decimal', () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '-70.5', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when subtracting fractional Decimal',
        () {
      final value1 = BigInteger(-40);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-40.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when fractional Decimal', () {
      final value1 = BigInteger(-50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should return negative value when subtracting Decimal with negative scale',
        () {
      final value1 = BigInteger(-2000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-3000', precision: 4, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtracting zero from positive or negative values retains
// the original sign and value.
//
// This group of tests verifies that subtracting zero from both positive
// and negative values does not alter the original sign or value. Examples include:
//
// 20 - 0 = 20 -> Positive sign retained
// -20 - 0 = -20 -> Negative sign retained
//
// The focus of these tests is on ensuring the final sign and value are preserved
// when subtracting zero, rather than on the final data type; type casting is
// examined separately in another test group within this file.
//
// Note: Tests include [arbitrary precision types with negative scale], which might
// initially seem unusual. Here's why they're relevant:
//
// Numeric(value: '1231', precision: 4, scale: -8)
//
// With a negative {scale} greater than the number of significant digits, to avoid
// rounding to zero, the absolute value of the negative {scale} should be less than
// the number of digits minus one. For '1231' with 4 digits, {scale} should be at most
// -3, as abs(-3) == (4 - 1). Elevating 10 to the power of abs(-3) results in 1000,
// rounding '1231' to the nearest 1000. However, with a {scale} of -8, elevation to
// 10^abs(-8) = '100000000', rounding '1231' to the nearest '100000000' results in 0.
//
// There are no tests for [Serial types] as their minimum value is 1 and they cannot
// store 0. Additionally, there are no tests for [fractional arbitrary precision types]
// as it is uncommon to set a fractional value precisely to '0.0'.
  group('zero cases', () {
    test('should retain positive sign when subtracting BigInteger', () {
      final value1 = BigInteger(20);
      final value2 = BigInteger(0);
      final expected = BigInteger(20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting BigInteger', () {
      final value1 = BigInteger(-20);
      final value2 = BigInteger(0);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting Integer', () {
      final value1 = BigInteger(20);
      final value2 = Integer(0);
      final expected = BigInteger(20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting Integer', () {
      final value1 = BigInteger(-20);
      final value2 = Integer(0);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting SmallInteger', () {
      final value1 = BigInteger(20);
      final value2 = SmallInteger(0);
      final expected = BigInteger(20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting SmallInteger', () {
      final value1 = BigInteger(-20);
      final value2 = SmallInteger(0);
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting int primitive', () {
      final value1 = BigInteger(20);
      const value2 = 0;
      final expected = BigInteger(20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting int primitive', () {
      final value1 = BigInteger(-20);
      const value2 = 0;
      final expected = BigInteger(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting double', () {
      final value1 = BigInteger(20);
      const value2 = 0.0;
      final expected = Real(20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting double', () {
      final value1 = BigInteger(-20);
      const value2 = 0.0;
      final expected = Real(-20);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting int Numeric', () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting int Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when subtracting unconstrained int Numeric',
        () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting float Numeric', () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting float Numeric', () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when subtracting unconstrained float Numeric',
        () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when subtracting positive Numeric with negative scale greater than its value',
        () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when subtracting positive Numeric with negative scale greater than its value',
        () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when subtracting negative Numeric with negative scale greater than its value',
        () {
      final value1 = BigInteger(20);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when subtracting negative Numeric with negative scale greater than its value',
        () {
      final value1 = BigInteger(-20);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting int Decimal', () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting int Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '0');
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when subtracting unconstrained int Decimal',
        () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '0');
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when subtracting float Decimal', () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Decimal(value: '20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when subtracting float Decimal', () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Decimal(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '0.0');
      final expected = Decimal(value: '20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when subtracting unconstrained float Decimal',
        () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '0.0');
      final expected = Decimal(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when subtracting positive Decimal with negative scale greater than its value',
        () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when subtracting positive Decimal with negative scale greater than its value',
        () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when subtracting negative Decimal with negative scale greater than its value',
        () {
      final value1 = BigInteger(20);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when subtracting negative Decimal with negative scale greater than its value',
        () {
      final value1 = BigInteger(-20);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 - value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if subtraction with operands of different types correctly casts
// both operands and returns the expected final type.
//
// This group of tests verifies that type casting functions properly when
// operands of different types are used in subtraction. The tests ensure
// that the operation conforms to expected type behavior, with a focus on
// the final data type rather than the arithmetic value. Subtraction values
// are evaluated for correctness in other test groups within this file.
//
// Observations:
// - The value 1 is used in most operations instead of 0, accommodating
// the minimum value constraint of [Serial types], which is 1.
  group('type casting', () {
    test('should return BigInteger as result when subtracting BigInteger', () {
      final value1 = BigInteger(1);
      final value2 = BigInteger(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test(
        'should return BigInteger as result when subtracting negative BigInteger',
        () {
      final value1 = BigInteger(1);
      final value2 = BigInteger(-1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting Integer', () {
      final value1 = BigInteger(1);
      final value2 = Integer(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting negative Integer',
        () {
      final value1 = BigInteger(1);
      final value2 = Integer(-1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting SmallInteger',
        () {
      final value1 = BigInteger(1);
      final value2 = SmallInteger(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test(
        'should return BigInteger as result when subtracting negative SmallInteger',
        () {
      final value1 = BigInteger(1);
      final value2 = SmallInteger(-1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting BigSerial', () {
      final value1 = BigInteger(1);
      final value2 = BigSerial(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting Serial', () {
      final value1 = BigInteger(1);
      final value2 = Serial(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting SmallSerial', () {
      final value1 = BigInteger(1);
      final value2 = SmallSerial(1);
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when subtracting int primitive',
        () {
      final value1 = BigInteger(1);
      const value2 = 1;
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test(
        'should return BigInteger as result when subtracting negative int primitive',
        () {
      final value1 = BigInteger(1);
      const value2 = -1;
      final operation = value1 - value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return Real as result when subtracting double primitive', () {
      final value1 = BigInteger(1);
      const value2 = 1.5;
      final operation = value1 - value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when subtracting negative double primitive',
        () {
      final value1 = BigInteger(1);
      const value2 = -1.5;
      final operation = value1 - value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when subtracting Real', () {
      final value1 = BigInteger(1);
      final value2 = Real(1);
      final operation = value1 - value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when subtracting negative Real', () {
      final value1 = BigInteger(1);
      final value2 = Real(-1);
      final operation = value1 - value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return DoublePrecision as result when subtracting DoublePrecision',
        () {
      final value1 = BigInteger(1);
      final value2 = DoublePrecision(1);
      final operation = value1 - value2;
      expect(operation, isA<DoublePrecision>());
    });

    test(
        'should return DoublePrecision as result when subtracting negative DoublePrecision',
        () {
      final value1 = BigInteger(1);
      final value2 = DoublePrecision(-1);
      final operation = value1 - value2;
      expect(operation, isA<DoublePrecision>());
    });

    test('should return Numeric as result when subtracting Numeric', () {
      final value1 = BigInteger(1);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when subtracting negative Numeric',
        () {
      final value1 = BigInteger(1);
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Decimal as result when subtracting Decimal', () {
      final value1 = BigInteger(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation, isA<Decimal>());
    });

    test('should return Decimal as result when subtracting negative Decimal',
        () {
      final value1 = BigInteger(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 - value2;
      expect(operation, isA<Decimal>());
    });
  });

// Tests if subtraction throws a RangeError when the result value
// overflows or underflows.
//
// This group of tests checks correct error handling for overflow and
// underflow in subtraction operations across all supported data types.
// These operations adhere to PostgreSQL's numeric types range
// documentation, available at:
// https://www.postgresql.org/docs/current/datatype-numeric.html
//
// Subtraction can lead to overflow or underflow in two main scenarios:
//
// 1. Subtracting two values of the same type where the result exceeds
//    the range. Without a larger type available for casting, the result
//    cannot be accommodated. Examples include:
//    - BigInteger(BigInteger.minValue) - BigInteger(20)
//    - BigInteger(BigInteger.maxValue) - BigInteger(-20)
//
// 2. When the largest operand in the subtraction exceeds its range and
//    no larger type exists for casting. For example:
//    - Integer(Integer.minValue) - SmallInteger(20) -> SmallInteger is
//      cast to Integer.
//    - Integer(Integer.maxValue) - SmallInteger(-20)
//    - SmallInteger(30) - Integer(Integer.maxValue)
//    - SmallInteger(-30) - Integer(Integer.minValue)
//
// Situations where overflow or underflow will not occur:
//
// 1. When the smallest type can be cast to a larger type to prevent
//    overflow:
//    - SmallInteger(SmallInteger.maxValue) - Integer(-20)
//      Here, SmallInteger is cast to Integer, which has greater
//      precision, preventing overflow.
//
// 2. When one of the operands is a floating point or Numeric type,
//    which generally have a larger range:
//    - BigInteger(BigInteger.maxValue) - Real(-20.5)
//      Here, BigInteger is cast to Real to accommodate the fractional
//      part, thus preventing overflow due to Real's larger range.
//
// The primary focus of these tests is on the type of error (e.g., RangeError)
// that is thrown, rather than on the value or type. Subtraction in various
// scenarios and type casting are explored in other test groups within this file.
  group('overflow and underflow errors', () {
    test('should throw RangeError if subtracting BigInteger underflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = BigInteger(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting BigInteger overflows', () {
      final value1 = BigInteger(BigInteger.maxValue);
      final value2 = BigInteger(-20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting Integer overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = Integer(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting Integer underflows', () {
      final value1 = BigInteger(BigInteger.maxValue);
      final value2 = Integer(-20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting SmallInteger overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = SmallInteger(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting SmallInteger underflows', () {
      final value1 = BigInteger(BigInteger.maxValue);
      final value2 = SmallInteger(-20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting BigSerial overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = BigSerial(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting Serial overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = Serial(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting SmallSerial overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      final value2 = SmallSerial(20);
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting int primitive overflows', () {
      final value1 = BigInteger(BigInteger.minValue);
      const value2 = 20;
      expect(() => value1 - value2, throwsRangeError);
    });

    test('should throw RangeError if subtracting int primitive underflows', () {
      final value1 = BigInteger(BigInteger.maxValue);
      const value2 = -20;
      expect(() => value1 - value2, throwsRangeError);
    });

    test(
        'should throw RangeError if double primitive subtraction result is too large for Real',
        () {
      final value1 = BigInteger(BigInteger.minValue);
      const value2 = 3.40282347e+39;
      expect(() => value1 - value2, throwsRangeError);
    });

    test(
        'should throw RangeError if double primitive subtraction result is too small for Real',
        () {
      final value1 = BigInteger(BigInteger.maxValue);
      const value2 = -3.40282347e+39;
      expect(() => value1 - value2, throwsRangeError);
    });
  });
}
