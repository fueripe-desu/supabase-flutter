import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should negate a positive DoublePrecision', () {
    final value = DoublePrecision(20);
    expect(-value, DoublePrecision(-20));
  });

  test('should inverse a negative DoublePrecision', () {
    final value = DoublePrecision(-20);
    expect(-value, DoublePrecision(20));
  });
}
