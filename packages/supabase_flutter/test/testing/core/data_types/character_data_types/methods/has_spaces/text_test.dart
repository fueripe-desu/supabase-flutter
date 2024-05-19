import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains special chars', () {
    final value = Text('&*!@^#!as  das123');
    final operation = value.hasSpaces();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = Text('asdjaoidjao12314');
    final operation = value.hasSpaces();
    expect(operation, false);
  });
}
