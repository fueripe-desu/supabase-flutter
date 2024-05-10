import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test(
      'should throw UnsupportedError when trying to use unsigned right shift operator',
      () {
    expect(() => SmallSerial(2) >>> 3, throwsUnsupportedError);
  });
}
