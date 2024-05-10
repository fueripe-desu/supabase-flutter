import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should correctly perform mod pow', () {
    final value = BigSerial(2);
    const exponent = 3;
    const modulus = 5;
    final expected = BigSerial(3);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return mod pow if base is greater than modulus', () {
    final value = BigSerial(10);
    const exponent = 2;
    const modulus = 6;
    final expected = BigSerial(4);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if base is 1', () {
    final value = BigSerial(1);
    const exponent = 5;
    const modulus = 7;
    final expected = BigSerial(1);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return 1 if exponent is 0', () {
    final value = BigSerial(5);
    const exponent = 0;
    const modulus = 7;
    final expected = BigSerial(1);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if exponent is 1', () {
    final value = BigSerial(3);
    const exponent = 1;
    const modulus = 4;
    final expected = BigSerial(3);
    final operation = value.modPow(exponent, modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if modulus is zero', () {
    final value = BigSerial(4);
    const exponent = 2;
    const modulus = 0;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if modulus is negative', () {
    final value = BigSerial(4);
    const exponent = 2;
    const modulus = -2;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if exponent is negative', () {
    final value = BigSerial(4);
    const exponent = -2;
    const modulus = 2;
    expect(() => value.modPow(exponent, modulus), throwsArgumentError);
  });

  test('should throw RangeError if exponetiation overflows', () {
    final baseValue = BigSerial(2);
    const exponent = 1000;
    const modulus = 2;
    expect(() => baseValue.modPow(exponent, modulus), throwsRangeError);
  });
}
