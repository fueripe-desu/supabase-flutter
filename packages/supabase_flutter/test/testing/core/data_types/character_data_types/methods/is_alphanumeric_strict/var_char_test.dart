import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return false if value represents a positive integer', () {
    final value = VarChar('24', length: 2);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return false if value represents a negative integer', () {
    final value = VarChar('-24', length: 3);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return false if value represents a positive float integer', () {
    final value = VarChar('3.14', length: 4);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return false if value represents a negative float integer', () {
    final value = VarChar('-3.14', length: 5);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return false if value contains only letters', () {
    final value = VarChar('abc', length: 3);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return false if value contains letters and spaces', () {
    final value = VarChar('ab c', length: 4);
    final operation = value.isAlphanumericStrict();
    expect(operation, false);
  });

  test('should return true if value contains letters and numbers', () {
    final value = VarChar('abc123', length: 6);
    final operation = value.isAlphanumericStrict();
    expect(operation, true);
  });

  test('should return true if value contains letters, numbers and spaces', () {
    final value = VarChar('abc 123', length: 7);
    final operation = value.isAlphanumericStrict();
    expect(operation, true);
  });
}
