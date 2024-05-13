import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should throw UnsupportedError when trying to perform left shift', () {
    final value1 = DoublePrecision(0);
    final value2 = DoublePrecision(1);
    expect(() => value1 << value2, throwsUnsupportedError);
  });
}
