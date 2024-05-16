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
// Tests integer division where both operands are positive.
//
// This group of tests ensures correct behavior of integer division
// operations when both operands are positive. The tests verify the
// operation's behavior across all supported data types, adhering to
// PostgreSQL's general rules.
//
// In integer division, the result is always positive if both operands
// are positive. Unlike regular division, integer division consistently
// returns an {Integer type}. If the result is too large to be stored
// in an {Integer type}, an error will be thrown.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types]
//   because it is impossible. An [arbitrary precision type] cannot be
//   both [unconstrained] and [fractional] simultaneously. If attempted,
//   the {value} becomes a [float] rather than a [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
//   Numeric(value: '3.14', precision: 3, scale: 2) -> Float
//   Numeric(value: '0.13') -> Float, as '0' is treated as a significant digit
//
// - Similarly, there are no tests for [arbitrary precision types with negative scale],
//   because defining such types requires a {scale}, thus making them inherently
//   constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('positive division', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(2);
      final expected = BigInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(30);
      final value2 = Integer(2);
      final expected = Integer(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Real(30);
      final value2 = BigSerial(2);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Real(30);
      final value2 = Serial(2);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Real(30);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Real(30);
      const value2 = 2;
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Real(30);
      const value2 = 2.0;
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Real(30);
      const value2 = 2.5;
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Real(30);
      final value2 = Real(2.0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Real(30);
      final value2 = Real(2.5);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(2.0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(2.5);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '2');
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '2.5', precision: 3, scale: 1);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '2.5');
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '1231' is rounded to '1000'.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Real(3000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = SmallInteger(3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '2');
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '2.5', precision: 2, scale: 1);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '2.5');
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '1231' is rounded to '1000'.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Real(3000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = SmallInteger(3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests integer division where both operands are negative.
//
// This group of tests ensures correct behavior of integer division
// operations when both operands are negative. The tests verify the
// behavior of the operation across all supported data types, adhering
// to PostgreSQL's general rules.
//
// In integer division, when both operands are negative, the result
// is always positive. Unlike regular division, integer division
// consistently returns an {Integer type}. If the resultant value is
// too large to be stored as an {Integer type}, then an error will be
// thrown.
//
// Observations:
// - This test group excludes [Serial types] since their minimum {value} is 1,
//   making it impossible to store negative values.
//
// - There are no tests for [unconstrained] [arbitrary types with negative scale],
//   because such types require specifying a {scale}, making [unconstrained]
//   configurations unfeasible:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('negative division', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(-2);
      final expected = BigInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(-2);
      final expected = Integer(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(-2);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Real(-30);
      const value2 = -2;
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Real(-30);
      const value2 = -2.0;
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Real(-30);
      const value2 = -2.5;
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Real(-30);
      final value2 = Real(-2.0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Real(-30);
      final value2 = Real(-2.5);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-2.0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-2.5);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-2', precision: 1, scale: 0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-2');
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-2.5', precision: 2, scale: 1);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-2.5');
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '-1231' is rounded to '-1000'.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Real(-3000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = SmallInteger(3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-2', precision: 1, scale: 0);
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-2');
      final expected = SmallInteger(15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-2.5', precision: 2, scale: 1);
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-2.5');
      final expected = SmallInteger(12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '-1231' is rounded to '-1000'.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Real(-3000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = SmallInteger(3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests integer division where the first operand is positive and
// the second is negative.
//
// This group of tests ensures correct behavior of integer division
// operations when the first operand is positive and the second is
// negative. The tests verify the behavior of the operation across
// all supported data types, adhering to PostgreSQL's general rules.
//
// In integer division, when operands have opposite signs, the result
// is consistently negative. Unlike regular division, integer division
// always returns an {Integer type}. If the resultant value is too
// large for an {Integer type} to store, then an error will be thrown.
//
// Observations:
// - This test group excludes [Serial types] because their minimum {value} is 1,
//   preventing them from representing negative values.
//
// - There are no tests for [fractional arbitrary precision types], as these
//   represent values between 0 and 1, and zero values cannot bear a sign.
//
// - Additionally, there are no tests for [unconstrained]
//   [arbitrary types with negative scale], because such configurations require
//   a specified {scale}, rendering them inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('mixed sign division (positive + negative)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(-2);
      final expected = BigInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(30);
      final value2 = Integer(-2);
      final expected = Integer(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(-2);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Real(30);
      const value2 = -2;
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Real(30);
      const value2 = -2.0;
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Real(30);
      const value2 = -2.5;
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a integer-valued Real', () {
      final value1 = Real(30);
      final value2 = Real(-2.0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a fractional Real', () {
      final value1 = Real(30);
      final value2 = Real(-2.5);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a integer-valued DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(-2.0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a fractional DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(-2.5);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-2', precision: 1, scale: 0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-2');
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-2.5', precision: 2, scale: 1);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-2.5');
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(-100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '-1231' is rounded to '-1000'.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Real(3000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = SmallInteger(-3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-2', precision: 1, scale: 0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-2');
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-2.5', precision: 2, scale: 1);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-2.5');
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(-100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '-1231' is rounded to '-1000'.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Real(3000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = SmallInteger(-3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests integer division where the first operand is negative and
// the second is positive.
//
// This group of tests ensures correct behavior of integer division
// operations when the first operand is negative and the second is
// positive. The tests verify the behavior of the operation across
// all supported data types, adhering to PostgreSQL's general rules.
//
// In integer division, when operands have distinct signs, the result
// is always negative. Unlike regular division, integer division
// always returns an {Integer type}. If the resultant value is too
// large for an {Integer type} to store, then an error will be thrown.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types]
//   because it is impossible. An [arbitrary precision type] cannot be
//   both [unconstrained] and [fractional] simultaneously. If such a configuration
//   is attempted, the {value} becomes a [float] rather than a [fractional]:
//
//   Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
//   Numeric(value: '3.14', precision: 3, scale: 2) -> Float
//   Numeric(value: '0.13') -> Float, as '0' is treated as a significant digit
//
// - Additionally, there are no tests for [arbitrary types with negative scale],
//   because defining such types requires a specified {scale}, making them
//   inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Will be rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('mixed sign division (negative + positive)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(2);
      final expected = BigInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(2);
      final expected = Integer(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Real(-30);
      final value2 = BigSerial(2);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Real(-30);
      final value2 = Serial(2);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Real(-30);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Real(-30);
      const value2 = 2;
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Real(-30);
      const value2 = 2.0;
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Real(-30);
      const value2 = 2.5;
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Real(-30);
      final value2 = Real(2.0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Real(-30);
      final value2 = Real(2.5);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(2.0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(2.5);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '2', precision: 2, scale: 0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '2');
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '2.5', precision: 2, scale: 1);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '2.5');
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(-100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '1231' is rounded to '1000'.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Real(-3000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = SmallInteger(-3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '2');
      final expected = SmallInteger(-15);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '2.5', precision: 2, scale: 1);
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '2.5');
      final expected = SmallInteger(-12);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(-100);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    // Obs: in this test, '1231' is rounded to '1000'.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Real(-3000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = SmallInteger(-3);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division where both operands are integers can
// yield a whole result correctly.
//
// This group of tests focuses on scenarios in integer division where the result
// is an exact whole number without any decimal part, effectively mirroring
// regular division:
//
// 30 / 2 = 15 -> because 15 * 2 = 30
//
// Unlike regular division, integer division always returns an {Integer type},
// regardless of the scenario. If the result is too large to be stored within
// an {Integer type}, an error will be thrown.
//
// Observations:
// - In this test group, only [int arbitrary precision types] and
//   [Integer types] are tested. These tests ensure the operations
//   behave as expected under conditions typical for integer calculations,
//   where the outcomes must be exact integers without any fractional components.
  group('integer division (exact)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(50);
      final value2 = BigInteger(2);
      final expected = BigInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(50);
      final value2 = Integer(2);
      final expected = Integer(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(50);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Real(50);
      final value2 = BigSerial(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Real(50);
      final value2 = Serial(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Real(50);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int primitive', () {
      final value1 = Real(50);
      const value2 = 2;
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2');
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2');
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division where both operands are integers can yield
// a fractional result correctly truncated.
//
// In integer division, operations resulting in fractional values are
// truncated to produce a whole number:
//
// 5 / 2 = 2.5 -> truncate(2.5) = 2
//
// Unlike regular division, integer division always returns an {Integer type},
// regardless of the scenario. If the result exceeds the storage capacity
// of an {Integer type}, an error is thrown.
//
// Observations:
// - Only [int arbitrary precision types] and [Integer types] are tested
//   in this group. This ensures operations reflect typical behaviors
//   of integer calculations, where outcomes must be whole numbers, with
//   fractional components discarded.
  group('integer division (fractional)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Real(5);
      final value2 = BigInteger(2);
      final expected = BigInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Real(5);
      final value2 = Integer(2);
      final expected = Integer(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Real(5);
      final value2 = SmallInteger(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Real(5);
      final value2 = BigSerial(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Real(5);
      final value2 = Serial(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Real(5);
      final value2 = SmallSerial(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int primitive', () {
      final value1 = Real(5);
      const value2 = 2;
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2');
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2');
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and an
// [integer-valued] [floating point type] can yield a correct whole result.
//
// This group tests scenarios where results are exact and contain no
// decimal part, functioning similar to regular division:
//
// 50 (cast to 50.0) / 2.0 = 25 -> because 25 * 2 = 50
//
// Unlike regular division, integer division always returns an {Integer type}.
// If the value is too large for an {Integer type}, an error is thrown.
//
// Observations:
// - This group tests only [float arbitrary precision types] and
//   [floating point types], ensuring they behave as expected under
//   integer division rules, where outcomes must be exact integers.
  group('integer-valued floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(50);
      const value2 = 2.0;
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(50);
      final value2 = Real(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(50);
      final value2 = DoublePrecision(2);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(50);
      final value2 = Numeric(value: '2.0');
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(50);
      final value2 = Decimal(value: '2.0');
      final expected = SmallInteger(25);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and an
// [integer-valued] [floating point type] can yield a correct fractional
// result.
//
// In integer division, an operation always results in a whole number.
// However, in this group, all operations yield values with a decimal part.
// Unlike regular division, the final result is truncated:
//
// 5 / 2.0 = 2.5 -> truncate(2.5) = 2
//
// Unlike regular division, integer division always returns an {Integer type}.
// If the value is too large for an {Integer type}, an error is thrown.
//
// Observations:
// - This group exclusively tests [float arbitrary precision types] and
//   [floating point types], examining their behavior under integer division.
  group('integer-valued floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(5);
      const value2 = 2.0;
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(5);
      final value2 = Real(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(5);
      final value2 = DoublePrecision(2);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(5);
      final value2 = Numeric(value: '2.0');
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(5);
      final value2 = Decimal(value: '2.0');
      final expected = SmallInteger(2);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and a
// [floating point type] with a decimal part can yield an exact result correctly.
//
// In integer division, operations always result in a whole number. This group tests
// scenarios where the results are exact, with no decimal part, mirroring regular
// division:
//
// 6 / 1.5 = 4 -> because 1.5 * 4 = 6
//
// Unlike regular division, integer division always returns an {Integer type}.
// If the result exceeds the capacity of an {Integer type}, an error is thrown.
//
// Observations:
// - Only [float arbitrary precision types] and [floating point types] are tested
//   in this group, ensuring they behave as expected under integer division rules.
  group('fractional floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(6);
      const value2 = 1.5;
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(6);
      final value2 = Real(1.5);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(6);
      final value2 = DoublePrecision(1.5);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(6);
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(6);
      final value2 = Numeric(value: '1.5');
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(6);
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(6);
      final value2 = Decimal(value: '1.5');
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and a
// [floating point type] with a decimal part can yield a truncated
// result correctly.
//
// In integer division, operations result in whole numbers. This group
// tests scenarios where results include a decimal part, requiring
// truncation:
//
// 7 / 1.5 = 4.666... -> truncate(4.666...) = 4
//
// Unlike regular division, integer division always returns an
// {Integer type}. If the result exceeds {Integer type} capacity,
// an error is thrown.
//
// Observations:
// - Only [float arbitrary precision types] and [floating point types]
//   are tested in this group, ensuring appropriate behavior under
//   integer division rules.
  group('fractional floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(7);
      const value2 = 1.5;
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(7);
      final value2 = Real(1.5);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(7);
      final value2 = DoublePrecision(1.5);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Real(7);
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Real(7);
      final value2 = Numeric(value: '1.5');
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Real(7);
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Real(7);
      final value2 = Decimal(value: '1.5');
      final expected = SmallInteger(4);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and a
// [floating point type] that is fractional (greater than 0 and less than 1)
// can yield an exact result correctly.
//
// In integer division, operations result in whole numbers. This group
// tests scenarios where results are exact and have no decimal part,
// functioning like regular division:
//
// 4 / 0.5 = 8 -> because 0.5 * 8 = 4
//
// Unlike regular division, integer division always returns an {Integer type}.
// If the result is too large for an {Integer type} to store, an error is thrown.
//
// Observations:
// - This group only tests [fractional arbitrary precision types] and
//   [floating point types] with fractional-only values, ensuring they
//   behave correctly under integer division rules.
  group('fractional only floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(4);
      const value2 = 0.5;
      final expected = SmallInteger(8);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(4);
      final value2 = Real(0.5);
      final expected = SmallInteger(8);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(4);
      final value2 = DoublePrecision(0.5);
      final expected = SmallInteger(8);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(4);
      final value2 = Numeric(value: '0.5', precision: 1, scale: 1);
      final expected = SmallInteger(8);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(4);
      final value2 = Decimal(value: '0.5', precision: 1, scale: 1);
      final expected = SmallInteger(8);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between an [Integer type] operand and a
// [floating point type] greater than 0 and less than 1 can yield a
// correctly truncated fractional result.
//
// In integer division, operations always result in a whole number.
// This group tests scenarios where the mathematical result includes a
// decimal part, thus requiring truncation:
//
// 4 / 0.3 = 13.3333... -> truncate(13.3333...) = 13
//
// Unlike regular division, integer division always returns an {Integer type}.
// If the result exceeds the capacity of an {Integer type}, an error is thrown.
//
// Observations:
// - This test group exclusively examines [fractional arbitrary precision types]
//   and [floating point types] with fractional-only values, to ensure they
//   behave as expected under integer division rules.
  group('fractional only floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Real(4);
      const value2 = 0.3;
      final expected = SmallInteger(13);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Real(4);
      final value2 = Real(0.3);
      final expected = SmallInteger(13);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Real(4);
      final value2 = DoublePrecision(0.3);
      final expected = SmallInteger(13);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Real(4);
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(13);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Real(4);
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = SmallInteger(13);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between a positive non-zero value
// and zero will throw an {ArgumentError}.
//
// In integer division, any number divided by zero is undefined.
// For example:
//
// 10 / 0 = ? -> Undefined
//
// Programming languages typically handle this by throwing an error
// when an attempt to divide by zero is made.
//
// Observations:
// - No tests for [fractional floating point] or [fractional arbitrary types]
//   because they cannot represent a zero value in a meaningful way.
// - No tests for [Serial types] since their minimum {value} is 1, and they
//   cannot store 0 as a value.
  group('non-zero divided by zero (positive + zero)', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Real(30);
      final value2 = BigInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Real(30);
      final value2 = Integer(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Real(30);
      final value2 = SmallInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero primitive', () {
      final value1 = Real(30);
      const value2 = 0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double zero primitive', () {
      final value1 = Real(30);
      const value2 = 0.0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Real(30);
      final value2 = Real(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '0.0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });
  });

// Tests if integer division between a negative non-zero value
// and zero will throw an {ArgumentError}.
//
// In integer division, any number divided by zero is undefined.
// For example:
//
// -10 / 0 = ? -> Undefined
//
// Programming languages handle this by throwing an error when an
// attempt to divide by zero is made.
//
// Observations:
// - No tests for [fractional floating point] or [fractional arbitrary types]
//   because they cannot represent a zero value meaningfully.
// - No tests for [Serial types] since their minimum {value} is 1, and they
//   cannot store 0 as a value.
  group('non-zero divided by zero (negative + zero)', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Real(-30);
      final value2 = BigInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Real(-30);
      final value2 = Integer(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero primitive', () {
      final value1 = Real(-30);
      const value2 = 0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double zero primitive', () {
      final value1 = Real(-30);
      const value2 = 0.0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Real(-30);
      final value2 = Real(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });
  });

// Tests if integer division between a zero and a positive non-zero
// value will return zero.
//
// In integer division, zero divided by any non-zero number results
// in zero. For example:
//
// 0 / 20 = 0
//
// The example above does not cause an error because the numerator
// is zero. If, instead, the denominator were zero, an error would
// occur.
  group('zero divided by non-zero (zero + positive)', () {
    test('should return zero if dividing by BigInteger', () {
      final value1 = Real(0);
      final value2 = BigInteger(20);
      final expected = BigInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Integer', () {
      final value1 = Real(0);
      final value2 = Integer(20);
      final expected = Integer(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallInteger', () {
      final value1 = Real(0);
      final value2 = SmallInteger(20);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by BigSerial', () {
      final value1 = Real(0);
      final value2 = BigSerial(20);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Serial', () {
      final value1 = Real(0);
      final value2 = Serial(20);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallSerial', () {
      final value1 = Real(0);
      final value2 = SmallSerial(20);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int primitive', () {
      final value1 = Real(0);
      const value2 = 20;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued double primitive',
        () {
      final value1 = Real(0);
      const value2 = 20.0;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional double primitive', () {
      final value1 = Real(0);
      const value2 = 20.5;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued Real', () {
      final value1 = Real(0);
      final value2 = Real(20.0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Real', () {
      final value1 = Real(0);
      final value2 = Real(20.5);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(20.0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional DoublePrecision', () {
      final value1 = Real(0);
      final value2 = DoublePrecision(20.5);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '20.5');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '20.5');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between a zero and a negative non-zero
// value will return zero.
//
// In integer division, zero divided by any non-zero number results
// in zero. For example:
//
// 0 / -20 = 0
//
// This example does not cause an error because the numerator is zero.
// If the denominator were zero instead, an error would occur.
//
// Observations:
// - No tests for [Serial types] because their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('zero divided by non-zero (zero + negative)', () {
    test('should return zero if dividing by BigInteger', () {
      final value1 = Real(0);
      final value2 = BigInteger(-20);
      final expected = BigInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Integer', () {
      final value1 = Real(0);
      final value2 = Integer(-20);
      final expected = Integer(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallInteger', () {
      final value1 = Real(0);
      final value2 = SmallInteger(-20);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int primitive', () {
      final value1 = Real(0);
      const value2 = -20;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued double primitive',
        () {
      final value1 = Real(0);
      const value2 = -20.0;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional double primitive', () {
      final value1 = Real(0);
      const value2 = -20.5;
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued Real', () {
      final value1 = Real(0);
      final value2 = Real(-20.0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Real', () {
      final value1 = Real(0);
      final value2 = Real(-20.5);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued DoublePrecision',
        () {
      final value1 = Real(0);
      final value2 = DoublePrecision(-20.0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional DoublePrecision', () {
      final value1 = Real(0);
      final value2 = DoublePrecision(-20.5);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-20.5');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20.5', precision: 3, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-20.5');
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = SmallInteger(0);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between two zero values will throw
// an {ArgumentError}.
//
// In integer division, zero divided by zero results in undefined.
// For example:
//
// 0 / 0 = ? -> Undefined
//
// Programming languages address this by throwing an error when
// division by zero is attempted.
//
// Observations:
// - There are no tests for [fractional arbitrary types] as they
//   cannot meaningfully represent a zero value.
// - No tests for [Serial types] because their minimum {value} is 1,
//   thus they cannot store 0 as a value.
  group('zero divided by zero', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Real(0);
      final value2 = BigInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Real(0);
      final value2 = Integer(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Real(0);
      final value2 = SmallInteger(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int primitive zero', () {
      final value1 = Real(0);
      const value2 = 0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double primitive zero', () {
      final value1 = Real(0);
      const value2 = 0.0;
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Real(0);
      final value2 = Real(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Real(0);
      final value2 = DoublePrecision(0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Real(0);
      final value2 = Numeric(value: '0.0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 ~/ value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Real(0);
      final value2 = Decimal(value: '0.0');
      expect(() => value1 ~/ value2, throwsArgumentError);
    });
  });

// Tests if integer division between a positive non-zero value
// and a positive one will return the first operand.
//
// In integer division, any value divided by one results in
// itself. For example:
//
// 20 / 1 = 20
//
// Observations:
// - There are no tests for [fractional floating point] as
//   they cannot represent an [Integer value]. Similarly, there
//   are no tests for [fractional arbitrary types] because they
//   cannot represent an [Integer type].
  group('division by one', () {
    test('should return itself when dividing by BigInteger one', () {
      final value1 = Real(30);
      final value2 = BigInteger(1);
      final expected = BigInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Integer one', () {
      final value1 = Real(30);
      final value2 = Integer(1);
      final expected = Integer(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by SmallInteger one', () {
      final value1 = Real(30);
      final value2 = SmallInteger(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by BigSerial one', () {
      final value1 = Real(30);
      final value2 = BigSerial(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Serial one', () {
      final value1 = Real(30);
      final value2 = Serial(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by SmallSerial one', () {
      final value1 = Real(30);
      final value2 = SmallSerial(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Real one', () {
      final value1 = Real(30);
      final value2 = Real(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by DoublePrecision one', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by int Numeric one', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by unconstrained int Numeric one',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1');
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by float Numeric one', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1.0', precision: 2, scale: 1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return itself when dividing by unconstrained float Numeric one',
        () {
      final value1 = Real(30);
      final value2 = Numeric(value: '1');
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by int Decimal one', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by unconstrained int Decimal one',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1');
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by float Decimal one', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1.0', precision: 2, scale: 1);
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return itself when dividing by unconstrained float Decimal one',
        () {
      final value1 = Real(30);
      final value2 = Decimal(value: '1');
      final expected = SmallInteger(30);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between a positive non-zero value
// and itself will return one.
//
// In integer division, any value divided by itself results in one.
// For example:
//
// 20 / 20 = 1
//
// Observations:
// - No tests for [fractional floating point] as they cannot
//   represent an [Integer value]. Similarly, there are no tests
//   for [fractional arbitrary types] because they cannot
//   represent an [Integer type].
  group('division by itself (positive)', () {
    test('should return one when dividing by BigInteger', () {
      final value1 = Real(30);
      final value2 = BigInteger(30);
      final expected = BigInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Integer', () {
      final value1 = Real(30);
      final value2 = Integer(30);
      final expected = Integer(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallInteger', () {
      final value1 = Real(30);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by BigSerial', () {
      final value1 = Real(30);
      final value2 = BigSerial(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Serial', () {
      final value1 = Real(30);
      final value2 = Serial(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallSerial', () {
      final value1 = Real(30);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int primitive', () {
      final value1 = Real(30);
      const value2 = 30;
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by double primitive', () {
      final value1 = Real(30);
      const value2 = 30.0;
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Real', () {
      final value1 = Real(30);
      final value2 = Real(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by DoublePrecision', () {
      final value1 = Real(30);
      final value2 = DoublePrecision(30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30');
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Numeric', () {
      final value1 = Real(30);
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30');
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Decimal', () {
      final value1 = Real(30);
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if integer division between a negative non-zero value
// and itself will return one.
//
// In integer division, any value divided by itself results in one.
// For example:
//
// -20 / -20 = 1
//
// Observations:
// - No tests for [fractional floating point] as they cannot
//   represent an [Integer value]. Similarly, no tests for
//   [fractional arbitrary types] because they cannot represent
//   an [Integer type].
// - No tests for [Serial types] since their minimum {value} is 1,
//   and they cannot store negative values.
  group('division by itself (negative)', () {
    test('should return one when dividing by BigInteger', () {
      final value1 = Real(-30);
      final value2 = BigInteger(-30);
      final expected = BigInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Integer', () {
      final value1 = Real(-30);
      final value2 = Integer(-30);
      final expected = Integer(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallInteger', () {
      final value1 = Real(-30);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int primitive', () {
      final value1 = Real(-30);
      const value2 = -30;
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by double primitive', () {
      final value1 = Real(-30);
      const value2 = -30.0;
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Real', () {
      final value1 = Real(-30);
      final value2 = Real(-30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by DoublePrecision', () {
      final value1 = Real(-30);
      final value2 = DoublePrecision(-30);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30');
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Numeric', () {
      final value1 = Real(-30);
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30');
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Decimal', () {
      final value1 = Real(-30);
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if performing division with operands of different
// types will correctly cast both operands and return the final
// result of the expected type.
//
// This group of tests ensures that type casting functions
// properly when operands are of different types. The focus is
// on the final type rather than the value, as division resulting
// values are tested in other groups within this file.
//
// Observations:
// - 1 is used as the {value} in most operations instead of 0,
//   due to the minimum {value} of [Serial types], which is 1.
  group('type casting', () {
    test('should return BigInteger as result when dividing BigInteger', () {
      final value1 = Real(1);
      final value2 = BigInteger(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when dividing negative BigInteger',
        () {
      final value1 = Real(1);
      final value2 = BigInteger(-1);
      final operation = value1 ~/ value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return Integer as result when dividing Integer', () {
      final value1 = Real(1);
      final value2 = Integer(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<Integer>());
    });

    test('should return Integer as result when dividing negative Integer', () {
      final value1 = Real(1);
      final value2 = Integer(-1);
      final operation = value1 ~/ value2;
      expect(operation, isA<Integer>());
    });

    test('should return SmallInteger as result when dividing SmallInteger', () {
      final value1 = Real(1);
      final value2 = SmallInteger(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when dividing negative SmallInteger',
        () {
      final value1 = Real(1);
      final value2 = SmallInteger(-1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing BigSerial', () {
      final value1 = Real(1);
      final value2 = BigSerial(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing Serial', () {
      final value1 = Real(1);
      final value2 = Serial(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing SmallSerial', () {
      final value1 = Real(1);
      final value2 = SmallSerial(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing int primitive',
        () {
      final value1 = Real(1);
      const value2 = 1;
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when dividing negative int primitive',
        () {
      final value1 = Real(1);
      const value2 = -1;
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing double primitive',
        () {
      final value1 = Real(1);
      const value2 = 1.5;
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when dividing negative double primitive',
        () {
      final value1 = Real(1);
      const value2 = -1.5;
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing Real', () {
      final value1 = Real(1);
      final value2 = Real(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing negative Real',
        () {
      final value1 = Real(1);
      final value2 = Real(-1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing DoublePrecision',
        () {
      final value1 = Real(1);
      final value2 = DoublePrecision(1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when dividing negative DoublePrecision',
        () {
      final value1 = Real(1);
      final value2 = DoublePrecision(-1);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing Numeric', () {
      final value1 = Real(1);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing negative Numeric',
        () {
      final value1 = Real(1);
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing Decimal', () {
      final value1 = Real(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when dividing negative Decimal',
        () {
      final value1 = Real(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 ~/ value2;
      expect(operation, isA<SmallInteger>());
    });
  });
}
