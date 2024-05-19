import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value represents a positive integer', () {
    final value = Text('24');
    final operation = value.isAlphanumeric();
    expect(operation, true);
  });

  test('should return false if value represents a negative integer', () {
    final value = Text('-24');
    final operation = value.isAlphanumeric();
    expect(operation, false);
  });

  test('should return false if value represents a positive float integer', () {
    final value = Text('3.14');
    final operation = value.isAlphanumeric();
    expect(operation, false);
  });

  test('should return false if value represents a negative float integer', () {
    final value = Text('-3.14');
    final operation = value.isAlphanumeric();
    expect(operation, false);
  });

  test('should return true if value contains only letters', () {
    final value = Text('abc');
    final operation = value.isAlphanumeric();
    expect(operation, true);
  });

  test('should return true if value contains letters and spaces', () {
    final value = Text('ab c');
    final operation = value.isAlphanumeric();
    expect(operation, true);
  });

  test('should return true if value contains letters and numbers', () {
    final value = Text('abc123');
    final operation = value.isAlphanumeric();
    expect(operation, true);
  });

  test('should return true if value contains letters, numbers and spaces', () {
    final value = Text('abc 123');
    final operation = value.isAlphanumeric();
    expect(operation, true);
  });
}
