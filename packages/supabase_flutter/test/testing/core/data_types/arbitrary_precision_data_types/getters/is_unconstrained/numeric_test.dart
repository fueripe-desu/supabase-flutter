import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if both scale and precision are null', () {
    expect(Numeric(value: '0').isUnconstrained, true);
  });

  test('should return false if scale or precision are given', () {
    expect(Numeric(precision: 10, value: '0').isUnconstrained, false);
  });
}
