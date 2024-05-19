import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if both have the same type and value', () {
    final value1 = Char('Hello World!', length: 12);
    final value2 = Char('Hello World!', length: 12);
    final operation = value1.identicalTo(value2);
    expect(operation, true);
  });

  test(
      'should return false if both have the same type and value but different lengths',
      () {
    final value1 = Char('Hello World!', length: 12);
    final value2 = Char('Hello World!', length: 14);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });

  test('should return false if both have the same type but different values',
      () {
    final value1 = Char('Hello World!', length: 12);
    final value2 = Char('Hello Worl', length: 10);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });

  test('should return false if both have different values', () {
    final value1 = Char('Hello World!', length: 12);
    final value2 = VarChar('Hello Worl', length: 10);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });
}
