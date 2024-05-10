import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return gcd if both values are positive', () {
    final value1 = Integer(24);
    final value2 = Integer(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the second value if the first is zero', () {
    final value1 = Integer(0);
    final value2 = Integer(19);
    final expected = Integer(19);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the first value if the second is zero', () {
    final value1 = Integer(34);
    final value2 = Integer(0);
    final expected = Integer(34);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return zero if both values are zero', () {
    final value1 = Integer(0);
    final value2 = Integer(0);
    final expected = Integer(0);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should use the abs of the first value if it is negative', () {
    final value1 = Integer(-8);
    final value2 = Integer(12);
    final expected = Integer(4);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should use the abs of the second value if it is negative', () {
    final value1 = Integer(8);
    final value2 = Integer(-12);
    final expected = Integer(4);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should use the abs of both values if negative', () {
    final value1 = Integer(-8);
    final value2 = Integer(-12);
    final expected = Integer(4);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the gcd of positive identical values', () {
    final value1 = Integer(7);
    final value2 = Integer(7);
    final expected = Integer(7);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the gcd of negative identical values', () {
    final value1 = Integer(-32);
    final value2 = Integer(-32);
    final expected = Integer(32);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if values are co-primes', () {
    final value1 = Integer(13);
    final value2 = Integer(17);
    final expected = Integer(1);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if one value is prime and the other is not a multiple',
      () {
    final value1 = Integer(29);
    final value2 = Integer(100);
    final expected = Integer(1);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the smallest value if values are multiples', () {
    final value1 = Integer(7);
    final value2 = Integer(21);
    final expected = Integer(7);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return true for gcd(a, b) == gcd(b, a)', () {
    final operation1 = Integer(7).gcd(Integer(21));
    final operation2 = Integer(21).gcd(Integer(7));
    expect(operation1.identicalTo(operation2), true);
  });

  test('should work correctly with BigInteger', () {
    final value1 = Integer(24);
    final value2 = BigInteger(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with Integer', () {
    final value1 = Integer(24);
    final value2 = Integer(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with SmallInteger', () {
    final value1 = Integer(24);
    final value2 = SmallInteger(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with BigSerial', () {
    final value1 = Integer(24);
    final value2 = BigSerial(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with Serial', () {
    final value1 = Integer(24);
    final value2 = Serial(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with SmallSerial', () {
    final value1 = Integer(24);
    final value2 = SmallSerial(36);
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with int primitives', () {
    final value1 = Integer(24);
    const value2 = 36;
    final expected = Integer(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if value is invalid', () {
    final value1 = Integer(24);
    const value2 = 'abc';
    expect(() => value1.gcd(value2), throwsArgumentError);
  });
}
