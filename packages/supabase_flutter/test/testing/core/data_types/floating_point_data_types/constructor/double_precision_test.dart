import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should create DoublePrecision successfully if value is in range', () {
    expect(DoublePrecision(3.14).value, 3.14);
  });

  test('should throw RangeError if value overflows', () {
    expect(() => DoublePrecision(1.7976931348623157e+309), throwsRangeError);
  });

  test('should throw RangeError if value underflows', () {
    expect(() => DoublePrecision(-1.7976931348623157e+309), throwsRangeError);
  });

  test('should round to 15 decimal places if value has more', () {
    final value = DoublePrecision(3.14159265358979323846);
    final valueString = value.value.toString();
    final decimalPartLen = valueString.split('.')[1].length;
    expect(decimalPartLen == 15, true);
  });

  test('should not affect if value has less than 15 decimal places', () {
    final value = DoublePrecision(3.1415);
    final valueString = value.value.toString();
    final decimalPartLen = valueString.split('.')[1].length;
    expect(decimalPartLen == 4, true);
  });
}
