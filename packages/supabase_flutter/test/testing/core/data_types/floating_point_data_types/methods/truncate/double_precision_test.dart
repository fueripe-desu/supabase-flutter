import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should truncate if positive value has fractional part', () {
    final value = DoublePrecision(312.987324);
    final expected = DoublePrecision(312);
    expect(value.truncate().identicalTo(expected), true);
  });

  test('should not affect if positive value is integer-valued', () {
    final value = DoublePrecision(312);
    final expected = DoublePrecision(312);
    expect(value.truncate().identicalTo(expected), true);
  });

  test('should truncate if negative value has fractional part', () {
    final value = DoublePrecision(-312.987324);
    final expected = DoublePrecision(-312);
    expect(value.truncate().identicalTo(expected), true);
  });

  test('should not affect if negative value is integer-valued', () {
    final value = DoublePrecision(-312);
    final expected = DoublePrecision(-312);
    expect(value.truncate().identicalTo(expected), true);
  });
}
