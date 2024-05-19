import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if both have the same type and value', () {
    final value1 = Text('Hello World!');
    final value2 = Text('Hello World!');
    final operation = value1.identicalTo(value2);
    expect(operation, true);
  });

  test('should return false if both have the same type but different values',
      () {
    final value1 = Text('Hello World!');
    final value2 = Text('Hello Worl');
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });

  test('should return false if both have different values', () {
    final value1 = Text('Hello World!');
    final value2 = Char('Hello Worl', length: 10);
    final operation = value1.identicalTo(value2);
    expect(operation, false);
  });
}
