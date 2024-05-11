import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return a DoublePrecision with the value of zero', () {
    final value = DoublePrecision.zero;
    final expected = DoublePrecision(0);
    expect(value.identicalTo(expected), true);
  });

  test('should return a DoublePrecision with the maximum allowed value', () {
    final value = DoublePrecision.max;
    final expected = DoublePrecision(DoublePrecision.maxValue);
    expect(value.identicalTo(expected), true);
  });

  test('should return a DoublePrecision with the minium allowed value', () {
    final value = DoublePrecision.min;
    final expected = DoublePrecision(DoublePrecision.minValue);
    expect(value.identicalTo(expected), true);
  });
}
