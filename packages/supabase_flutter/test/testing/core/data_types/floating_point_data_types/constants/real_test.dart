import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/floating_point_data_types.dart';

void main() {
  test('should return the max value of Real', () {
    expect(Real.maxValue, 3.40282347e+38);
  });

  test('should return the min value of Real', () {
    expect(Real.minValue, -3.40282347e+38);
  });
}
