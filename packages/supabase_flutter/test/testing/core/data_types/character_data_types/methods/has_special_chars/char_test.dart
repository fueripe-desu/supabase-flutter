import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should return true if value contains special chars', () {
    final value = Char('&*!@^#!asdasok123', length: 17);
    final operation = value.hasSpecialChars();
    expect(operation, true);
  });

  test('should return false if value does not contain numbers', () {
    final value = Char('asdjaoidjao12314', length: 16);
    final operation = value.hasSpecialChars();
    expect(operation, false);
  });
}
