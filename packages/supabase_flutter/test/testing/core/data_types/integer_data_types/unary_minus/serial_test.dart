import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should throw RangeError when negating Serial', () {
    final value = Serial(20);
    expect(() => -value, throwsRangeError);
  });
}
