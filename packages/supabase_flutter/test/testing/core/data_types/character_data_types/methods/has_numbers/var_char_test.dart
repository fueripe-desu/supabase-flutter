import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains numbers', () {
    final value = VarChar('2921123', length: 7);
    final operation = value.hasNumbers();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = VarChar('asdjaoidjao*&*@', length: 15);
    final operation = value.hasNumbers();
    expect(operation, false);
  });
}
