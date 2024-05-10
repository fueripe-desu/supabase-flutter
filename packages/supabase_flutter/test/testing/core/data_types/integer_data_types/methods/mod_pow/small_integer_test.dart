import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should correctly perform mod pow', () {
    final value = SmallInteger(2);
    const exponent = 3;
    const modulus = 5;
    final expected = SmallInteger(3);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return mod pow if base is greater than modulus', () {
    final value = SmallInteger(10);
    const exponent = 2;
    const modulus = 6;
    final expected = SmallInteger(4);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0 if base is 0', () {
    final value = SmallInteger(0);
    const exponent = 5;
    const modulus = 7;
    final expected = SmallInteger(0);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if base is 1', () {
    final value = SmallInteger(1);
    const exponent = 5;
    const modulus = 7;
    final expected = SmallInteger(1);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if exponent is 0', () {
    final value = SmallInteger(5);
    const exponent = 0;
    const modulus = 7;
    final expected = SmallInteger(1);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if exponent is 1', () {
    final value = SmallInteger(3);
    const exponent = 1;
    const modulus = 4;
    final expected = SmallInteger(3);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 0 if modulus is 1', () {
    final value = SmallInteger(4);
    const exponent = 2;
    const modulus = 1;
    final expected = SmallInteger(0);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if modulus is zero', () {
    final value = SmallInteger(4);
    const exponent = 2;
    const modulus = 0;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if modulus is negative', () {
    final value = SmallInteger(4);
    const exponent = 2;
    const modulus = -2;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if exponent is negative', () {
    final value = SmallInteger(4);
    const exponent = -2;
    const modulus = 2;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw RangeError if exponetiation overflows', () {
    final baseValue = SmallInteger(2);
    const exponent = 1000;
    const modulus = 2;
    expect(() => baseValue.modPow(exponent, modulus), throwsRangeError);
  });
}
