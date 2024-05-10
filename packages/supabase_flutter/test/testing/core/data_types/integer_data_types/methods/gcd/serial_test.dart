import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return gcd if both values are positive', () {
    final value1 = Serial(24);
    final value2 = Serial(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the first value if the second is zero', () {
    final value1 = Serial(34);
    final value2 = BigInteger(0);
    final expected = Serial(34);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should use the abs of the second value if it is negative', () {
    final value1 = Serial(8);
    final value2 = BigInteger(-12);
    final expected = Serial(4);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the gcd of positive identical values', () {
    final value1 = Serial(7);
    final value2 = Serial(7);
    final expected = Serial(7);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if values are co-primes', () {
    final value1 = Serial(13);
    final value2 = Serial(17);
    final expected = Serial(1);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if one value is prime and the other is not a multiple',
      () {
    final value1 = Serial(29);
    final value2 = Serial(100);
    final expected = Serial(1);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return the smallest value if values are multiples', () {
    final value1 = Serial(7);
    final value2 = Serial(21);
    final expected = Serial(7);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should return true for gcd(a, b) == gcd(b, a)', () {
    final operation1 = Serial(7).gcd(Serial(21));
    final operation2 = Serial(21).gcd(Serial(7));
    expect(operation1.identicalTo(operation2), true);
  });

  test('should work correctly with BigInteger', () {
    final value1 = Serial(24);
    final value2 = BigInteger(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with Integer', () {
    final value1 = Serial(24);
    final value2 = Integer(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with SmallInteger', () {
    final value1 = Serial(24);
    final value2 = SmallInteger(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with BigSerial', () {
    final value1 = Serial(24);
    final value2 = BigSerial(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with Serial', () {
    final value1 = Serial(24);
    final value2 = Serial(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with SmallSerial', () {
    final value1 = Serial(24);
    final value2 = SmallSerial(36);
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with int primitives', () {
    final value1 = Serial(24);
    const value2 = 36;
    final expected = Serial(12);
    final operation = value1.gcd(value2);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if value is invalid', () {
    final value1 = Serial(24);
    const value2 = 'abc';
    expect(() => value1.gcd(value2), throwsArgumentError);
  });
}
