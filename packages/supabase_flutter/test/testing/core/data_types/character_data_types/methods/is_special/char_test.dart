import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return false if value represents a positive integer', () {
    final value = Char('24', length: 2);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value represents a negative integer', () {
    final value = Char('-24', length: 3);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value represents a positive float integer', () {
    final value = Char('3.14', length: 4);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value represents a negative float integer', () {
    final value = Char('-3.14', length: 5);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value contains only letters', () {
    final value = Char('abc', length: 3);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value contains letters and spaces', () {
    final value = Char('ab c', length: 4);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value contains letters and numbers', () {
    final value = Char('abc123', length: 6);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return false if value contains letters, numbers and spaces', () {
    final value = Char('abc 123', length: 7);
    final operation = value.isSpecial();
    expect(operation, false);
  });

  test('should return true if value contains only special characters', () {
    final value = Char(r'#$(@*(#$) )', length: 11);
    final operation = value.isSpecial();
    expect(operation, true);
  });
}
