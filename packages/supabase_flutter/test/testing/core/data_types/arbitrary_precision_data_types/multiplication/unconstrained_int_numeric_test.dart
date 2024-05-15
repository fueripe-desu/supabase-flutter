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
// Tests multiplication where both operands are positive.
//
// This group of tests evaluates the behavior of multiplication operations
// when both operands are positive, across all supported data types according
// to PostgreSQL's general rules. In these cases, the result is consistently
// positive.
//
// The primary focus of these tests is on the resulting value and sign, rather
// than the data type; type casting considerations are addressed in a separate
// test group within this file.
//
// Note: No tests are conducted for [unconstrained] [fractional arbitrary types]
// because combining these characteristics is not feasible. An [arbitrary precision type]
// cannot simultaneously be [unconstrained] and [fractional]. Attempting this configuration
// leads to a [float] rather than a [fractional]:
//
// Numeric(value: '0.35', precision: 2, scale: 2) -> Fractional
// Numeric(value: '3.14', precision: 3, scale: 2) -> Float
// Numeric(value: '0.13') -> Float, as '0' is treated as a significant digit
//
// The same principle applies to [arbitrary precision types with negative scale]:
// Defining these requires specifying a {scale}, making them inherently constrained:
//
// Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
// Numeric(value: '1349') -> Unconstrained integer Numeric with the value '1349'
  group('positive multiplication', () {
    test('should correctly multiply BigInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = BigInteger(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Integer', () {
      final value1 = Numeric(value: '20');
      final value2 = Integer(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = SmallInteger(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply BigSerial', () {
      final value1 = Numeric(value: '20');
      final value2 = BigSerial(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Serial', () {
      final value1 = Numeric(value: '20');
      final value2 = Serial(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallSerial', () {
      final value1 = Numeric(value: '20');
      final value2 = SmallSerial(30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int', () {
      final value1 = Numeric(value: '20');
      const value2 = 30;
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued double', () {
      final value1 = Numeric(value: '20');
      const value2 = 30.0;
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional double', () {
      final value1 = Numeric(value: '20');
      const value2 = 30.5;
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued Real', () {
      final value1 = Numeric(value: '20');
      final value2 = Real(30.0);
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Real', () {
      final value1 = Numeric(value: '20');
      final value2 = Real(30.5);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '20');
      final value2 = DoublePrecision(30.0);
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional DoublePrecision', () {
      final value1 = Numeric(value: '20');
      final value2 = DoublePrecision(30.5);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '7.0', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Numeric with negative scale', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '30');
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '30.5');
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '7.0', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Decimal with negative scale', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests multiplication where both operands are negative.
//
// This group of tests confirms the correct behavior of multiplication operations
// when both operands are negative, across all supported data types, following
// PostgreSQL's general rules. The result of multiplying two negative numbers
// is consistently positive.
//
// The focus of these tests is on the resulting value and sign, rather than the
// final data type; type casting considerations are addressed in a separate
// test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
//   {value} is 1, which precludes the storage of negative values.
//
// - Tests do not include [unconstrained] [arbitrary types with negative scale],
//   because defining such types necessitates specifying a {scale}, making
//   them inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained integer Numeric with the value '1349'
  group('negative multiplication', () {
    test('should correctly multiply BigInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = BigInteger(-30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Integer', () {
      final value1 = Numeric(value: '-20');
      final value2 = Integer(-30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = SmallInteger(-30);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int', () {
      final value1 = Numeric(value: '-20');
      const value2 = -30;
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued double', () {
      final value1 = Numeric(value: '-20');
      const value2 = -30.0;
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional double', () {
      final value1 = Numeric(value: '-20');
      const value2 = -30.5;
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued Real', () {
      final value1 = Numeric(value: '-20');
      final value2 = Real(-30.0);
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Real', () {
      final value1 = Numeric(value: '-20');
      final value2 = Real(-30.5);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '-20');
      final value2 = DoublePrecision(-30.0);
      final expected = Numeric(value: '600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20');
      final value2 = DoublePrecision(-30.5);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Numeric with negative scale', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-30');
      final expected = Numeric(value: '600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-30.5');
      final expected = Numeric(value: '610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Decimal with negative scale', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests multiplication where the first operand is positive and the
// second is negative.
//
// This group of tests evaluates the correct behavior of multiplication
// operations when the operands have different signs: one positive and
// one negative. The tests confirm that the behavior aligns with
// PostgreSQL's general rules across all supported data types.
//
// In such cases of mixed-sign multiplication, the result is always negative.
//
// The primary focus of these tests is on the resulting value and sign,
// rather than on the final data type. Type casting issues are handled
// separately in another test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum
//   {value} is 1, which precludes the storage of negative values.
//
// - Tests do not include [unconstrained] [arbitrary types with negative scale],
//   because defining such types necessitates specifying a {scale}, making
//   them inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained integer Numeric with the value '1349'
  group('mixed sign multiplication (positive + negative)', () {
    test('should correctly multiply BigInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = BigInteger(-30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Integer', () {
      final value1 = Numeric(value: '20');
      final value2 = Integer(-30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = SmallInteger(-30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int', () {
      final value1 = Numeric(value: '20');
      const value2 = -30;
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued double', () {
      final value1 = Numeric(value: '20');
      const value2 = -30.0;
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional double', () {
      final value1 = Numeric(value: '20');
      const value2 = -30.5;
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply a integer-valued Real', () {
      final value1 = Numeric(value: '20');
      final value2 = Real(-30.0);
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply a fractional Real', () {
      final value1 = Numeric(value: '20');
      final value2 = Real(-30.5);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply a integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '20');
      final value2 = DoublePrecision(-30.0);
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply a fractional DoublePrecision', () {
      final value1 = Numeric(value: '20');
      final value2 = DoublePrecision(-30.5);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Numeric with negative scale', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-30');
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-30.5');
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Decimal with negative scale', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests multiplication where the first operand is negative and the
// second is positive.
//
// This group of tests evaluates the correct behavior of multiplication
// operations when the first operand is negative and the second is positive.
// The tests ensure that the behavior is consistent across all supported
// data types, following PostgreSQL's general rules.
//
// In cases of multiplication where operands have opposite signs, the result
// is always negative.
//
// The focus of these tests is on the resulting value and sign, rather than
// on the final data type. Type casting issues are addressed separately in
// another test group within this file.
//
// Observations:
// - Tests do not include [unconstrained] [arbitrary types with negative scale],
//   because defining such types necessitates specifying a {scale}, making
//   them inherently constrained:
//
//   Numeric(value: '1349', precision: 4, scale: -3) -> Rounded to '1000'
//   Numeric(value: '1349') -> Unconstrained integer Numeric with the value '1349'
  group('mixed sign multiplication (negative + positive)', () {
    test('should correctly multiply BigInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = BigInteger(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Integer', () {
      final value1 = Numeric(value: '-20');
      final value2 = Integer(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = SmallInteger(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply BigSerial', () {
      final value1 = Numeric(value: '-20');
      final value2 = BigSerial(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply Serial', () {
      final value1 = Numeric(value: '-20');
      final value2 = Serial(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply SmallSerial', () {
      final value1 = Numeric(value: '-20');
      final value2 = SmallSerial(30);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int', () {
      final value1 = Numeric(value: '-20');
      const value2 = 30;
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued double', () {
      final value1 = Numeric(value: '-20');
      const value2 = 30.0;
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional double', () {
      final value1 = Numeric(value: '-20');
      const value2 = 30.5;
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued Real', () {
      final value1 = Numeric(value: '-20');
      final value2 = Real(30.0);
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Real', () {
      final value1 = Numeric(value: '-20');
      final value2 = Real(30.5);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply integer-valued DoublePrecision', () {
      final value1 = Numeric(value: '-20');
      final value2 = DoublePrecision(30.0);
      final expected = Numeric(value: '-600.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional DoublePrecision', () {
      final value1 = Numeric(value: '-20');
      final value2 = DoublePrecision(30.5);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Numeric with negative scale', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply int Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained int Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '30');
      final expected = Numeric(value: '-600', precision: 3, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply float Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply unconstrained float Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '30.5');
      final expected = Numeric(value: '-610.0', precision: 4, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly multiply fractional Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-7.00', precision: 3, scale: 2);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly multiply Decimal with negative scale', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-20000', precision: 5, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if multiplying by zero (either positive or negative values) always
// returns zero.
//
// This group of tests confirms that any multiplication involving zero—whether
// with positive or negative values—results consistently in zero. Examples
// include:
//
// 20 * 0 = 0
// -20 * 0 = 0
//
// The primary focus of these tests is on ensuring the multiplication results
// in zero, irrespective of other factors, rather than on the data type of the
// result. Type casting concerns are addressed in a separate test group within
// this file.
//
// Note: Tests include [arbitrary precision types with negative scale]. Although
// it might seem unnecessary, consider this:
//
// Numeric(value: '1231', precision: 4, scale: -8)
//
// With a negative {scale} exceeding the significance of the digits, adjusting
// the {scale} appropriately is crucial to prevent a non-zero result. For '1231'
// (4 digits), the maximum {scale} should be -3 (abs(-3) == 3), which scales
// '1231' to the nearest  1000 when multiplied by 10^abs(-3). However, with a
// {scale} of -8, multiplying '1231' by 10^abs(-8) equals 100000000, rounding
// '1231' to the nearest 100000000 results in 0.
//
// Observations:
// - No tests are conducted for [Serial types], as their minimum value is 1 and
// they cannot represent zero. Similarly, [fractional arbitrary precision types]
// are excluded as they do not commonly represent exact zeros (0.0).
  group('zero cases', () {
    test('should retain positive sign when multiplying BigInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = BigInteger(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying BigInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = BigInteger(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying Integer', () {
      final value1 = Numeric(value: '20');
      final value2 = Integer(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying Integer', () {
      final value1 = Numeric(value: '-20');
      final value2 = Integer(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying SmallInteger', () {
      final value1 = Numeric(value: '20');
      final value2 = SmallInteger(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying SmallInteger', () {
      final value1 = Numeric(value: '-20');
      final value2 = SmallInteger(0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying int primitive', () {
      final value1 = Numeric(value: '20');
      const value2 = 0;
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying int primitive', () {
      final value1 = Numeric(value: '-20');
      const value2 = 0;
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying double', () {
      final value1 = Numeric(value: '20');
      const value2 = 0.0;
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying double', () {
      final value1 = Numeric(value: '-20');
      const value2 = 0.0;
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying int Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying int Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when multiplying unconstrained int Numeric',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when multiplying unconstrained int Numeric',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying float Numeric', () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying float Numeric', () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when multiplying unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when multiplying unconstrained float Numeric',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when multiplying positive Numeric with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when multiplying positive Numeric with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when multiplying negative Numeric with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when multiplying negative Numeric with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying int Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying int Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when multiplying unconstrained int Decimal',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '0');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when multiplying unconstrained int Decimal',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '0');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when multiplying float Decimal', () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when multiplying float Decimal', () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain positive sign when multiplying unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '0.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should retain negative sign when multiplying unconstrained float Decimal',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '0.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when multiplying positive Decimal with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when multiplying positive Decimal with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when multiplying negative Decimal with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '20');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when multiplying negative Decimal with negative scale greater than its value',
        () {
      final value1 = Numeric(value: '-20');
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if multiplication with operands of different types
// correctly casts both operands and returns the expected final type.
//
// This group of tests verifies that type casting functions properly when
// operands of different types are used in multiplication. The tests ensure
// that the operation conforms to expected type behavior.
//
// The primary focus of these tests is on the final data type of the result,
// rather than on the arithmetic value. Issues concerning the calculation
// of multiplication values are addressed in other test groups within this file.
//
// Observations:
// - The value 1 is used in most operations instead of 0 to accommodate
// the minimum value requirement of [Serial types], which is 1.
  group('type casting', () {
    test('should return Numeric as result when multiplying BigInteger', () {
      final value1 = Numeric(value: '1');
      final value2 = BigInteger(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying negative BigInteger',
        () {
      final value1 = Numeric(value: '1');
      final value2 = BigInteger(-1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying Integer', () {
      final value1 = Numeric(value: '1');
      final value2 = Integer(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying negative Integer',
        () {
      final value1 = Numeric(value: '1');
      final value2 = Integer(-1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying SmallInteger', () {
      final value1 = Numeric(value: '1');
      final value2 = SmallInteger(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when multiplying negative SmallInteger',
        () {
      final value1 = Numeric(value: '1');
      final value2 = SmallInteger(-1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying BigSerial', () {
      final value1 = Numeric(value: '1');
      final value2 = BigSerial(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying Serial', () {
      final value1 = Numeric(value: '1');
      final value2 = Serial(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying SmallSerial', () {
      final value1 = Numeric(value: '1');
      final value2 = SmallSerial(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying int primitive', () {
      final value1 = Numeric(value: '1');
      const value2 = 1;
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when multiplying negative int primitive',
        () {
      final value1 = Numeric(value: '1');
      const value2 = -1;
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying double primitive',
        () {
      final value1 = Numeric(value: '1');
      const value2 = 1.5;
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when multiplying negative double primitive',
        () {
      final value1 = Numeric(value: '1');
      const value2 = -1.5;
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying Real', () {
      final value1 = Numeric(value: '1');
      final value2 = Real(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying negative Real', () {
      final value1 = Numeric(value: '1');
      final value2 = Real(-1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying DoublePrecision',
        () {
      final value1 = Numeric(value: '1');
      final value2 = DoublePrecision(1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test(
        'should return Numeric as result when multiplying negative DoublePrecision',
        () {
      final value1 = Numeric(value: '1');
      final value2 = DoublePrecision(-1);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying Numeric', () {
      final value1 = Numeric(value: '1');
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying negative Numeric',
        () {
      final value1 = Numeric(value: '1');
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying Decimal', () {
      final value1 = Numeric(value: '1');
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when multiplying negative Decimal',
        () {
      final value1 = Numeric(value: '1');
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 * value2;
      expect(operation, isA<Numeric>());
    });
  });
}
