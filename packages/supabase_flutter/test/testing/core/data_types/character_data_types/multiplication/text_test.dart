import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/character_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform multiplication',
      () {
    final value1 = Text('sample');
    final value2 = Text('ple');
    expect(() => value1 * value2, throwsUnsupportedError);
  });
}
