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
// Tests addition operations with positive operands.
//
// This test group checks the correctness of addition operations with positive
// operands across all supported data types in PostgreSQL. The focus is on two
// primary aspects: the accuracy of the resultant value and ensuring that the
// operation can be executed successfully without errors or unexpected behavior
// for each data type. Tests related to type casting are handled separately in
// another group within this file.
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
  group('positive addition', () {
    test('should correctly add BigInteger', () {
      final value1 = SmallInteger(20);
      final value2 = BigInteger(30);
      final expected = BigInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Integer', () {
      final value1 = SmallInteger(20);
      final value2 = Integer(30);
      final expected = Integer(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallInteger', () {
      final value1 = SmallInteger(20);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add BigSerial', () {
      final value1 = SmallInteger(20);
      final value2 = BigSerial(30);
      final expected = SmallInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Serial', () {
      final value1 = SmallInteger(20);
      final value2 = Serial(30);
      final expected = SmallInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallSerial', () {
      final value1 = SmallInteger(20);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int', () {
      final value1 = SmallInteger(20);
      const value2 = 30;
      final expected = SmallInteger(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued double', () {
      final value1 = SmallInteger(20);
      const value2 = 30.0;
      final expected = Real(50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional double', () {
      final value1 = SmallInteger(20);
      const value2 = 30.5;
      final expected = Real(50.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued Real', () {
      final value1 = SmallInteger(50);
      final value2 = Real(30.0);
      final expected = Real(80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Real', () {
      final value1 = SmallInteger(50);
      final value2 = Real(30.5);
      final expected = Real(80.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued DoublePrecision', () {
      final value1 = SmallInteger(50);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional DoublePrecision', () {
      final value1 = SmallInteger(50);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(80.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '50.35', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly add Numeric with negative scale', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '1050', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '50.35', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly add Decimal with negative scale', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '1050', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests addition operations with negative operands.
//
// This test group checks the correctness of addition operations with negative
// operands across all supported data types in PostgreSQL. The focus is on two
// primary aspects: the accuracy of the resultant value and ensuring that the
// operation can be executed successfully without errors or unexpected behavior
// for each data type. Tests related to type casting are handled separately in
// another group within this file.
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
  group('negative addition', () {
    test('should correctly add BigInteger', () {
      final value1 = SmallInteger(-50);
      final value2 = BigInteger(-30);
      final expected = BigInteger(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Integer', () {
      final value1 = SmallInteger(-50);
      final value2 = Integer(-30);
      final expected = Integer(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallInteger', () {
      final value1 = SmallInteger(-50);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int', () {
      final value1 = SmallInteger(-20);
      const value2 = -30;
      final expected = SmallInteger(-50);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued double', () {
      final value1 = SmallInteger(-50);
      const value2 = -30.0;
      final expected = Real(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional double', () {
      final value1 = SmallInteger(-50);
      const value2 = -30.5;
      final expected = Real(-80.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued Real', () {
      final value1 = SmallInteger(-50);
      final value2 = Real(-30.0);
      final expected = Real(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Real', () {
      final value1 = SmallInteger(-50);
      final value2 = Real(-30.5);
      final expected = Real(-80.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued DoublePrecision', () {
      final value1 = SmallInteger(-50);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(-80);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional DoublePrecision', () {
      final value1 = SmallInteger(-50);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(-80.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '-80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '-80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly add Numeric with negative scale', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-1050', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '-80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '-80', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '-80.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-50.35', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly add Decimal with negative scale', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-1050', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests addition operations where the first operand is positive and the second
// is negative.
//
// This test group checks the correctness of mixed sign addition operations,
// where the first operand is positive and the second is negative, across all
// supported data types in PostgreSQL. The focus is on two primary aspects:
// the accuracy of the resultant value and ensuring that the operation can be
// executed successfully without errors or unexpected behavior for each data
// type. Tests related to type casting are handled separately in another group
// within this file.
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
  group('mixed sign addition (positive + negative)', () {
    test('should correctly add BigInteger', () {
      final value1 = SmallInteger(50);
      final value2 = BigInteger(-30);
      final expected = BigInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Integer', () {
      final value1 = SmallInteger(50);
      final value2 = Integer(-30);
      final expected = Integer(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallInteger', () {
      final value1 = SmallInteger(50);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int', () {
      final value1 = SmallInteger(50);
      const value2 = -30;
      final expected = SmallInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued double', () {
      final value1 = SmallInteger(50);
      const value2 = -30.0;
      final expected = Real(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional double', () {
      final value1 = SmallInteger(50);
      const value2 = -30.5;
      final expected = Real(19.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add a integer-valued Real', () {
      final value1 = SmallInteger(50);
      final value2 = Real(-30.0);
      final expected = Real(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add a fractional Real', () {
      final value1 = SmallInteger(50);
      final value2 = Real(-30.5);
      final expected = Real(19.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add a integer-valued DoublePrecision', () {
      final value1 = SmallInteger(50);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add a fractional DoublePrecision', () {
      final value1 = SmallInteger(50);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(19.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly add Numeric with negative scale', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-950', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should correctly add Decimal with negative scale', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-950', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests addition where the first operand is negative and the second is positive.
//
// This test group verifies the correct behavior of addition operations
// when the first operand is negative and the second is positive, across
// all supported data types in PostgreSQL. The focus is on ensuring accurate
// results from these operations, conforming to PostgreSQL's general rules.
//
// The primary emphasis of these tests is on the resultant value of the operation,
// rather than on data type conversions; type casting is evaluated separately
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
  group('mixed sign addition (negative + positive)', () {
    test('should correctly add BigInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = BigInteger(30);
      final expected = BigInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Integer', () {
      final value1 = SmallInteger(-20);
      final value2 = Integer(30);
      final expected = Integer(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add BigSerial', () {
      final value1 = SmallInteger(-20);
      final value2 = BigSerial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add Serial', () {
      final value1 = SmallInteger(-20);
      final value2 = Serial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add SmallSerial', () {
      final value1 = SmallInteger(-20);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int', () {
      final value1 = SmallInteger(-20);
      const value2 = 30;
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued double', () {
      final value1 = SmallInteger(-20);
      const value2 = 30.0;
      final expected = Real(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional double', () {
      final value1 = SmallInteger(-20);
      const value2 = 30.5;
      final expected = Real(10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued Real', () {
      final value1 = SmallInteger(-50);
      final value2 = Real(30.0);
      final expected = Real(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Real', () {
      final value1 = SmallInteger(-50);
      final value2 = Real(30.5);
      final expected = Real(-19.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add integer-valued DoublePrecision', () {
      final value1 = SmallInteger(-50);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional DoublePrecision', () {
      final value1 = SmallInteger(-50);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(-19.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly add Numeric with negative scale', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '950', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add int Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained int Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add float Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add unconstrained float Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '-19.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should correctly add fractional Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should correctly add Decimal with negative scale', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '950', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition where the first operand is positive and the second is negative
// yields a positive result correctly.
//
// This group of tests ensures that the addition of two operands with distinct signs
// where the first operand is positive and the second is negative can correctly yield
// a positive result. This outcome occurs only when:
//
// The positive operand has a greater absolute value than the negative one. For example:
//
// In the operation 5 + (-3), because abs(5) > abs(-3), the result is 2, which is a
// positive outcome.
//
// The focus of these tests is on the resulting value and sign rather than on the data
// type; type casting is assessed separately in another test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('positive result tests (positive + negative)', () {
    test('should return positive value when adding BigInteger', () {
      final value1 = SmallInteger(40);
      final value2 = BigInteger(-30);
      final expected = BigInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding Integer', () {
      final value1 = SmallInteger(40);
      final value2 = Integer(-30);
      final expected = Integer(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding SmallInteger', () {
      final value1 = SmallInteger(40);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int primitive', () {
      final value1 = SmallInteger(40);
      const value2 = -30;
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding integer-valued double', () {
      final value1 = SmallInteger(40);
      const value2 = -30.0;
      final expected = Real(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional double', () {
      final value1 = SmallInteger(40);
      const value2 = -30.5;
      final expected = Real(9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding integer-valued Real', () {
      final value1 = SmallInteger(40);
      final value2 = Real(-30.0);
      final expected = Real(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional Real', () {
      final value1 = SmallInteger(40);
      final value2 = Real(-30.5);
      final expected = Real(9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when adding integer-valued DoublePrecision',
        () {
      final value1 = SmallInteger(40);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional DoublePrecision',
        () {
      final value1 = SmallInteger(40);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int Numeric', () {
      final value1 = SmallInteger(40);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(40);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding float Numeric', () {
      final value1 = SmallInteger(40);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(40);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional Numeric', () {
      final value1 = SmallInteger(50);
      final value2 = Numeric(value: '-0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return positive value when adding Numeric with negative scale',
        () {
      final value1 = SmallInteger(2000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '1000', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int Decimal', () {
      final value1 = SmallInteger(40);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(40);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding float Decimal', () {
      final value1 = SmallInteger(40);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(40);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional Decimal', () {
      final value1 = SmallInteger(50);
      final value2 = Decimal(value: '-0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return positive value when adding Decimal with negative scale',
        () {
      final value1 = SmallInteger(2000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '1000', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests addition where the first operand is negative and the second is positive.
//
// This test group verifies that when adding two numbers of different signs,
// specifically, a negative first operand and a positive second operand—the result
// can indeed be positive. Such a scenario occurs under the condition that:
//
// The absolute value of the negative operand is less than that of the positive
// operand. For instance, -2 + 10 results in 8 because abs(-2) < abs(10), thus
// yielding a positive result.
//
// These tests focus on evaluating the arithmetic result in terms of value and sign,
// rather than data type integrity, which is assessed in a separate test group.
//
// Observations:
// - Tests for [fractional arbitrary types] are omitted because it is mathematically
// infeasible for an [Integer type] to be smaller than any [fractional arbitrary type].
// This is because [fractional arbitrary types] include values between 0 and 1, which
// an integer cannot represent, thereby precluding scenarios that would yield a positive
// result from such comparisons.
  group('positive result tests (negative + positive)', () {
    test('should return positive value when adding BigInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = BigInteger(30);
      final expected = BigInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding Integer', () {
      final value1 = SmallInteger(-20);
      final value2 = Integer(30);
      final expected = Integer(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding SmallInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding BigSerial', () {
      final value1 = SmallInteger(-20);
      final value2 = BigSerial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding Serial', () {
      final value1 = SmallInteger(-20);
      final value2 = Serial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding SmallSerial', () {
      final value1 = SmallInteger(-20);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int primitive', () {
      final value1 = SmallInteger(-20);
      const value2 = 30;
      final expected = SmallInteger(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding integer-valued double', () {
      final value1 = SmallInteger(-20);
      const value2 = 30.0;
      final expected = Real(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional double', () {
      final value1 = SmallInteger(-20);
      const value2 = 30.5;
      final expected = Real(10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding integer-valued Real', () {
      final value1 = SmallInteger(-20);
      final value2 = Real(30.0);
      final expected = Real(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional Real', () {
      final value1 = SmallInteger(-20);
      final value2 = Real(30.5);
      final expected = Real(10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return positive value when adding integer-valued DoublePrecision',
        () {
      final value1 = SmallInteger(-20);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding fractional DoublePrecision',
        () {
      final value1 = SmallInteger(-20);
      final value2 = DoublePrecision(30.5);
      final expected = DoublePrecision(10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int Numeric', () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding float Numeric', () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '30.5');
      final expected = Numeric(value: '10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return positive value when adding Numeric with negative scale',
        () {
      final value1 = SmallInteger(-500);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '500', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding int Decimal', () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding float Decimal', () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return positive value when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '30.5');
      final expected = Decimal(value: '10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return positive value when adding Decimal with negative scale',
        () {
      final value1 = SmallInteger(-500);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '500', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition where the first operand is positive and
// the second is negative yields a negative result correctly.
//
// This group of tests verifies that when adding two operands of
// opposite signs—specifically, a positive first operand and a negative
// second operand—the result is correctly negative. This occurs only if:
//
// The absolute value of the positive operand is less than that of the negative
// operand. For example, 2 + (-10) leads to -8 because abs(2) < abs(-10),
// thus, 2 + (-10) = -8, which is a negative result.
//
// These tests focus on assessing the arithmetic outcome in terms of value and sign,
// rather than data type integrity; type casting issues are addressed in a separate
// test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
  group('negative result tests (positive + negative)', () {
    test('should return negative value when adding BigInteger', () {
      final value1 = SmallInteger(20);
      final value2 = BigInteger(-30);
      final expected = BigInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding Integer', () {
      final value1 = SmallInteger(20);
      final value2 = Integer(-30);
      final expected = Integer(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding SmallInteger', () {
      final value1 = SmallInteger(20);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int primitive', () {
      final value1 = SmallInteger(20);
      const value2 = -30;
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding integer-valued double', () {
      final value1 = SmallInteger(20);
      const value2 = -30.0;
      final expected = Real(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional double', () {
      final value1 = SmallInteger(20);
      const value2 = -30.5;
      final expected = Real(-10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding integer-valued Real', () {
      final value1 = SmallInteger(20);
      final value2 = Real(-30.0);
      final expected = Real(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional Real', () {
      final value1 = SmallInteger(20);
      final value2 = Real(-30.5);
      final expected = Real(-10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when adding integer-valued DoublePrecision',
        () {
      final value1 = SmallInteger(20);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional DoublePrecision',
        () {
      final value1 = SmallInteger(20);
      final value2 = DoublePrecision(-30.5);
      final expected = DoublePrecision(-10.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int Numeric', () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding float Numeric', () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '-30.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '-30.5');
      final expected = Numeric(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return negative value when adding Numeric with negative scale',
        () {
      final value1 = SmallInteger(500);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-500', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int Decimal', () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding float Decimal', () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '-30.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '-30.5');
      final expected = Decimal(value: '-10.5', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return negative value when adding Decimal with negative scale',
        () {
      final value1 = SmallInteger(500);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-500', precision: 3, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition where the first operand is negative and
// the second is positive yields a negative result.
//
// This test group evaluates whether the addition of two operands with
// different signs—specifically a negative first operand and a positive
// second operand—results in a negative outcome. A negative result is
// achieved when:
//
// The absolute value of the negative operand is greater than that of the
// positive one. For example, -10 + 2 results in -8 because abs(-10) > abs(2),
// hence -10 + 2 = -8, which is a negative result.
//
// These tests focus on the arithmetic result in terms of value and sign,
// rather than on data type integrity, which is assessed in a separate test
// group within this file.
  group('negative result tests (negative + positive)', () {
    test('should return negative value when adding BigInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(20);
      final expected = BigInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding Integer', () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(20);
      final expected = Integer(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding SmallInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(20);
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding BigSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = BigSerial(20);
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding Serial', () {
      final value1 = SmallInteger(-30);
      final value2 = Serial(20);
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding SmallSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallSerial(20);
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int primitive', () {
      final value1 = SmallInteger(-30);
      const value2 = 20;
      final expected = SmallInteger(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding integer-valued double', () {
      final value1 = SmallInteger(-30);
      const value2 = 20.0;
      final expected = Real(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional double', () {
      final value1 = SmallInteger(-30);
      const value2 = 20.5;
      final expected = Real(-9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding integer-valued Real', () {
      final value1 = SmallInteger(-30);
      final value2 = Real(20.0);
      final expected = Real(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional Real', () {
      final value1 = SmallInteger(-30);
      final value2 = Real(20.5);
      final expected = Real(-9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test(
        'should return negative value when adding integer-valued DoublePrecision',
        () {
      final value1 = SmallInteger(-30);
      final value2 = DoublePrecision(20.0);
      final expected = DoublePrecision(-10);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional DoublePrecision',
        () {
      final value1 = SmallInteger(-30);
      final value2 = DoublePrecision(20.5);
      final expected = DoublePrecision(-9.5);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '20', precision: 2, scale: 0);
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '20');
      final expected = Numeric(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding float Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '20.5', precision: 3, scale: 1);
      final expected = Numeric(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '20.5');
      final expected = Numeric(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional Numeric', () {
      final value1 = SmallInteger(-50);
      final value2 = Numeric(value: '0.35', precision: 2, scale: 2);
      final expected = Numeric(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return negative value when adding Numeric with negative scale',
        () {
      final value1 = SmallInteger(-2000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '-1000', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding int Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '20', precision: 2, scale: 0);
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '20');
      final expected = Decimal(value: '-10', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding float Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '20.5', precision: 3, scale: 1);
      final expected = Decimal(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '20.5');
      final expected = Decimal(value: '-9.5', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return negative value when adding fractional Decimal', () {
      final value1 = SmallInteger(-50);
      final value2 = Decimal(value: '0.35', precision: 2, scale: 2);
      final expected = Decimal(value: '-49.65', precision: 4, scale: 2);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return negative value when adding Decimal with negative scale',
        () {
      final value1 = SmallInteger(-2000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '-1000', precision: 4, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition where the first operand is positive and the
// second is negative yields a zero result.
//
// This group of tests verifies that adding two operands of
// opposite signs, specifically a positive first operand and a negative
// second operand, can correctly result in a zero outcome. This occurs only when:
//
// The absolute value of the positive operand is equal to that of the
// negative one. For instance, 2 + (-2), because abs(2) == abs(-2), therefore,
// 2 + (-2) = 0, resulting in a zero outcome.
//
// The focus of these tests is on evaluating the arithmetic result in terms of
// value and sign, rather than data type integrity, which is evaluated in a
// separate test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - Tests for [fractional arbitrary types] are omitted because it is mathematically
// infeasible for an [Integer type] to be equal to any [fractional types]. This is
// because [fractional types] include values with fractional part, which an integer
// cannot represent, thereby precluding scenarios that would yield a zero result from
// such comparisons.
  group('zero result tests (positive + negative)', () {
    test('should return zero when adding BigInteger', () {
      final value1 = SmallInteger(30);
      final value2 = BigInteger(-30);
      final expected = BigInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding Integer', () {
      final value1 = SmallInteger(30);
      final value2 = Integer(-30);
      final expected = Integer(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding SmallInteger', () {
      final value1 = SmallInteger(30);
      final value2 = SmallInteger(-30);
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int primitive', () {
      final value1 = SmallInteger(30);
      const value2 = -30;
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued double', () {
      final value1 = SmallInteger(30);
      const value2 = -30.0;
      final expected = Real(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued Real', () {
      final value1 = SmallInteger(30);
      final value2 = Real(-30.0);
      final expected = Real(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued DoublePrecision', () {
      final value1 = SmallInteger(30);
      final value2 = DoublePrecision(-30.0);
      final expected = DoublePrecision(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int Numeric', () {
      final value1 = SmallInteger(30);
      final value2 = Numeric(value: '-30', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained int Numeric', () {
      final value1 = SmallInteger(30);
      final value2 = Numeric(value: '-30');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding float Numeric', () {
      final value1 = SmallInteger(30);
      final value2 = Numeric(value: '-30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained float Numeric', () {
      final value1 = SmallInteger(30);
      final value2 = Numeric(value: '-30.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return zero when adding Numeric with negative scale', () {
      final value1 = SmallInteger(1000);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -3);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int Decimal', () {
      final value1 = SmallInteger(30);
      final value2 = Decimal(value: '-30', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained int Decimal', () {
      final value1 = SmallInteger(30);
      final value2 = Decimal(value: '-30');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding float Decimal', () {
      final value1 = SmallInteger(30);
      final value2 = Decimal(value: '-30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained float Decimal', () {
      final value1 = SmallInteger(30);
      final value2 = Decimal(value: '-30.0');
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test('should return zero when adding Decimal with negative scale', () {
      final value1 = SmallInteger(1000);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -3);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition where the first operand is negative and the
// second is positive yields a zero result.
//
// This test group examines whether the addition of two operands with
// distinct signs—a negative first operand and a positive second operand—
// results in a zero outcome. This occurs only under the condition that:
//
// The absolute value of the negative operand is equal to that of the
// positive one. For instance, -10 + 10, because abs(-10) == abs(10),
// thus -10 + 10 = 0, leading to a zero result.
//
// These tests focus on the arithmetic outcome in terms of value and sign,
// rather than on data type integrity, which is addressed in a separate
// test group within this file.
//
// Observations:
// - [Serial types] are excluded from this test group because their minimum {value}
// is 1, and they cannot store negative values.
//
// - Tests for [fractional arbitrary types] are omitted because it is mathematically
// infeasible for an [Integer type] to be equal to any [fractional types]. This is
// because [fractional types] include values with fractional part, which an integer
// cannot represent, thereby precluding scenarios that would yield a zero result from
// such comparisons.
  group('zero result tests (negative + positive)', () {
    test('should return zero when adding BigInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = BigInteger(30);
      final expected = BigInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding Integer', () {
      final value1 = SmallInteger(-30);
      final value2 = Integer(30);
      final expected = Integer(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding SmallInteger', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallInteger(30);
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding BigSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = BigSerial(30);
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding Serial', () {
      final value1 = SmallInteger(-30);
      final value2 = Serial(30);
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding SmallSerial', () {
      final value1 = SmallInteger(-30);
      final value2 = SmallSerial(30);
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int primitive', () {
      final value1 = SmallInteger(-30);
      const value2 = 30;
      final expected = SmallInteger(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued double', () {
      final value1 = SmallInteger(-30);
      const value2 = 30.0;
      final expected = Real(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued Real', () {
      final value1 = SmallInteger(-30);
      final value2 = Real(30.0);
      final expected = Real(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding integer-valued DoublePrecision', () {
      final value1 = SmallInteger(-30);
      final value2 = DoublePrecision(30.0);
      final expected = DoublePrecision(0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '30', precision: 2, scale: 0);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained int Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '30');
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding float Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '30.0', precision: 3, scale: 1);
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained float Numeric', () {
      final value1 = SmallInteger(-30);
      final value2 = Numeric(value: '30.0');
      final expected = Numeric(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return zero when adding Numeric with negative scale', () {
      final value1 = SmallInteger(-1000);
      final value2 = Numeric(value: '1231', precision: 4, scale: -3);
      final expected = Numeric(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding int Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '30', precision: 2, scale: 0);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained int Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '30');
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding float Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '30.0', precision: 3, scale: 1);
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should return zero when adding unconstrained float Decimal', () {
      final value1 = SmallInteger(-30);
      final value2 = Decimal(value: '30.0');
      final expected = Decimal(value: '0.0', precision: 2, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test('should return zero when adding Decimal with negative scale', () {
      final value1 = SmallInteger(-1000);
      final value2 = Decimal(value: '1231', precision: 4, scale: -3);
      final expected = Decimal(value: '0', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if adding zero to positive or negative values retains
// the original sign and value.
//
// This group of tests confirms that adding zero to both positive and
// negative values does not alter the original sign or value. Example results:
//
// 20 + 0 = 20 -> Positive sign retained
// -20 + 0 = -20 -> Negative sign retained
//
// These tests focus on whether the final sign and value are preserved when
// adding zero, rather than on data type integrity; type casting is evaluated
// separately in another test group within this file.
//
// Note: Tests include [arbitrary precision types with negative scale]. At first,
// this might seem unusual, but consider the following:
//
// Numeric(value: '1231', precision: 4, scale: -8)
//
// Here, the negative {scale} significantly exceeds the number of significant
// digits. To avoid a zero result, the absolute value of the negative {scale}
// should be less than the number of digits minus one. For instance, '1231'
// has 4 digits, so the {scale} should be no less than -3. That's because
// abs(-3) == (4 - 1), which scales '1231' by a factor of 10^abs(-3) = 1000,
// rounding it to the nearest 1000. In this test case, scaling by
// 10^abs(-8) = 100000000 would round '1231' to the nearest 100000000,
// resulting in 0.
//
// No tests for [Serial types] since their minimum value is 1 and they cannot store 0. Also,
// no tests for [fractional arbitrary precision types] as typically, fractional types do not
// have a zero ('0.0') value.
  group('zero cases', () {
    test('should retain positive sign when adding BigInteger', () {
      final value1 = SmallInteger(20);
      final value2 = BigInteger(0);
      final expected = BigInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding BigInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = BigInteger(0);
      final expected = BigInteger(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding Integer', () {
      final value1 = SmallInteger(20);
      final value2 = Integer(0);
      final expected = Integer(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding Integer', () {
      final value1 = SmallInteger(-20);
      final value2 = Integer(0);
      final expected = Integer(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding SmallInteger', () {
      final value1 = SmallInteger(20);
      final value2 = SmallInteger(0);
      final expected = SmallInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding SmallInteger', () {
      final value1 = SmallInteger(-20);
      final value2 = SmallInteger(0);
      final expected = SmallInteger(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding int primitive', () {
      final value1 = SmallInteger(20);
      const value2 = 0;
      final expected = SmallInteger(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding int primitive', () {
      final value1 = SmallInteger(-20);
      const value2 = 0;
      final expected = SmallInteger(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding double', () {
      final value1 = SmallInteger(20);
      const value2 = 0.0;
      final expected = Real(20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding double', () {
      final value1 = SmallInteger(-20);
      const value2 = 0.0;
      final expected = Real(-20);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding int Numeric', () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding int Numeric', () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '0', precision: 1, scale: 0);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding unconstrained int Numeric',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '0');
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding float Numeric', () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding float Numeric', () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '0.0', precision: 2, scale: 1);
      final expected = Numeric(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding unconstrained float Numeric',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '0.0');
      final expected = Numeric(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when adding positive Numeric with negative scale greater than its value',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when adding positive Numeric with negative scale greater than its value',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '1231', precision: 4, scale: -8);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when adding negative Numeric with negative scale greater than its value',
        () {
      final value1 = SmallInteger(20);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when adding negative Numeric with negative scale greater than its value',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Numeric(value: '-1231', precision: 4, scale: -8);
      final expected = Numeric(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding int Decimal', () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding int Decimal', () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '0', precision: 1, scale: 0);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '0');
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding unconstrained int Decimal',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '0');
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding float Decimal', () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Decimal(value: '20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding float Decimal', () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '0.0', precision: 2, scale: 1);
      final expected = Decimal(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain positive sign when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '0.0');
      final expected = Decimal(value: '20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    test('should retain negative sign when adding unconstrained float Decimal',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '0.0');
      final expected = Decimal(value: '-20.0', precision: 3, scale: 1);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when adding positive Decimal with negative scale greater than its value',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '1231' is rounded to '1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when adding positive Decimal with negative scale greater than its value',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '1231', precision: 4, scale: -8);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain positive sign when adding negative Decimal with negative scale greater than its value',
        () {
      final value1 = SmallInteger(20);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Decimal(value: '20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });

    // Observations:
    // In this test, the {value} '-1231' is rounded to '-1000' due to the -3 negative
    // {scale}.
    test(
        'should retain negative sign when adding negative Decimal with negative scale greater than its value',
        () {
      final value1 = SmallInteger(-20);
      final value2 = Decimal(value: '-1231', precision: 4, scale: -8);
      final expected = Decimal(value: '-20', precision: 2, scale: 0);
      final operation = value1 + value2;
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if performing addition with operands of different types
// results in correct type casting and returns the expected final type.
//
// This group of tests verifies that type casting functions properly when
// operands of different types are added together.
//
// The focus of these tests is on the final type of the result rather than
// the numeric value. Tests evaluating the arithmetic results of addition
// are covered in other groups within this file.
//
// Note: The number 1 is used as the {value} in most operations instead
// of 0 to accommodate the minimum {value} requirement of [Serial types],
// which is 1.
  group('type casting', () {
    test('should return BigInteger as result when adding BigInteger', () {
      final value1 = SmallInteger(1);
      final value2 = BigInteger(1);
      final operation = value1 + value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return BigInteger as result when adding negative BigInteger',
        () {
      final value1 = SmallInteger(1);
      final value2 = BigInteger(-1);
      final operation = value1 + value2;
      expect(operation, isA<BigInteger>());
    });

    test('should return Integer as result when adding Integer', () {
      final value1 = SmallInteger(1);
      final value2 = Integer(1);
      final operation = value1 + value2;
      expect(operation, isA<Integer>());
    });

    test('should return Integer as result when adding negative Integer', () {
      final value1 = SmallInteger(1);
      final value2 = Integer(-1);
      final operation = value1 + value2;
      expect(operation, isA<Integer>());
    });

    test('should return SmallInteger as result when adding SmallInteger', () {
      final value1 = SmallInteger(1);
      final value2 = SmallInteger(1);
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when adding negative SmallInteger',
        () {
      final value1 = SmallInteger(1);
      final value2 = SmallInteger(-1);
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when adding BigSerial', () {
      final value1 = SmallInteger(1);
      final value2 = BigSerial(1);
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when adding Serial', () {
      final value1 = SmallInteger(1);
      final value2 = Serial(1);
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when adding SmallSerial', () {
      final value1 = SmallInteger(1);
      final value2 = SmallSerial(1);
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return SmallInteger as result when adding int primitive', () {
      final value1 = SmallInteger(1);
      const value2 = 1;
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test(
        'should return SmallInteger as result when adding negative int primitive',
        () {
      final value1 = SmallInteger(1);
      const value2 = -1;
      final operation = value1 + value2;
      expect(operation, isA<SmallInteger>());
    });

    test('should return Real as result when adding double primitive', () {
      final value1 = SmallInteger(1);
      const value2 = 1.5;
      final operation = value1 + value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when adding negative double primitive',
        () {
      final value1 = SmallInteger(1);
      const value2 = -1.5;
      final operation = value1 + value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when adding Real', () {
      final value1 = SmallInteger(1);
      final value2 = Real(1);
      final operation = value1 + value2;
      expect(operation, isA<Real>());
    });

    test('should return Real as result when adding negative Real', () {
      final value1 = SmallInteger(1);
      final value2 = Real(-1);
      final operation = value1 + value2;
      expect(operation, isA<Real>());
    });

    test('should return DoublePrecision as result when adding DoublePrecision',
        () {
      final value1 = SmallInteger(1);
      final value2 = DoublePrecision(1);
      final operation = value1 + value2;
      expect(operation, isA<DoublePrecision>());
    });

    test(
        'should return DoublePrecision as result when adding negative DoublePrecision',
        () {
      final value1 = SmallInteger(1);
      final value2 = DoublePrecision(-1);
      final operation = value1 + value2;
      expect(operation, isA<DoublePrecision>());
    });

    test('should return Numeric as result when adding Numeric', () {
      final value1 = SmallInteger(1);
      final value2 = Numeric(value: '1', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Numeric as result when adding negative Numeric', () {
      final value1 = SmallInteger(1);
      final value2 = Numeric(value: '-1', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation, isA<Numeric>());
    });

    test('should return Decimal as result when adding Decimal', () {
      final value1 = SmallInteger(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation, isA<Decimal>());
    });

    test('should return Decimal as result when adding negative Decimal', () {
      final value1 = SmallInteger(1);
      final value2 = Decimal(value: '1', precision: 1, scale: 0);
      final operation = value1 + value2;
      expect(operation, isA<Decimal>());
    });
  });

// Tests if addition correctly promotes a less precise value to a more precise
// value when necessary.
//
// This group of tests ensures correct type promotion when the second operand
// is more precise than the first. The necessity for this testing arose from a
// subtle error discovered during the development of data types in this mock
// implementation. Specifically, these tests check if the range adapts to
// accommodate the result of the operation, as demonstrated in the following
// example:
//
// SmallInteger(SmallInteger.maxValue) + BigInteger(20)
//
// In the example above, the expected behavior is for the {SmallInteger} type
// to be promoted to a {BigInteger} to handle the resulting value, in accordance
// with type casting rules. However, a bug previously found caused this operation
// to incorrectly throw a {RangeError} due to the result being checked against
// the range of the first operand (SmallInteger), rather than the more precise
// operand (BigInteger). This test group aims to verify the correction of this
// issue.
//
// Observations:
// - There are no tests for types with precision equal to or less than the types
// already tested in this file.
  group('operation type promotion', () {
    test('should promote correctly when adding BigInteger close to min value',
        () {
      final value1 = SmallInteger(SmallInteger.minValue);
      final value2 = BigInteger(-20);
      final operation = value1 + value2;
      final expected = BigInteger(SmallInteger.minValue + (-20));
      expect(operation.identicalTo(expected), true);
    });

    test('should promote correctly when adding BigInteger close to max value',
        () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = BigInteger(20);
      final operation = value1 + value2;
      final expected = BigInteger(SmallInteger.maxValue + 20);
      expect(operation.identicalTo(expected), true);
    });

    test('should promote correctly when adding Integer close to min value', () {
      final value1 = SmallInteger(SmallInteger.minValue);
      final value2 = Integer(-20);
      final operation = value1 + value2;
      final expected = Integer(SmallInteger.minValue + (-20));
      expect(operation.identicalTo(expected), true);
    });

    test('should promote correctly when adding Integer close to max value', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = Integer(20);
      final operation = value1 + value2;
      final expected = Integer(SmallInteger.maxValue + 20);
      expect(operation.identicalTo(expected), true);
    });
  });

// Tests if addition throws a RangeError when result value overflows or underflows.
//
// This group of tests evaluates correct error handling for overflow and underflow
// scenarios during addition. These tests are aligned with PostgreSQL's numeric
// types range documentation, which can be found at:
//
// https://www.postgresql.org/docs/current/datatype-numeric.html
//
// According to the documentation, overflows and underflows during addition can occur
// in two main scenarios:
//
// 1. When adding two values of the same type results in a value that exceeds the
//    type's range, as no larger type is available for casting. Examples include:
//    - BigInteger(BigInteger.maxValue) + BigInteger(20)
//    - BigInteger(BigInteger.minValue) + BigInteger(-20)
//
// 2. When an addition operation results in the largest operand exceeding its range,
//    without a suitable larger type for casting. Examples include:
//    - Integer(Integer.maxValue) + SmallInteger(20)  // SmallInteger is cast to Integer
//    - Integer(Integer.minValue) + SmallInteger(-20)
//    - SmallInteger(30) + Integer(Integer.maxValue)
//    - SmallInteger(-30) + Integer(Integer.minValue)
//
// Conversely, here are instances where overflow does not occur:
//
// 1. When the smaller type's maximum value is added to a larger type, which can
//    accommodate the result without exceeding its range:
//    - SmallInteger(SmallInteger.maxValue) + Integer(20) // SmallInteger cast to Integer
//
// 2. When one of the operands is a floating point or Numeric type, which typically
//    have larger ranges:
//    - BigInteger(BigInteger.maxValue) + Real(20.5)  // BigInteger cast to Real
//
// The primary focus of these tests is on the type of error thrown (e.g., RangeError)
// rather than on the value or data type correctness. Addition in various scenarios
// and type casting are evaluated separately in other test groups within this file.
  group('overflow and underflow errors', () {
    test('should throw RangeError if adding BigInteger overflows', () {
      final value1 = SmallInteger(20);
      final value2 = BigInteger(BigInteger.maxValue);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding BigInteger underflows', () {
      final value1 = SmallInteger(-20);
      final value2 = BigInteger(BigInteger.minValue);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding Integer overflows', () {
      final value1 = SmallInteger(20);
      final value2 = Integer(Integer.maxValue);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding Integer underflows', () {
      final value1 = SmallInteger(-20);
      final value2 = Integer(Integer.minValue);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding SmallInteger overflows', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = SmallInteger(20);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding SmallInteger underflows', () {
      final value1 = SmallInteger(SmallInteger.minValue);
      final value2 = SmallInteger(-20);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding BigSerial overflows', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = BigSerial(20);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding Serial overflows', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = Serial(20);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding SmallSerial overflows', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      final value2 = SmallSerial(20);
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding int primitive overflows', () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      const value2 = 20;
      expect(() => value1 + value2, throwsRangeError);
    });

    test('should throw RangeError if adding int primitive underflows', () {
      final value1 = SmallInteger(SmallInteger.minValue);
      const value2 = -20;
      expect(() => value1 + value2, throwsRangeError);
    });

    test(
        'should throw RangeError if double primitive addition result is too large for Real',
        () {
      final value1 = SmallInteger(SmallInteger.maxValue);
      const value2 = 3.40282347e+39;
      expect(() => value1 + value2, throwsRangeError);
    });

    test(
        'should throw RangeError if double primitive addition result is too small for Real',
        () {
      final value1 = SmallInteger(SmallInteger.minValue);
      const value2 = -3.40282347e+39;
      expect(() => value1 + value2, throwsRangeError);
    });
  });
}
