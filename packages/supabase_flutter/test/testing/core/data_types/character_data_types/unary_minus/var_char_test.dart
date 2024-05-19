import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform unary minus', () {
    final value = VarChar('sample', length: 6);
    expect(() => -value, throwsUnsupportedError);
  });
}
