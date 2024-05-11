import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should create Real successfully if value is in range', () {
    expect(Real(3.14).value, 3.14);
  });

  test('should throw RangeError if value overflows', () {
    expect(() => Real(3.40282347e+39), throwsRangeError);
  });

  test('should throw RangeError if value underflows', () {
    expect(() => Real(-3.40282347e+39), throwsRangeError);
  });

  test('should round to 6 decimal places if value has more', () {
    final value = Real(3.1415926535);
    final valueString = value.value.toString();
    final decimalPartLen = valueString.split('.')[1].length;
    expect(decimalPartLen == 6, true);
  });

  test('should not affect if value has less than 6 decimal places', () {
    final value = Real(3.1415);
    final valueString = value.value.toString();
    final decimalPartLen = valueString.split('.')[1].length;
    expect(decimalPartLen == 4, true);
  });
}
