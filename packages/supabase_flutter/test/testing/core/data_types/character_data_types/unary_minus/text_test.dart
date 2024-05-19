import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform minus', () {
    final value = Text('sample');
    expect(() => -value, throwsUnsupportedError);
  });
}
