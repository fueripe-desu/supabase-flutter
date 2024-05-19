import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should throw UnsupportedError when using with Decimal', () {
    final value1 = Decimal(value: '0', precision: 1, scale: 0);
    expect(() => value1[1] = 2, throwsUnsupportedError);
  });
}
