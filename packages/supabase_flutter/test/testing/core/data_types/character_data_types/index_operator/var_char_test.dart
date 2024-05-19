import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should correctly access a specified index', () {
    final value = VarChar('Sample string', length: 13);
    final expected = Text('m');
    final operation = value[2];
    expect(operation!.identicalTo(expected), true);
  });

  test('should return null if index does not exist', () {
    final value = VarChar('Sample string', length: 13);
    const expected = null;
    final operation = value[20];
    expect(operation, isNull);
    expect(operation, expected);
  });
}
