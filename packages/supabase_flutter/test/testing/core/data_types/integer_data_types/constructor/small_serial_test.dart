import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should create SmallSerial successfully if value is in range', () {
    expect(SmallSerial(365).value, 365);
  });

  test('should throw a RangeError if value of SmallSerial overflows', () {
    expect(() => SmallSerial(32768), throwsRangeError);
  });

  test('should throw a RangeError if value of SmallSerial underflows', () {
    expect(() => SmallSerial(-10), throwsRangeError);
  });
}
