import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform index assignment',
      () {
    final value1 = DoublePrecision(0);
    expect(() => value1[1] = 3.3, throwsUnsupportedError);
  });
}
