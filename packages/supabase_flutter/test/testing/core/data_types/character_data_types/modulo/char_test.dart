import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform modulo', () {
    final value1 = Char('sample', length: 6);
    final value2 = Char('ple', length: 3);
    expect(() => value1 % value2, throwsUnsupportedError);
  });
}
