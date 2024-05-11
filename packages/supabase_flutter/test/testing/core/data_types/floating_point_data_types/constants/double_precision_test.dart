import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return the max value of DoublePrecision', () {
    expect(DoublePrecision.maxValue, 1.7976931348623157e+308);
  });

  test('should return the min value of DoublePrecision', () {
    expect(DoublePrecision.minValue, -1.7976931348623157e+308);
  });
}
