import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return a Real with the value of zero', () {
    final value = Real.zero;
    final expected = Real(0);
    expect(value.identicalTo(expected), true);
  });

  test('should return a Real with the maximum allowed value', () {
    final value = Real.max;
    final expected = Real(Real.maxValue);
    expect(value.identicalTo(expected), true);
  });

  test('should return a Real with the minium allowed value', () {
    final value = Real.min;
    final expected = Real(Real.minValue);
    expect(value.identicalTo(expected), true);
  });
}
