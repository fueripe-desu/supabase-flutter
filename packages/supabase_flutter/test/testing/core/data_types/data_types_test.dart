import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return 0 when getting the precision of primitive int', () {
    const value = 20;
    final operation = DataType.getPrecision(value);
    expect(operation, 0);
  });

  test('should return 0 when getting the precision of primitive double', () {
    const value = 20.5;
    final operation = DataType.getPrecision(value);
    expect(operation, 0);
  });

  test('should return 0 when getting the precision of primitive string', () {
    const value = 'sample';
    final operation = DataType.getPrecision(value);
    expect(operation, 0);
  });

  test('should return 1 when getting the precision of SmallSerial', () {
    final value = SmallSerial(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 1);
  });

  test('should return 2 when getting the precision of Serial', () {
    final value = Serial(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 2);
  });

  test('should return 3 when getting the precision of BigSerial', () {
    final value = BigSerial(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 3);
  });

  test('should return 4 when getting the precision of SmallInteger', () {
    final value = SmallInteger(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 4);
  });

  test('should return 5 when getting the precision of Integer', () {
    final value = Integer(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 5);
  });

  test('should return 6 when getting the precision of BigInteger', () {
    final value = BigInteger(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 6);
  });

  test('should return 7 when getting the precision of Real', () {
    final value = Real(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 7);
  });

  test('should return 8 when getting the precision of DoublePrecision', () {
    final value = DoublePrecision(1);
    final operation = DataType.getPrecision(value);
    expect(operation, 8);
  });

  test('should return 9 when getting the precision of Numeric', () {
    final value = Numeric(value: '1', precision: 1, scale: 0);
    final operation = DataType.getPrecision(value);
    expect(operation, 9);
  });

  test('should return 9 when getting the precision of Decimal', () {
    final value = Decimal(value: '1', precision: 1, scale: 0);
    final operation = DataType.getPrecision(value);
    expect(operation, 9);
  });
}
