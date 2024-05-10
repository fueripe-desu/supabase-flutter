import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should create BigSerial successfully if value is in range', () {
    expect(BigSerial(365).value, 365);
  });

  test('should throw a RangeError if value of BigSerial overflows', () {
    expect(() => BigSerial(9223372036854775807), throwsRangeError);
  });

  test('should throw a RangeError if value of BigSerial underflows', () {
    expect(() => BigSerial(-10), throwsRangeError);
  });
}
