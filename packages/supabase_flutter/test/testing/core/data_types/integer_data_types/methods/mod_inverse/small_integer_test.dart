import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should work correctly with positive value', () {
    final value = SmallInteger(3);
    const modulus = 11;
    final expected = SmallInteger(4);
    final operation = value.modInverse(modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should work correctly with negative value', () {
    final value = SmallInteger(-3);
    const modulus = 11;
    final expected = SmallInteger(7);
    final operation = value.modInverse(modulus);
    expect(operation.identicalTo(expected), true);
  });

  test('should throw ArgumentError if values are non-coprime', () {
    final value = SmallInteger(12);
    const modulus = 8;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if modulus is negative', () {
    final value = SmallInteger(12);
    const modulus = -8;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if value is zero', () {
    final value = SmallInteger(0);
    const modulus = 8;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if modulus is zero', () {
    final value = SmallInteger(12);
    const modulus = 0;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if modulus is 1', () {
    final value = SmallInteger(7);
    const modulus = 1;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });

  test('should throw ArgumentError if value and modulus are identical', () {
    final value = SmallInteger(7);
    const modulus = 7;
    expect(() => value.modInverse(modulus), throwsArgumentError);
  });
}
