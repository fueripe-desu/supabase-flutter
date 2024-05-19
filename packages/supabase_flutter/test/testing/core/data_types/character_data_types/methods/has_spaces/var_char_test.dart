import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains special chars', () {
    final value = VarChar('&*!@^#!as  das123', length: 17);
    final operation = value.hasSpaces();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = VarChar('asdjaoidjao12314', length: 16);
    final operation = value.hasSpaces();
    expect(operation, false);
  });
}
