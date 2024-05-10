import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to use index operator', () {
    final value = SmallSerial(1);
    expect(() => value[0], throwsUnsupportedError);
  });
}
