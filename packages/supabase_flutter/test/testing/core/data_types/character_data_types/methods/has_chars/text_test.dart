import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains special chars', () {
    final value = Text('asdasd21321@(*&@)');
    final operation = value.hasChars();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = Text(r'14939*(&#!(*$))');
    final operation = value.hasChars();
    expect(operation, false);
  });
}
