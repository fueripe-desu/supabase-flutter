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
// "float arbitrary precision types" -> Refers to a [float Numeric] or a [float Decimal].
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
// "int arbitrary precision type" -> Refers to an [int Numeric] or an [int Decimal].
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
// Tests modulo where both operands are positive.
//
// This group of tests ensures correct behavior of modulo operations
// when both operands are positive, across all supported data types,
// adhering to PostgreSQL's general rules.
//
// PostgreSQL and many programming languages use the remainder operation
// for modulo. Unlike the Euclidean modulo which requires non-negative
// values, the remainder operation uses the sign of the dividend.
//
// A modulo operation with a positive dividend always results in a positive
// value. For example:
//
// 10 % 3 = 1 -> 1 is a positive value
//
// Unlike integer division, a modulo operation may not always return a value of
// [Integer type]. This is because type casting occurs, converting the type with
// less precision to a type with more precision.
//
// Observations:
// - No tests for [unconstrained] [fractional arbitrary types] as it's impossible
//   for an [arbitrary precision type] to be both [unconstrained] and [fractional].
//   Attempting such leads to the {value} becoming a [float] instead of a [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
//   Numeric(value: '3.14', precision: 3, scale: 2) -> Float
//   Numeric(value: '0.13') -> Float, because '0' is treated as significant
//
// - Similarly, [arbitrary precision types with negative scale] are excluded because
//   defining them requires a {scale}, making [unconstrained] configurations impossible:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with value '1349'
  group('positive modulo', () {
    test('should correctly perform modulo with BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Integer', () {
      final value1 = Real(30);
      final value2 = Integer(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with BigSerial', () {
      final value1 = Real(30);
      final value2 = BigSerial(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Serial', () {
      final value1 = Real(30);
      final value2 = Serial(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallSerial', () {
      final value1 = Real(30);
      final value2 = SmallSerial(4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int', () {
      final value1 = Real(30);
      const value2 = 4;
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued double', () {
      final value1 = Real(30);
      const value2 = 4.0;
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional double', () {
      final value1 = Real(30);
      const value2 = 4.5;
      final expected = Real(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued Real', () {
      final value1 = Real(30);
      final value2 = Real(4.0);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Real', () {
      final value1 = Real(30);
      final value2 = Real(4.5);
      final expected = Real(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued DoublePrecision',
        () {
      final value1 = Real(30);
      final value2 = DoublePrecision(4.0);
      final expected = DoublePrecision(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(4.5);
      final expected = DoublePrecision(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '4', precision: 1, scale: 0);
      final expected = Numeric(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '4');
      final expected = Numeric(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '4.5', precision: 3, scale: 1);
      final expected = Numeric(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '4.5');
      final expected = Numeric(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.7', precision: 1, scale: 1);
      final expected = Numeric(value: '0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Numeric with negative scale',
        () {
      final value1 = Real(3100);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '4', precision: 1, scale: 0);
      final expected = Decimal(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '4');
      final expected = Decimal(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '4.5', precision: 2, scale: 1);
      final expected = Decimal(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '4.5');
      final expected = Decimal(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.7', precision: 1, scale: 1);
      final expected = Decimal(value: '0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Decimal with negative scale',
        () {
      final value1 = Real(3100);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests modulo where both operands are negative.
//
// This group of tests ensures correct behavior of modulo operations
// when both operands are negative, across all supported data types,
// adhering to PostgreSQL's general rules.
//
// PostgreSQL uses the remainder definition for modulo, not the Euclidean modulo,
// which is common in many programming languages. Unlike the Euclidean modulo,
// which requires non-negative values, the remainder takes the sign of the dividend.
//
// A modulo operation results in a negative value if the dividend is negative:
//
// -10 % -3 = -1 -> The result is -1, a negative value
//
// Unlike integer division, a modulo operation may not always return an [Integer type].
// Type casting occurs as usual, converting the type with less precision to one with
// more precision.
//
// Observations:
// - No tests for [Serial types] as their minimum {value} is 1, making them unable
//   to store negative values.
// - No tests for [unconstrained] [arbitrary types with negative scale] because these
//   types require a {scale} to be defined, thus cannot be [unconstrained]:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('negative modulo', () {
    test('should correctly perform modulo with BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(-4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(-4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(-4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int', () {
      final value1 = Real(-30);
      const value2 = -4;
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued double', () {
      final value1 = Real(-30);
      const value2 = -4.0;
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional double', () {
      final value1 = Real(-30);
      const value2 = -4.5;
      final expected = Real(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued Real', () {
      final value1 = Real(-30);
      final value2 = Real(-4.0);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Real', () {
      final value1 = Real(-30);
      final value2 = Real(-4.5);
      final expected = Real(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued DoublePrecision',
        () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-4.0);
      final expected = DoublePrecision(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-4.5);
      final expected = DoublePrecision(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-4', precision: 1, scale: 0);
      final expected = Numeric(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-4');
      final expected = Numeric(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-4.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-4.5');
      final expected = Numeric(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-0.7', precision: 1, scale: 1);
      final expected = Numeric(value: '-0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Numeric with negative scale',
        () {
      final value1 = Real(-3100);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-4', precision: 1, scale: 0);
      final expected = Decimal(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-4');
      final expected = Decimal(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-4.5', precision: 2, scale: 1);
      final expected = Decimal(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-4.5');
      final expected = Decimal(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final expected = Decimal(value: '-0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Decimal with negative scale',
        () {
      final value1 = Real(-3100);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests modulo where the first operand is positive and the second is negative.
//
// This group of tests ensures correct behavior of modulo operations where the
// first operand is positive and the second is negative, across all supported
// data types, following PostgreSQL's general rules.
//
// PostgreSQL uses the remainder definition for modulo, not the Euclidean modulo,
// which is common in many other programming languages. Unlike Euclidean operations
// that require non-negative values, the remainder operation takes the sign of the
// dividend.
//
// A modulo operation results in a positive value if the dividend is positive:
//
// 10 % -3 = 1 -> The result is 1, a positive value
//
// Unlike integer division, a modulo operation may not always return an [Integer type].
// This occurs because type casting normally happens, converting the type with less
// precision to a type with more precision.
//
// Observations:
// - No tests for [Serial types], as their minimum {value} is 1, making it
//   impossible to store negative values.
// - No tests for [unconstrained] [arbitrary types with negative scale] because
//   defining them requires specifying a {scale}, making [unconstrained] configurations
//   unfeasible:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('mixed sign modulo (positive + negative)', () {
    test('should correctly perform modulo with BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(-4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Integer', () {
      final value1 = Real(30);
      final value2 = Integer(-4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(-4);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int', () {
      final value1 = Real(30);
      const value2 = -4;
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued double', () {
      final value1 = Real(30);
      const value2 = -4.0;
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional double', () {
      final value1 = Real(30);
      const value2 = -4.5;
      final expected = Real(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with a integer-valued Real', () {
      final value1 = Real(30);
      final value2 = Real(-4.0);
      final expected = Real(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with a fractional Real', () {
      final value1 = Real(30);
      final value2 = Real(-4.5);
      final expected = Real(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should correctly perform modulo with a integer-valued DoublePrecision',
        () {
      final value1 = Real(30);
      final value2 = DoublePrecision(-4.0);
      final expected = DoublePrecision(2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with a fractional DoublePrecision',
        () {
      final value1 = Real(30);
      final value2 = DoublePrecision(-4.5);
      final expected = DoublePrecision(3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-4', precision: 1, scale: 0);
      final expected = Numeric(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-4');
      final expected = Numeric(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-4.5', precision: 2, scale: 1);
      final expected = Numeric(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-4.5');
      final expected = Numeric(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-0.7', precision: 1, scale: 1);
      final expected = Numeric(value: '0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Numeric with negative scale',
        () {
      final value1 = Real(3100);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-4', precision: 1, scale: 0);
      final expected = Decimal(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-4');
      final expected = Decimal(value: '2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-4.5', precision: 2, scale: 1);
      final expected = Decimal(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-4.5');
      final expected = Decimal(value: '3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final expected = Decimal(value: '0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Decimal with negative scale',
        () {
      final value1 = Real(3100);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests modulo where the first operand is negative and the second is positive.
//
// This group of tests ensures correct behavior of modulo operations
// where the first operand is negative and the second is positive, across
// all supported data types, adhering to PostgreSQL's general rules.
//
// PostgreSQL uses the remainder definition for modulo, not the Euclidean modulo.
// Unlike Euclidean operations that require non-negative values, the remainder
// takes the sign of the dividend.
//
// A modulo operation results in a negative value if the dividend is negative:
//
// -10 % 3 = -1 -> The result is -1, a negative value
//
// Unlike integer division, a modulo operation may not always return an [Integer type].
// Type casting occurs as usual, converting the type with less precision to one with
// more precision.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types] as it's
//   impossible for an [arbitrary precision type] to be both [unconstrained] and
//   [fractional]. If such a configuration is attempted, the {value} becomes a [float]
//   instead of a [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
//   Numeric(value: '3.14', precision: 3, scale: 2) -> Float
//   Numeric(value: '0.13') -> Float, because '0' is treated as a significant digit
//
// - Similar limitations apply to [arbitrary types with negative scale], as defining them
//   requires specifying a {scale}, which makes them inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('mixed sign modulo (negative + positive)', () {
    test('should correctly perform modulo with BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with BigSerial', () {
      final value1 = Real(-30);
      final value2 = BigSerial(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Serial', () {
      final value1 = Real(-30);
      final value2 = Serial(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallSerial', () {
      final value1 = Real(-30);
      final value2 = SmallSerial(4);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int', () {
      final value1 = Real(-30);
      const value2 = 4;
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued double', () {
      final value1 = Real(-30);
      const value2 = 4.0;
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional double', () {
      final value1 = Real(-30);
      const value2 = 4.5;
      final expected = Real(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued Real', () {
      final value1 = Real(-30);
      final value2 = Real(4.0);
      final expected = Real(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Real', () {
      final value1 = Real(-30);
      final value2 = Real(4.5);
      final expected = Real(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with integer-valued DoublePrecision',
        () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(4.0);
      final expected = DoublePrecision(-2);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(4.5);
      final expected = DoublePrecision(-3);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '4', precision: 2, scale: 0);
      final expected = Numeric(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '4');
      final expected = Numeric(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '4.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '4.5');
      final expected = Numeric(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.7', precision: 1, scale: 1);
      final expected = Numeric(value: '-0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Numeric with negative scale',
        () {
      final value1 = Real(-3100);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '4', precision: 1, scale: 0);
      final expected = Decimal(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '4');
      final expected = Decimal(value: '-2', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '4.5', precision: 2, scale: 1);
      final expected = Decimal(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '4.5');
      final expected = Decimal(value: '-3', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.7', precision: 1, scale: 1);
      final expected = Decimal(value: '-0.6', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly perform modulo with Decimal with negative scale',
        () {
      final value1 = Real(-3100);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-100', precision: 3, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of exact integer division will correctly result in zero.
//
// In modulo operations where the equivalent division yields a number without
// decimal places, the modulo result will be zero. For example:
//
// 30 % 2 = 0
//
// Observations:
// - In this test group, only [int arbitrary precision types] and
//   [Integer types] are tested to confirm the correct behavior when
//   the divisor evenly divides the dividend.
  group('integer modulo (exact)', () {
    test('should be able to perform module with BigInteger', () {
      final value1 = Real(50);
      final value2 = BigInteger(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with Integer', () {
      final value1 = Real(50);
      final value2 = Integer(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with SmallInteger', () {
      final value1 = Real(50);
      final value2 = SmallInteger(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with BigSerial', () {
      final value1 = Real(50);
      final value2 = BigSerial(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with Serial', () {
      final value1 = Real(50);
      final value2 = Serial(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with SmallSerial', () {
      final value1 = Real(50);
      final value2 = SmallSerial(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with int primitive', () {
      final value1 = Real(50);
      const value2 = 2;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with int Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with unconstrained int Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with int Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should be able to perform module with unconstrained int Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of fractional integer division will correctly result in the
// remainder.
//
// In modulo operations where the equivalent division yields a number with
// decimal places, the modulo operation produces the remainder of that division.
// For example:
//
// 5 % 2 = 1
//
// Observations:
// - This test group is limited to [int arbitrary precision types] and
//   [Integer types] to confirm the correct handling of remainders in
//   fractional divisions.
  group('integer modulo (fractional)', () {
    test('should correctly perform modulo with BigInteger', () {
      final value1 = Real(5);
      final value2 = BigInteger(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Integer', () {
      final value1 = Real(5);
      final value2 = Integer(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallInteger', () {
      final value1 = Real(5);
      final value2 = SmallInteger(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with BigSerial', () {
      final value1 = Real(5);
      final value2 = BigSerial(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Serial', () {
      final value1 = Real(5);
      final value2 = Serial(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with SmallSerial', () {
      final value1 = Real(5);
      final value2 = SmallSerial(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int primitive', () {
      final value1 = Real(5);
      const value2 = 2;
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with int Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained int Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2');
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of exact floating point division, where the first
// operand is of [Integer type] and the second is an [integer-valued]
// [floating point type], will correctly result in zero.
//
// In modulo operations where the equivalent division results in a number
// without decimal places, the modulo outcome will be zero. For example:
//
// 50 % 2.0 = 0
//
// Observations:
// - This test group focuses exclusively on [float arbitrary precision types]
//   and [floating point types] to validate correct modulo results when
//   division yields no fractional part.
  group('integer-valued floating point modulo (exact)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(50);
      const value2 = 2.0;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(50);
      final value2 = Real(2);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(50);
      final value2 = DoublePrecision(2);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2.0');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2.0');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of fractional floating point division, where the
// first operand is of [Integer type] and the second is an
// [integer-valued] [floating point type], will correctly result in the
// remainder.
//
// In modulo operations where the equivalent division yields a number with
// decimal places, the modulo result is the remainder of that division.
// For example:
//
// 5 % 2.0 = 1
//
// Observations:
// - This test group is limited to [float arbitrary precision types] and
//   [floating point types] to ensure accurate handling of remainders in
//   fractional divisions.
  group('integer-valued floating point modulo (fractional)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(5);
      const value2 = 2.0;
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(5);
      final value2 = Real(2);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(5);
      final value2 = DoublePrecision(2);
      final expected = DoublePrecision(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2.0');
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2.0');
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of exact floating point division, where the first
// operand is of [Integer type] and the second is a [floating point type]
// with a mandatory decimal part, will correctly result in zero.
//
// In modulo operations where the equivalent division results in a number
// without decimal places, the modulo outcome will be zero. For example:
//
// 6 % 1.5 = 0
//
// Observations:
// - This test group exclusively tests [float arbitrary precision types] and
//   [floating point types] to verify correct zero results in precise divisions.
  group('fractional floating point modulo (exact)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(6);
      const value2 = 1.5;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(6);
      final value2 = Real(1.5);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(6);
      final value2 = DoublePrecision(1.5);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(6);
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(6);
      final value2 = Numeric(value: '1.5');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(6);
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(6);
      final value2 = Decimal(value: '1.5');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of fractional floating point division, where the
// first operand is of [Integer type] and the second is a [floating point type]
// with a mandatory decimal part, will correctly result in the remainder.
//
// In modulo operations where the equivalent division results in a number
// with decimal places, the modulo outcome is the remainder of that division.
// For example:
//
// 7 % 1.5 = 1
//
// Observations:
// - This test group exclusively includes [float arbitrary precision types] and
//   [floating point types] to ensure accurate handling of remainders in
//   fractional divisions.
  group('fractional floating point modulo (fractional)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(7);
      const value2 = 1.5;
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(7);
      final value2 = Real(1.5);
      final expected = Real(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(7);
      final value2 = DoublePrecision(1.5);
      final expected = DoublePrecision(1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Numeric', () {
      final value1 = Real(7);
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Numeric',
        () {
      final value1 = Real(7);
      final value2 = Numeric(value: '1.5');
      final expected = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with float Decimal', () {
      final value1 = Real(7);
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with unconstrained float Decimal',
        () {
      final value1 = Real(7);
      final value2 = Decimal(value: '1.5');
      final expected = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of exact floating point division, where the first
// operand is of [Integer type] and the second is a [fractional] value
// (with only the decimal part), will result in zero correctly.
//
// In modulo operations where the equivalent division results in a number
// without decimal places, the modulo outcome is zero. For example:
//
// 4 % 0.5 = 0
//
// Observations:
// - This test group exclusively includes [fractional arbitrary precision types] and
//   [floating point types] with fractional-only values to verify correct zero results
//   in precise divisions.
  group('fractional only floating point modulo (exact)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(4);
      const value2 = 0.5;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(4);
      final value2 = Real(0.5);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(4);
      final value2 = DoublePrecision(0.5);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(4);
      final value2 = Numeric(value: '0.5', precision: 1, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(4);
      final value2 = Decimal(value: '0.5', precision: 1, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo of fractional floating point division, where the
// first operand is of [Integer type] and the second is a [fractional]
// value (with only the decimal part), will correctly result in the remainder.
//
// In modulo operations where the equivalent division would result in a number
// with decimal places, the modulo operation will produce the remainder of
// that division. For example:
//
// 4 % 0.3 = 0.1
//
// Observations:
// - This test group exclusively tests [fractional arbitrary precision types] and
//   [floating point types] with fractional-only values, ensuring accurate remainder
//   results in fractional divisions.
  group('fractional only floating point modulo (fractional)', () {
    test('should correctly perform modulo with double primitive', () {
      final value1 = Real(4);
      const value2 = 0.3;
      final expected = Real(0.1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with Real', () {
      final value1 = Real(4);
      final value2 = Real(0.3);
      final expected = Real(0.1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with DoublePrecision', () {
      final value1 = Real(4);
      final value2 = DoublePrecision(0.3);
      final expected = DoublePrecision(0.1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Numeric', () {
      final value1 = Real(4);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '0.1', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly perform modulo with fractional Decimal', () {
      final value1 = Real(4);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = Decimal(value: '0.1', precision: 2, scale: 1);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo between a positive non-zero value and zero
// will throw an {ArgumentError}.
//
// In modulo operations, any number mod zero results in an undefined outcome.
// For example:
//
// 10 % 0 = ? -> Undefined
//
// Programming languages address this by throwing an error when a
// modulo by zero is attempted.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] because they cannot meaningfully
//   represent a zero value.
// - No tests for [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero modulo by zero (positive + zero)', () {
    test('should throw ArgumentError if performing modulo by BigInteger zero',
        () {
      final value1 = Real(30);
      final value2 = BigInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Integer zero', () {
      final value1 = Real(30);
      final value2 = Integer(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by SmallInteger zero',
        () {
      final value1 = Real(30);
      final value2 = SmallInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by int zero primitive',
        () {
      final value1 = Real(30);
      const value2 = 0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by double zero primitive',
        () {
      final value1 = Real(30);
      const value2 = 0.0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Real zero', () {
      final value1 = Real(30);
      final value2 = Real(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by DoublePrecision zero',
        () {
      final value1 = Real(30);
      final value2 = DoublePrecision(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.0');
      expect(() => value1 % value2, throwsArgumentError);
    });
  });

// Tests if modulo between a negative non-zero value and zero
// will throw an {ArgumentError}.
//
// In modulo operations, any number mod zero results in an undefined outcome.
// For example:
//
// -10 % 0 = ? -> Undefined
//
// Programming languages typically handle this by throwing an error
// when a modulo by zero is attempted.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] because they cannot represent
//   a zero value in a meaningful way.
// - Also, no tests for [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero modulo by zero (negative + zero)', () {
    test('should throw ArgumentError if performing modulo by BigInteger zero',
        () {
      final value1 = Real(-30);
      final value2 = BigInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Integer zero', () {
      final value1 = Real(-30);
      final value2 = Integer(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by SmallInteger zero',
        () {
      final value1 = Real(-30);
      final value2 = SmallInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by int zero primitive',
        () {
      final value1 = Real(-30);
      const value2 = 0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by double zero primitive',
        () {
      final value1 = Real(-30);
      const value2 = 0.0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Real zero', () {
      final value1 = Real(-30);
      final value2 = Real(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by DoublePrecision zero',
        () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });
  });

// Tests if modulo between a zero and a positive non-zero value
// will return zero.
//
// In modulo operations, zero mod any non-zero number results in zero. For
// example:
//
// 0 % 20 = 0
//
// The example above does not result in an error because the first operand
// is zero. If, instead, the second operand were zero, it would lead to an error.
  group('zero modulo by non-zero (zero + positive)', () {
    test('should return zero if performing modulo by BigInteger', () {
      final value1 = Real(0);
      final value2 = BigInteger(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by Integer', () {
      final value1 = Real(0);
      final value2 = Integer(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by SmallInteger', () {
      final value1 = Real(0);
      final value2 = SmallInteger(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by BigSerial', () {
      final value1 = Real(0);
      final value2 = BigSerial(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by Serial', () {
      final value1 = Real(0);
      final value2 = Serial(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by SmallSerial', () {
      final value1 = Real(0);
      final value2 = SmallSerial(20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int primitive', () {
      final value1 = Real(0);
      const value2 = 20;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by integer-valued double primitive',
        () {
      final value1 = Real(0);
      const value2 = 20.0;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by fractional double primitive',
        () {
      final value1 = Real(0);
      const value2 = 20.5;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by integer-valued Real', () {
      final value1 = Real(0);
      final value2 = Real(20.0);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Real', () {
      final value1 = Real(0);
      final value2 = Real(20.5);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by integer-valued DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(20.0);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by fractional DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(20.5);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by unconstrained int Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by unconstrained float Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20.5');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by unconstrained int Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by unconstrained float Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20.5');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo between a zero and a negative non-zero value
// will return zero.
//
// In modulo operations, zero mod any non-zero number results in zero. For
// example:
//
// 0 % -20 = 0
//
// The example above does not result in an error because the first operand
// is zero. If, however, the second operand were zero, it would lead to an error.
//
// Observations:
// - No tests for [Serial types] since their minimum {value} is 1, and they
//   cannot store 0 as a value.
  group('zero modulo by non-zero (zero + negative)', () {
    test('should return zero if performing modulo by BigInteger', () {
      final value1 = Real(0);
      final value2 = BigInteger(-20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by Integer', () {
      final value1 = Real(0);
      final value2 = Integer(-20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by SmallInteger', () {
      final value1 = Real(0);
      final value2 = SmallInteger(-20);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int primitive', () {
      final value1 = Real(0);
      const value2 = -20;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by integer-valued double primitive',
        () {
      final value1 = Real(0);
      const value2 = -20.0;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by fractional double primitive',
        () {
      final value1 = Real(0);
      const value2 = -20.5;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by integer-valued Real', () {
      final value1 = Real(0);
      final value2 = Real(-20.0);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Real', () {
      final value1 = Real(0);
      final value2 = Real(-20.5);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by integer-valued DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(-20.0);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by fractional DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(-20.5);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by unconstrained int Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by unconstrained float Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20.5');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-0.7', precision: 1, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by unconstrained int Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20.5', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero if performing modulo by unconstrained float Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20.5');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if performing modulo by fractional Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-0.7', precision: 1, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo between two zero values will throw an {ArgumentError}.
//
// In modulo operations, zero mod zero is undefined. For example:
//
// 0 % 0 = ? -> Undefined
//
// Programming languages typically handle this scenario by throwing an error
// when an attempt is made to perform modulo by zero.
//
// Observations:
// - There are no tests for [fractional arbitrary types] because they cannot
//   meaningfully represent a zero value.
// - No tests for [Serial types] since their minimum {value} is 1, and thus
//   they cannot store 0 as a value.
  group('zero modulo by zero', () {
    test('should throw ArgumentError if performing modulo by BigInteger zero',
        () {
      final value1 = Real(0);
      final value2 = BigInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Integer zero', () {
      final value1 = Real(0);
      final value2 = Integer(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by SmallInteger zero',
        () {
      final value1 = Real(0);
      final value2 = SmallInteger(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by int primitive zero',
        () {
      final value1 = Real(0);
      const value2 = 0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by double primitive zero',
        () {
      final value1 = Real(0);
      const value2 = 0.0;
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by Real zero', () {
      final value1 = Real(0);
      final value2 = Real(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by DoublePrecision zero',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test('should throw ArgumentError if performing modulo by int zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained int zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0');
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by float zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 % value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if performing modulo by unconstrained float zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.0');
      expect(() => value1 % value2, throwsArgumentError);
    });
  });

// Tests if modulo between a positive non-zero value and a positive one
// will return zero.
//
// In modulo operations, any value mod one results in zero. For example:
//
// 20 % 1 = 0
//
// Observations:
// - There are no tests for [fractional floating point] as they cannot
//   represent an [Integer value]. Similarly, there are no tests for
//   [fractional arbitrary types] because they cannot represent an
//   [Integer type].
  group('modulo by one', () {
    test('should return zero when performing modulo by BigInteger one', () {
      final value1 = Real(30);
      final value2 = BigInteger(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Integer one', () {
      final value1 = Real(30);
      final value2 = Integer(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by SmallInteger one', () {
      final value1 = Real(30);
      final value2 = SmallInteger(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by BigSerial one', () {
      final value1 = Real(30);
      final value2 = BigSerial(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Serial one', () {
      final value1 = Real(30);
      final value2 = Serial(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by SmallSerial one', () {
      final value1 = Real(30);
      final value2 = SmallSerial(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Real one', () {
      final value1 = Real(30);
      final value2 = Real(1);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by DoublePrecision one',
        () {
      final value1 = Real(30);
      final value2 = DoublePrecision(1);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Numeric one', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Numeric one',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Numeric one', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Numeric one',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Decimal one', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Decimal one',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Decimal one', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1.0', precision: 2, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Decimal one',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo between a positive non-zero value and itself will return zero.
//
// In modulo operations, any value mod itself results in zero. For example:
//
// 20 % 20 = 0
//
// Observations:
// - There are no tests for [fractional floating point] as they cannot
//   represent an [Integer value]. Similarly, there are no tests for
//   [fractional arbitrary types] because they cannot represent an
//   [Integer type].
  group('modulo by itself (positive)', () {
    test('should return zero when performing modulo by BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Integer', () {
      final value1 = Real(30);
      final value2 = Integer(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by BigSerial', () {
      final value1 = Real(30);
      final value2 = BigSerial(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Serial', () {
      final value1 = Real(30);
      final value2 = Serial(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by SmallSerial', () {
      final value1 = Real(30);
      final value2 = SmallSerial(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int primitive', () {
      final value1 = Real(30);
      const value2 = 30;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by double primitive', () {
      final value1 = Real(30);
      const value2 = 30.0;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Real', () {
      final value1 = Real(30);
      final value2 = Real(30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(30);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if modulo between a negative non-zero value and itself will return zero.
//
// In modulo operations, any value mod itself results in zero. For example:
//
// -20 % -20 = 0
//
// Observations:
// - There are no tests for [fractional floating point] as they cannot
//   represent an [Integer value]. Similarly, there are no tests for
//   [fractional arbitrary types] because they cannot represent an
//   [Integer type].
// - Additionally, no tests involve [Serial types] because their minimum
//   {value} is 1, thus they cannot store negative values.
  group('modulo by itself (negative)', () {
    test('should return zero when performing modulo by BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(-30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(-30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(-30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int primitive', () {
      final value1 = Real(-30);
      const value2 = -30;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by double primitive', () {
      final value1 = Real(-30);
      const value2 = -30.0;
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by Real', () {
      final value1 = Real(-30);
      final value2 = Real(-30);
      final expected = Real(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-30);
      final expected = DoublePrecision(0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained int Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when performing modulo by float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return zero when performing modulo by unconstrained float Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if performing modulo with operands of different types will
// correctly cast both operands and return the final result of the expected type.
//
// This group of tests ensures that type casting functions properly when
// operands are of different types. The focus here is on the final type
// rather than the numerical value. Modulo resulting values are examined
// in other groups within this file.
//
// Observations:
// - 1 is used as the {value} in most operations instead of 0, due to the
//   minimum {value} of [Serial types], which is 1.
  group('type casting', () {
    test('should return Real as result when performing modulo by BigInteger',
        () {
      final value1 = Real(1);
      final value2 = BigInteger(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by negative BigInteger',
        () {
      final value1 = Real(1);
      final value2 = BigInteger(-1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by Integer', () {
      final value1 = Real(1);
      final value2 = Integer(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by negative Integer',
        () {
      final value1 = Real(1);
      final value2 = Integer(-1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by SmallInteger',
        () {
      final value1 = Real(1);
      final value2 = SmallInteger(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by negative SmallInteger',
        () {
      final value1 = Real(1);
      final value2 = SmallInteger(-1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by BigSerial',
        () {
      final value1 = Real(1);
      final value2 = BigSerial(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by Serial', () {
      final value1 = Real(1);
      final value2 = Serial(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by SmallSerial',
        () {
      final value1 = Real(1);
      final value2 = SmallSerial(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by int primitive',
        () {
      final value1 = Real(1);
      const value2 = 1;
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by negative int primitive',
        () {
      final value1 = Real(1);
      const value2 = -1;
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by double primitive',
        () {
      final value1 = Real(1);
      const value2 = 1.5;
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return Real as result when performing modulo by negative double primitive',
        () {
      final value1 = Real(1);
      const value2 = -1.5;
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by Real', () {
      final value1 = Real(1);
      final value2 = Real(1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when performing modulo by negative Real',
        () {
      final value1 = Real(1);
      final value2 = Real(-1);
      final operation = value1 % value2;
      expect(operation, isA<Real>());
    });

    test(
        'should return DoublePrecision as result when performing modulo by DoublePrecision',
        () {
      final value1 = Real(1);
      final value2 = DoublePrecision(1);
      final operation = value1 % value2;
      expect(operation, isA<DoublePrecision>());
    });

    test(
        'should return DoublePrecision as result when performing modulo by negative DoublePrecision',
        () {
      final value1 = Real(1);
      final value2 = DoublePrecision(-1);
      final operation = value1 % value2;
      expect(operation, isA<DoublePrecision>());
    });

    test('should return Numeric as result when performing modulo by Numeric',
        () {
      final value1 = Real(1);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when performing modulo by negative Numeric',
        () {
      final value1 = Real(1);
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Decimal as result when performing modulo by Decimal',
        () {
      final value1 = Real(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation, isA<Decimal>());
    });

    test(
        'should return Decimal as result when performing modulo by negative Decimal',
        () {
      final value1 = Real(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 % value2;
      expect(operation, isA<Decimal>());
    });
  });
}
