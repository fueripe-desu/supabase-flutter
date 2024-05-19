import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform index assignment',
      () {
    final value1 = Char('sample', length: 6);
    expect(() => value1[1] = 'f', throwsUnsupportedError);
  });
}
