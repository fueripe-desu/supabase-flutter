import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should throw UnsupportedError when using with Numeric', () {
    final value1 = Numeric(value: '0', precision: 1, scale: 0);
    const value2 = 20;
    expect(() => value1 << value2, throwsUnsupportedError);
  });
}
