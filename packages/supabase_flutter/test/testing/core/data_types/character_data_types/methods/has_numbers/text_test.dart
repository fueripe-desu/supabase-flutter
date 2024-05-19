import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains numbers', () {
    final value = Text('2921123');
    final operation = value.hasNumbers();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = Text('asdjaoidjao*&*@');
    final operation = value.hasNumbers();
    expect(operation, false);
  });
}
