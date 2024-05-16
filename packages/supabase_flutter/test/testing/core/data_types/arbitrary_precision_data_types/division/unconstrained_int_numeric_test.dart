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
// Tests division where both operands are positive.
//
// This suite ensures correct division operation for positive operands across
// all supported data types, following PostgreSQL's general rules.
//
// With positive operands, the result is always positive. Notably, PostgreSQL
// implements a "default scale" for divisions, often larger than necessary. For
// example:
//
// final operand1 = Numeric(value: '9', precision: 1, scale: 0);
// final operand2 = Numeric(value: '3', precision: 1, scale: 0);
//
// operand1 / operand2 -> Results in '3.00000000000000000000'
//
// This illustrates that the default scale for division is 20, applied uniformly
// to all results.
//
// When the operands are [Integer types], the result is a {Real}, as integer
// division may not yield another integer:
//
// 5 / 2 = 2.5 -> Which is not an integer
//
// Consequently, to handle potential floating point results, division between
// [Integer types] always yields a {Real}.
//
// These tests focus on the resultant value and sign, with type casting
// addressed separately in another test group within this file.
//
// Observations:
// - No tests for [unconstrained] [fractional arbitrary types] exist since
// an [arbitrary precision type] cannot simultaneously be [unconstrained] and
// [fractional]. If attempted, the result defaults to [float]:
//
// Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
// Numeric(value: '3.14', precision: 3, scale: 2) -> Float
// Numeric(value: '0.13') -> Float, '0' is treated as a significant digit
//
// - Similarly, [arbitrary precision types with negative scale] are impractical
// as specifying a {scale} precludes being [unconstrained]:
//
// Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
// Numeric(value: '1349') -> Unconstrained int Numeric with value '1349'
  group('positive division', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = BigInteger(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '30');
      final value2 = Integer(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallInteger(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Numeric(value: '30');
      final value2 = BigSerial(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Numeric(value: '30');
      final value2 = Serial(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallSerial(2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Numeric(value: '30');
      const value2 = 2;
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Numeric(value: '30');
      const value2 = 2.0;
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Numeric(value: '30');
      const value2 = 2.5;
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(2.0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(2.5);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(2.0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(2.5);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '2.5', precision: 3, scale: 1);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '2.5');
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Numeric(value: '3000');
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '2');
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '2.5');
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Numeric(value: '3000');
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests division where both operands are negative.
//
// This suite verifies correct division behavior when both operands are negative
// across all supported data types, following PostgreSQL's general rules.
//
// In division, negative operands result in a positive outcome:
//
// final operand1 = Numeric(value: '-9', precision: 1, scale: 0);
// final operand2 = Numeric(value: '-3', precision: 1, scale: 0);
//
// operand1 / operand2 -> Results in '3.00000000000000000000'
//
// This demonstrates that the default scale in PostgreSQL division is 20, and
// this scale applies to all results, indicating a consistent output format.
//
// For divisions involving [Integer types], the outcome is always a {Real}, as
// division between two [Integer types] may not result in another {Integer}:
//
// -5 / -2 = 2.5 -> The result, 2.5, is not an integer
//
// Therefore, to account for potential floating point results, divisions between
// [Integer types] always return a {Real}.
//
// The tests focus more on the resultant value and sign rather than the final
// type; type conversion is handled in a separate test group within this file.
//
// Observations:
// - This test group excludes [Serial types] since their minimum {value} is 1,
// preventing them from storing negative values.
//
// - Additionally, tests do not cover [unconstrained] [arbitrary types with negative
// scale], as defining such types requires a {scale}, thus being [unconstrained]
// is unfeasible:
//
// Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
// Numeric(value: '1349') -> Unconstrained int Numeric with value '1349'
  group('negative division', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = BigInteger(-2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '-30');
      final value2 = Integer(-2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = SmallInteger(-2);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Numeric(value: '-30');
      const value2 = -2;
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Numeric(value: '-30');
      const value2 = -2.0;
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Numeric(value: '-30');
      const value2 = -2.5;
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(-2.0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(-2.5);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(-2.0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(-2.5);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-2', precision: 1, scale: 0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-2');
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-2.5');
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Numeric(value: '-3000');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-2', precision: 1, scale: 0);
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-2');
      final expected = Numeric(value: '15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-2.5');
      final expected = Numeric(value: '12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Numeric(value: '-3000');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests division where the first operand is positive and the second is negative.
//
// This suite ensures correct behavior of division operations when the first
// operand is positive and the second is negative. The tests verify behavior
// across all supported data types, adhering to PostgreSQL's general rules.
//
// In division, when operands have different signs, the result is always negative.
//
// PostgreSQL's division often uses a "default scale" which is typically larger
// than necessary. For example:
//
// final operand1 = Numeric(value: '9', precision: 1, scale: 0);
// final operand2 = Numeric(value: '-3', precision: 1, scale: 0);
//
// operand1 / operand2 -> Results in '-3.00000000000000000000'
//
// This shows that the default scale for division is set at 20, applied uniformly
// to all results.
//
// For divisions involving [Integer types], the result is always a {Real}:
//
// 5 / -2 = -2.5 -> -2.5 is not an integer
//
// As such, to manage potential floating point results, divisions between [Integer
// types] always return a {Real}.
//
// These tests focus on the resultant value and sign rather than the final type;
// type casting is assessed in a separate test group within this file.
//
// Observations:
// - This test group excludes [Serial types] since their minimum {value} is 1,
// preventing them from storing negative values.
//
// - Also, tests do not cover [unconstrained] [arbitrary types with negative scale],
// because such a definition requires a {scale}, making [unconstrained] configurations
// infeasible:
//
// Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
// Numeric(value: '1349') -> Unconstrained int Numeric with the value of '1349'
  group('mixed sign division (positive + negative)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = BigInteger(-2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '30');
      final value2 = Integer(-2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallInteger(-2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Numeric(value: '30');
      const value2 = -2;
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Numeric(value: '30');
      const value2 = -2.0;
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Numeric(value: '30');
      const value2 = -2.5;
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a integer-valued Real', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(-2.0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a fractional Real', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(-2.5);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(-2.0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide a fractional DoublePrecision', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(-2.5);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '-2', precision: 1, scale: 0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '-2');
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '-2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '-2.5');
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '-100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Numeric(value: '3000');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '-2', precision: 1, scale: 0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '-2');
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '-2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '-2.5');
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '-100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Numeric(value: '3000');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests division where the first operand is negative and the
// second is positive.
//
// This group of tests ensures correct behavior of division
// operations when the first operand is negative and the second is
// positive. The tests verify the behavior of the operation across
// all supported data types, adhering to PostgreSQL's general rules.
//
// In division, when operands have opposite signs, the result
// is always negative.
//
// PostgreSQL's division often employs a "default scale" which is
// generally larger than necessary. Consider the following example:
//
// final operand1 = Numeric(value: '-9', precision: 1, scale: 0);
// final operand2 = Numeric(value: '3', precision: 1, scale: 0);
//
// operand1 / operand2 -> Results in '-3.00000000000000000000'
//
// This example indicates that the default scale for division is 20,
// uniformly applied to all results.
//
// In divisions involving [Integer types], the result is always a {Real}:
//
// -5 / 2 = -2.5 -> The result, -2.5, is not an integer
//
// Therefore, to manage potential floating-point results, division between
// [Integer types] always yields a {Real}.
//
// The tests prioritize examining the resultant value and sign over
// the final type; type casting is explored separately in another test group
// within this file.
//
// Observations:
// - There are no tests for [unconstrained] [fractional arbitrary types]
// because such a configuration is impossible. An [arbitrary precision type]
// cannot be both [unconstrained] and [fractional] simultaneously:
//
// Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
// Numeric(value: '3.14', precision: 3, scale: 2) -> Float
// Numeric(value: '0.13') -> Float, '0' is treated as a significant digit
//
// - Similarly, tests do not cover [arbitrary types with negative scale],
// because specifying a {scale} precludes being [unconstrained]:
//
// Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
// Numeric(value: '1349') -> Unconstrained int Numeric with value '1349'
  group('mixed sign division (negative + positive)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = BigInteger(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '-30');
      final value2 = Integer(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = SmallInteger(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Numeric(value: '-30');
      final value2 = BigSerial(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Numeric(value: '-30');
      final value2 = Serial(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Numeric(value: '-30');
      final value2 = SmallSerial(2);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int', () {
      final value1 = Numeric(value: '-30');
      const value2 = 2;
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued double', () {
      final value1 = Numeric(value: '-30');
      const value2 = 2.0;
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional double', () {
      final value1 = Numeric(value: '-30');
      const value2 = 2.5;
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued Real', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(2.0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Real', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(2.5);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(2.0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional DoublePrecision', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(2.5);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '2', precision: 2, scale: 0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '2.5');
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '-100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Numeric with negative scale', () {
      final value1 = Numeric(value: '-3000');
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '2');
      final expected = Numeric(value: '-15', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '2.5', precision: 2, scale: 1);
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '2.5');
      final expected = Numeric(value: '-12', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '-100', precision: 23, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly divide Decimal with negative scale', () {
      final value1 = Numeric(value: '-3000');
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-3', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where both operands are integers can yield a
// whole result correctly.
//
// In integer division, the operation results in a whole number only
// if the second operand perfectly divides the first, meaning the first
// operand is a multiple of the second. For example:
//
// 30 / 2 = 15 -> because 15 * 2 = 30
//
// Observations:
// - This test group is restricted to [int arbitrary precision types] and
// [Integer types] only.
  group('integer division (exact)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '50');
      final value2 = BigInteger(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '50');
      final value2 = Integer(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '50');
      final value2 = SmallInteger(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Numeric(value: '50');
      final value2 = BigSerial(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Numeric(value: '50');
      final value2 = Serial(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Numeric(value: '50');
      final value2 = SmallSerial(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int primitive', () {
      final value1 = Numeric(value: '50');
      const value2 = 2;
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '50');
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '50');
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '50');
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '50');
      final value2 = Decimal(value: '2');
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where both operands are integers can yield a
// fractional result correctly.
//
// In integer division, the operation results in a fractional number
// if the second operand is not perfectly divisible by the first. In
// other words, the first operand is not a multiple of the second,
// necessitating a fractional part to accurately express the quotient.
// For example:
//
// 5 / 2 = 2.5 -> because 2 * 2 = 4 and 0.5 * 2 = 1, summing up to 5
//
// Observations:
// - This test group exclusively examines [int arbitrary precision types]
//   and [Integer types].
  group('integer division (fractional)', () {
    test('should correctly divide BigInteger', () {
      final value1 = Numeric(value: '5');
      final value2 = BigInteger(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Integer', () {
      final value1 = Numeric(value: '5');
      final value2 = Integer(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallInteger', () {
      final value1 = Numeric(value: '5');
      final value2 = SmallInteger(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide BigSerial', () {
      final value1 = Numeric(value: '5');
      final value2 = BigSerial(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Serial', () {
      final value1 = Numeric(value: '5');
      final value2 = Serial(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide SmallSerial', () {
      final value1 = Numeric(value: '5');
      final value2 = SmallSerial(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int primitive', () {
      final value1 = Numeric(value: '5');
      const value2 = 2;
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Numeric', () {
      final value1 = Numeric(value: '5');
      final value2 = Numeric(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Numeric', () {
      final value1 = Numeric(value: '5');
      final value2 = Numeric(value: '2');
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide int Decimal', () {
      final value1 = Numeric(value: '5');
      final value2 = Decimal(value: '2', precision: 1, scale: 0);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained int Decimal', () {
      final value1 = Numeric(value: '5');
      final value2 = Decimal(value: '2');
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is an [integer-valued] [floating point type] can yield a
// whole result correctly.
//
// In such divisions, a whole number result is only achieved if the
// second operand (despite being a float) is perfectly divisible by the
// first. This means the first operand must be a multiple of the second.
// For example:
//
// 50 (cast to 50.0) / 2.0 = 25 -> because 25 * 2 = 50
//
// Observations:
// - This test group exclusively evaluates [float arbitrary precision types]
//   and [floating point types].
  group('integer-valued floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '50');
      const value2 = 2.0;
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '50');
      final value2 = Real(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '50');
      final value2 = DoublePrecision(2);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '50');
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '50');
      final value2 = Numeric(value: '2.0');
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '50');
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '50');
      final value2 = Decimal(value: '2.0');
      final expected = Numeric(value: '25', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is an [integer-valued] [floating point type] can yield a
// fractional result correctly.
//
// In such divisions, a fractional result is obtained if the second operand,
// though a float, is not perfectly divisible by the first. In other words,
// the first operand is not a multiple of the second one, necessitating a
// fractional part to represent the result accurately. For example:
//
// 5 / 2.0 = 2.5 -> because 2 * 2 = 4 and 0.5 * 2 = 1, adding up to 5
//
// Observations:
// - This test group is limited to [float arbitrary precision types] and
//   [floating point types].
  group('integer-valued floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '5');
      const value2 = 2.0;
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '5');
      final value2 = Real(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '5');
      final value2 = DoublePrecision(2);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '5');
      final value2 = Numeric(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '5');
      final value2 = Numeric(value: '2.0');
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '5');
      final value2 = Decimal(value: '2.0', precision: 2, scale: 1);
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '5');
      final value2 = Decimal(value: '2.0');
      final expected = Numeric(value: '2.5', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is a [floating point type] with a decimal part can yield an
// exact whole result correctly.
//
// In such division, a whole number result is only achieved if the second
// operand, despite having a decimal part, is perfectly divisible by the first.
// This means the first operand must be a multiple of the second. For example:
//
// 6 / 1.5 = 4 -> because 1.5 * 4 = 6
//
// Observations:
// - This test group exclusively evaluates [float arbitrary precision types] and
//   [floating point types], focusing on scenarios where the division of an integer
//   by a floating point number with decimals results in an exact integer outcome.
  group('fractional floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '6');
      const value2 = 1.5;
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '6');
      final value2 = Real(1.5);
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '6');
      final value2 = DoublePrecision(1.5);
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '6');
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '6');
      final value2 = Numeric(value: '1.5');
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '6');
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '6');
      final value2 = Decimal(value: '1.5');
      final expected = Numeric(value: '4', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is a [floating point type] with a decimal part can yield a
// fractional result correctly.
//
// In such division, a fractional number results if the second operand,
// despite being a floating point with decimals, is not perfectly divisible
// by the first. This means the first operand is not a multiple of the second,
// necessitating a fractional part to represent the quotient accurately. For example:
//
// 7 / 1.5 = 4.666... -> because 1.5 * 4.666... ≈ 7
//
// Observations:
// - This test group exclusively evaluates [float arbitrary precision types] and
//   [floating point types], focusing on scenarios where the division of an integer
//   by a floating point number results in a fractional outcome.
  group('fractional floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '7');
      const value2 = 1.5;
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '7');
      final value2 = Real(1.5);
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '7');
      final value2 = DoublePrecision(1.5);
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Numeric', () {
      final value1 = Numeric(value: '7');
      final value2 = Numeric(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Numeric', () {
      final value1 = Numeric(value: '7');
      final value2 = Numeric(value: '1.5');
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide float Decimal', () {
      final value1 = Numeric(value: '7');
      final value2 = Decimal(value: '1.5', precision: 2, scale: 1);
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide unconstrained float Decimal', () {
      final value1 = Numeric(value: '7');
      final value2 = Decimal(value: '1.5');
      final expected = Numeric(
        value: '4.66666666666666666666',
        precision: 21,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is a [floating point type] greater than 0 and
// less than 1, representing only the fractional part, can yield an
// exact whole number result correctly.
//
// In such divisions, a whole number result is achieved only if the
// second operand, which represents only the fractional part, is perfectly
// divisible by the first. This condition means the first operand must
// be a multiple of the inverse of the second. For example:
//
// 4 / 0.5 = 8 -> because 0.5 * 8 = 4
//
// Observations:
// - This test group exclusively evaluates [fractional arbitrary precision types]
//   and [floating point types] where the values are strictly fractional
//   (greater than 0 and less than 1), focusing on scenarios where the division
//   of an integer by such a floating point number results in an exact integer
//   outcome.
  group('fractional only floating point division (exact)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '4');
      const value2 = 0.5;
      final expected = Numeric(value: '8', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '4');
      final value2 = Real(0.5);
      final expected = Numeric(value: '8', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '4');
      final value2 = DoublePrecision(0.5);
      final expected = Numeric(value: '8', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '4');
      final value2 = Numeric(value: '0.5', precision: 1, scale: 1);
      final expected = Numeric(value: '8', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '4');
      final value2 = Decimal(value: '0.5', precision: 1, scale: 1);
      final expected = Numeric(value: '8', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division where the first operand is of [Integer type] and
// the second one is a [floating point type] greater than 0 and
// less than 1, representing only the fractional part, can yield a
// fractional result correctly.
//
// In such divisions, a fractional result is expected if the second operand,
// representing only a fractional part, does not perfectly divide the first.
// This means the first operand is not an exact multiple of the reciprocal of
// the second. For example:
//
// 4 / 0.3 = 13.3333... -> because 0.3 * 13.3333... ≈ 4
//
// Observations:
// - This test group exclusively evaluates [fractional arbitrary precision types]
//   and [floating point types] where the values are strictly fractional
//   (greater than 0 and less than 1), focusing on scenarios where the division
//   of an integer by such a floating point number results in a fractional outcome.
  group('fractional only floating point division (fractional)', () {
    test('should correctly divide double primitive', () {
      final value1 = Numeric(value: '4');
      const value2 = 0.3;
      final expected = Numeric(
        value: '13.33333333333333333333',
        precision: 22,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide Real', () {
      final value1 = Numeric(value: '4');
      final value2 = Real(0.3);
      final expected = Numeric(
        value: '13.33333333333333333333',
        precision: 22,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide DoublePrecision', () {
      final value1 = Numeric(value: '4');
      final value2 = DoublePrecision(0.3);
      final expected = Numeric(
        value: '13.33333333333333333333',
        precision: 22,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Numeric', () {
      final value1 = Numeric(value: '4');
      final value2 = Numeric(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(
        value: '13.33333333333333333333',
        precision: 22,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly divide fractional Decimal', () {
      final value1 = Numeric(value: '4');
      final value2 = Decimal(value: '0.3', precision: 1, scale: 1);
      final expected = Numeric(
        value: '13.33333333333333333333',
        precision: 22,
        scale: 20,
      );
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division between a positive non-zero value and zero
// will throw an {ArgumentError}.
//
// In division, any number divided by zero is undefined. This is
// commonly addressed in programming languages by throwing an error
// when an attempt is made to divide by zero, to prevent undefined behavior.
// For example:
//
// 10 / 0 = ? -> Undefined
//
// This behavior is consistent across environments that follow standard
// error handling practices in division by zero cases.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] because these types cannot
//   meaningfully represent a zero value.
// - Tests also exclude [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero divided by zero (positive + zero)', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Numeric(value: '30');
      final value2 = BigInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Numeric(value: '30');
      final value2 = Integer(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero primitive', () {
      final value1 = Numeric(value: '30');
      const value2 = 0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double zero primitive', () {
      final value1 = Numeric(value: '30');
      const value2 = 0.0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '0.0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '0.0');
      expect(() => value1 / value2, throwsArgumentError);
    });
  });

// Tests if division between a negative non-zero value and zero
// will throw an {ArgumentError}.
//
// In division, any operation where a number is divided by zero
// results in an undefined outcome. In programming, such situations
// typically lead to throwing an error to prevent undefined behavior.
// For example:
//
// -10 / 0 = ? -> Undefined
//
// Such cases are handled by raising an {ArgumentError} when
// division by zero is attempted.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] because these types cannot
//   meaningfully represent a zero value.
//
// - Tests also exclude [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value.
  group('non-zero divided by zero (negative + zero)', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Numeric(value: '-30');
      final value2 = BigInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Numeric(value: '-30');
      final value2 = Integer(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Numeric(value: '-30');
      final value2 = SmallInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero primitive', () {
      final value1 = Numeric(value: '-30');
      const value2 = 0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double zero primitive', () {
      final value1 = Numeric(value: '-30');
      const value2 = 0.0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '0.0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });
  });

// Tests if division between a zero and a positive non-zero value
// will return zero.
//
// In division, when zero is the numerator and the denominator is any
// non-zero number, the result is zero. This outcome is standard across
// most programming languages and mathematical rules. For example:
//
// 0 / 20 = 0
//
// The example above demonstrates that dividing zero by any non-zero value
// does not result in an error. It is only when the denominator is zero that
// an error occurs, highlighting the importance of operand order in division.
  group('zero divided by non-zero (zero + positive)', () {
    test('should return zero if dividing by BigInteger', () {
      final value1 = Numeric(value: '0');
      final value2 = BigInteger(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Integer', () {
      final value1 = Numeric(value: '0');
      final value2 = Integer(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallInteger', () {
      final value1 = Numeric(value: '0');
      final value2 = SmallInteger(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by BigSerial', () {
      final value1 = Numeric(value: '0');
      final value2 = BigSerial(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Serial', () {
      final value1 = Numeric(value: '0');
      final value2 = Serial(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallSerial', () {
      final value1 = Numeric(value: '0');
      final value2 = SmallSerial(20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int primitive', () {
      final value1 = Numeric(value: '0');
      const value2 = 20;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued double primitive',
        () {
      final value1 = Numeric(value: '0');
      const value2 = 20.0;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional double primitive', () {
      final value1 = Numeric(value: '0');
      const value2 = 20.5;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued Real', () {
      final value1 = Numeric(value: '0');
      final value2 = Real(20.0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Real', () {
      final value1 = Numeric(value: '0');
      final value2 = Real(20.5);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '0');
      final value2 = DoublePrecision(20.0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional DoublePrecision', () {
      final value1 = Numeric(value: '0');
      final value2 = DoublePrecision(20.5);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '20');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '20.5');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '20');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '20.5');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division between a zero and a negative non-zero value
// will return zero.
//
// In division, zero divided by any non-zero number results in zero,
// regardless of whether the non-zero number is positive or negative.
// This rule applies uniformly in mathematical operations within
// programming. For example:
//
// 0 / -20 = 0
//
// The example above illustrates that dividing zero by any non-zero value
// does not produce an error. Errors occur only when attempting to divide
// by zero, as per standard error handling practices in programming.
//
// Observations:
// - Tests also exclude [Serial types] since their minimum {value} is 1,
//   preventing them from storing 0 as a value, thereby not suitable for
//   testing division involving a zero numerator.

  group('zero divided by non-zero (zero + negative)', () {
    test('should return zero if dividing by BigInteger', () {
      final value1 = Numeric(value: '0');
      final value2 = BigInteger(-20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by Integer', () {
      final value1 = Numeric(value: '0');
      final value2 = Integer(-20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by SmallInteger', () {
      final value1 = Numeric(value: '0');
      final value2 = SmallInteger(-20);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int primitive', () {
      final value1 = Numeric(value: '0');
      const value2 = -20;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued double primitive',
        () {
      final value1 = Numeric(value: '0');
      const value2 = -20.0;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional double primitive', () {
      final value1 = Numeric(value: '0');
      const value2 = -20.5;
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued Real', () {
      final value1 = Numeric(value: '0');
      final value2 = Real(-20.0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Real', () {
      final value1 = Numeric(value: '0');
      final value2 = Real(-20.5);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by integer-valued DoublePrecision',
        () {
      final value1 = Numeric(value: '0');
      final value2 = DoublePrecision(-20.0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional DoublePrecision', () {
      final value1 = Numeric(value: '0');
      final value2 = DoublePrecision(-20.5);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '-20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '-20');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '-20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '-20.5');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by int Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '-20', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained int Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '-20');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by float Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '-20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by unconstrained float Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '-20.5');
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero if dividing by fractional Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '-0.3', precision: 1, scale: 1);
      final expected = Numeric(value: '0', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division between two zero values will throw an {ArgumentError}.
//
// In division, zero divided by zero is undefined and typically results in
// an indeterminate form in mathematics. In programming, this scenario
// is generally handled by throwing an error to prevent undefined behavior.
// For example:
//
// 0 / 0 = ? -> Undefined
//
// This handling is consistent across programming environments that adhere to
// standard practices for error management when division by zero is attempted.
//
// Observations:
// - There are no tests for [fractional arbitrary types] because these types
//   cannot meaningfully represent a zero value, which is crucial for this test.
// - Additionally, there are no tests for [Serial types] as their minimum {value}
//   is 1, and thus they are incapable of storing 0 as a value.
  group('zero divided by zero', () {
    test('should throw ArgumentError if dividing by BigInteger zero', () {
      final value1 = Numeric(value: '0');
      final value2 = BigInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Integer zero', () {
      final value1 = Numeric(value: '0');
      final value2 = Integer(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by SmallInteger zero', () {
      final value1 = Numeric(value: '0');
      final value2 = SmallInteger(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int primitive zero', () {
      final value1 = Numeric(value: '0');
      const value2 = 0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by double primitive zero', () {
      final value1 = Numeric(value: '0');
      const value2 = 0.0;
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by Real zero', () {
      final value1 = Numeric(value: '0');
      final value2 = Real(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by DoublePrecision zero', () {
      final value1 = Numeric(value: '0');
      final value2 = DoublePrecision(0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Numeric',
        () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Numeric', () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Numeric',
        () {
      final value1 = Numeric(value: '0');
      final value2 = Numeric(value: '0.0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by int zero Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained int zero Decimal',
        () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '0');
      expect(() => value1 / value2, throwsArgumentError);
    });

    test('should throw ArgumentError if dividing by float zero Decimal', () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      expect(() => value1 / value2, throwsArgumentError);
    });

    test(
        'should throw ArgumentError if dividing by unconstrained float zero Decimal',
        () {
      final value1 = Numeric(value: '0');
      final value2 = Decimal(value: '0.0');
      expect(() => value1 / value2, throwsArgumentError);
    });
  });

// Tests if division between a positive non-zero value and a
// positive one will return the first operand.
//
// In division, any number divided by one results in the number itself,
// as division by one does not change the value. For example:
//
// 20 / 1 = 20
//
// This property holds true across all standard numerical types and is
// fundamental to understanding division operations.
//
// Observations:
// - There are no tests for [fractional floating point] types or
//   [fractional arbitrary types] in this group, as these types are not
//   designed to represent pure integer values.
  group('division by one', () {
    test('should return itself when dividing by BigInteger one', () {
      final value1 = Numeric(value: '30');
      final value2 = BigInteger(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Integer one', () {
      final value1 = Numeric(value: '30');
      final value2 = Integer(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by SmallInteger one', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallInteger(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by BigSerial one', () {
      final value1 = Numeric(value: '30');
      final value2 = BigSerial(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Serial one', () {
      final value1 = Numeric(value: '30');
      final value2 = Serial(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by SmallSerial one', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallSerial(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by Real one', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by DoublePrecision one', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by int Numeric one', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by unconstrained int Numeric one',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '1');
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by float Numeric one', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '1.0', precision: 2, scale: 1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return itself when dividing by unconstrained float Numeric one',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '1');
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by int Decimal one', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by unconstrained int Decimal one',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '1');
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return itself when dividing by float Decimal one', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '1.0', precision: 2, scale: 1);
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return itself when dividing by unconstrained float Decimal one',
        () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '1');
      final expected = Numeric(value: '30', precision: 22, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division between a positive non-zero value and
// itself will return one.
//
// In division, any number divided by itself results in one,
// regardless of the value, provided it's non-zero. This is a
// fundamental property of division. For example:
//
// 20 / 20 = 1
//
// This test confirms the consistent behavior of division operations
// when a number is divided by itself.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] in this group, as these types do not
//   typically represent exact integer values, and the tests are focused
//   on exact integer behavior.
  group('division by itself (positive)', () {
    test('should return one when dividing by BigInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = BigInteger(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Integer', () {
      final value1 = Numeric(value: '30');
      final value2 = Integer(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallInteger', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallInteger(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by BigSerial', () {
      final value1 = Numeric(value: '30');
      final value2 = BigSerial(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Serial', () {
      final value1 = Numeric(value: '30');
      final value2 = Serial(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallSerial', () {
      final value1 = Numeric(value: '30');
      final value2 = SmallSerial(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int primitive', () {
      final value1 = Numeric(value: '30');
      const value2 = 30;
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by double primitive', () {
      final value1 = Numeric(value: '30');
      const value2 = 30.0;
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Real', () {
      final value1 = Numeric(value: '30');
      final value2 = Real(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by DoublePrecision', () {
      final value1 = Numeric(value: '30');
      final value2 = DoublePrecision(30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Numeric', () {
      final value1 = Numeric(value: '30');
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '30');
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Decimal', () {
      final value1 = Numeric(value: '30');
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if division between a negative non-zero value and
// itself will return one.
//
// In division, any number divided by itself results in one,
// even if the number is negative. This demonstrates a universal
// property of division. For example:
//
// -20 / -20 = 1
//
// This test verifies that division operations maintain consistency
// when a number is divided by itself, regardless of the sign.
//
// Observations:
// - There are no tests for [fractional floating point] or
//   [fractional arbitrary types] in this group, as these types do not
//   typically represent exact integer values, particularly in the context
//   of testing division for exact outcomes.
// - Additionally, there are no tests for [Serial types] since their
//   minimum {value} is 1, making it impossible for them to store negative
//   values. This excludes them from tests involving negative numbers.
  group('division by itself (negative)', () {
    test('should return one when dividing by BigInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = BigInteger(-30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Integer', () {
      final value1 = Numeric(value: '-30');
      final value2 = Integer(-30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by SmallInteger', () {
      final value1 = Numeric(value: '-30');
      final value2 = SmallInteger(-30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int primitive', () {
      final value1 = Numeric(value: '-30');
      const value2 = -30;
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by double primitive', () {
      final value1 = Numeric(value: '-30');
      const value2 = -30.0;
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by Real', () {
      final value1 = Numeric(value: '-30');
      final value2 = Real(-30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by DoublePrecision', () {
      final value1 = Numeric(value: '-30');
      final value2 = DoublePrecision(-30);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Numeric', () {
      final value1 = Numeric(value: '-30');
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained int Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-30');
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return one when dividing by unconstrained float Decimal', () {
      final value1 = Numeric(value: '-30');
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '1', precision: 21, scale: 20);
      final operation = value1 / value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if performing division with operands of different
// types will correctly cast both operands and return the final
// result of the expected type.
//
// This group of tests ensures that type casting operates correctly
// when operands involved in division are of different types. The
// primary objective here is to validate the resultant data type after
// operation, rather than the numerical outcome of the division.
// Testing for division resulting values is covered in other
// groups within this file.
//
// Observations:
// - The value '1' is used in most operations instead of '0' due to the
//   minimum {value} requirement of [Serial types], which is 1. This
//   adjustment avoids complications associated with zero values and
//   ensures consistency across tests involving [Serial types].
  group('type casting', () {
    test('should return Numeric as result when dividing BigInteger', () {
      final value1 = Numeric(value: '1');
      final value2 = BigInteger(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative BigInteger',
        () {
      final value1 = Numeric(value: '1');
      final value2 = BigInteger(-1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing Integer', () {
      final value1 = Numeric(value: '1');
      final value2 = Integer(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative Integer', () {
      final value1 = Numeric(value: '1');
      final value2 = Integer(-1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing SmallInteger', () {
      final value1 = Numeric(value: '1');
      final value2 = SmallInteger(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative SmallInteger',
        () {
      final value1 = Numeric(value: '1');
      final value2 = SmallInteger(-1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing BigSerial', () {
      final value1 = Numeric(value: '1');
      final value2 = BigSerial(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing Serial', () {
      final value1 = Numeric(value: '1');
      final value2 = Serial(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing SmallSerial', () {
      final value1 = Numeric(value: '1');
      final value2 = SmallSerial(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing int primitive', () {
      final value1 = Numeric(value: '1');
      const value2 = 1;
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative int primitive',
        () {
      final value1 = Numeric(value: '1');
      const value2 = -1;
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing double primitive', () {
      final value1 = Numeric(value: '1');
      const value2 = 1.5;
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when dividing negative double primitive',
        () {
      final value1 = Numeric(value: '1');
      const value2 = -1.5;
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing Real', () {
      final value1 = Numeric(value: '1');
      final value2 = Real(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative Real', () {
      final value1 = Numeric(value: '1');
      final value2 = Real(-1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing DoublePrecision', () {
      final value1 = Numeric(value: '1');
      final value2 = DoublePrecision(1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when dividing negative DoublePrecision',
        () {
      final value1 = Numeric(value: '1');
      final value2 = DoublePrecision(-1);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing Numeric', () {
      final value1 = Numeric(value: '1');
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative Numeric', () {
      final value1 = Numeric(value: '1');
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing Decimal', () {
      final value1 = Numeric(value: '1');
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when dividing negative Decimal', () {
      final value1 = Numeric(value: '1');
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 / value2;
      expect(operation, isA<Numeric>());
    });
  });
}
