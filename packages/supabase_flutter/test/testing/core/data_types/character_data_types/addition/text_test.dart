import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a Text type when concatenating two values', () {
    final value1 = Text('Hello');
    final value2 = Char(' World!', length: 7);
    final expected = Text('Hello World!');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate Char', () {
    final value1 = Text('Hello');
    final value2 = Char(' World!', length: 7);
    final expected = Text('Hello World!');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate VarChar', () {
    final value1 = Text('Hello');
    final value2 = VarChar(' World!', length: 7);
    final expected = Text('Hello World!');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate Text', () {
    final value1 = Text('Hello');
    final value2 = Text(' World!');
    final expected = Text('Hello World!');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate string primitive', () {
    final value1 = Text('Hello');
    const value2 = ' World!';
    final expected = Text('Hello World!');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive int primitive', () {
    final value1 = Text('Hello');
    const value2 = 213;
    final expected = Text('Hello213');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative int primitive', () {
    final value1 = Text('Hello');
    const value2 = -213;
    final expected = Text('Hello-213');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive double primitive', () {
    final value1 = Text('Hello');
    const value2 = 2.5;
    final expected = Text('Hello2.5');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative double primitive', () {
    final value1 = Text('Hello');
    const value2 = -2.5;
    final expected = Text('Hello-2.5');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive BigInteger', () {
    final value1 = Text('Hello');
    final value2 = BigInteger(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative BigInteger', () {
    final value1 = Text('Hello');
    final value2 = BigInteger(-20);
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive Integer', () {
    final value1 = Text('Hello');
    final value2 = Integer(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative Integer', () {
    final value1 = Text('Hello');
    final value2 = Integer(-20);
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive SmallInteger', () {
    final value1 = Text('Hello');
    final value2 = SmallInteger(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative SmallInteger', () {
    final value1 = Text('Hello');
    final value2 = SmallInteger(-20);
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate BigSerial', () {
    final value1 = Text('Hello');
    final value2 = BigSerial(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate Serial', () {
    final value1 = Text('Hello');
    final value2 = Serial(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate SmallSerial', () {
    final value1 = Text('Hello');
    final value2 = SmallSerial(20);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive Real', () {
    final value1 = Text('Hello');
    final value2 = Real(20);
    final expected = Text('Hello20.0');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative Real', () {
    final value1 = Text('Hello');
    final value2 = Real(-20);
    final expected = Text('Hello-20.0');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive DoublePrecision', () {
    final value1 = Text('Hello');
    final value2 = DoublePrecision(20);
    final expected = Text('Hello20.0');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative DoublePrecision', () {
    final value1 = Text('Hello');
    final value2 = DoublePrecision(-20);
    final expected = Text('Hello-20.0');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive int Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '20', precision: 2, scale: 0);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative int Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-20', precision: 2, scale: 0);
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive unconstrained int Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '20');
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative unconstrained int Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-20');
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive float Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '3.14', precision: 3, scale: 2);
    final expected = Text('Hello3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative float Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-3.14', precision: 3, scale: 2);
    final expected = Text('Hello-3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive unconstrained float Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '3.14');
    final expected = Text('Hello3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative unconstrained float Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-3.14');
    final expected = Text('Hello-3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive fractional Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '0.14', precision: 2, scale: 2);
    final expected = Text('Hello0.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative fractional Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-0.14', precision: 2, scale: 2);
    final expected = Text('Hello-0.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive negative scale Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '34', precision: 2, scale: -1);
    final expected = Text('Hello30');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative negative scale Numeric', () {
    final value1 = Text('Hello');
    final value2 = Numeric(value: '-34', precision: 2, scale: -1);
    final expected = Text('Hello-30');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive int Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '20', precision: 2, scale: 0);
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative int Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-20', precision: 2, scale: 0);
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive unconstrained int Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '20');
    final expected = Text('Hello20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative unconstrained int Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-20');
    final expected = Text('Hello-20');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive float Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '3.14', precision: 3, scale: 2);
    final expected = Text('Hello3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative float Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-3.14', precision: 3, scale: 2);
    final expected = Text('Hello-3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive unconstrained float Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '3.14');
    final expected = Text('Hello3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative unconstrained float Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-3.14');
    final expected = Text('Hello-3.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive fractional Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '0.14', precision: 2, scale: 2);
    final expected = Text('Hello0.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative fractional Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-0.14', precision: 2, scale: 2);
    final expected = Text('Hello-0.14');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate positive negative scale Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '34', precision: 2, scale: -1);
    final expected = Text('Hello30');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate negative negative scale Decimal', () {
    final value1 = Text('Hello');
    final value2 = Decimal(value: '-34', precision: 2, scale: -1);
    final expected = Text('Hello-30');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });

  test('should correctly concatenate a List', () {
    final value1 = Text('Names: ');
    final value2 = ['Paul', ' Carl', ' James'];
    final expected = Text('Names: Paul, Carl, James');
    final operation = value1 + value2;
    expect(operation.identicalTo(expected), true);
  });
}
