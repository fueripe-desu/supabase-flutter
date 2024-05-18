import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if both the scale and precision are equal', () {
    expect(
      Decimal(value: '0.123', precision: 3, scale: 3).isFractional,
      true,
    );
  });

  test('should return false if scale and precision are different', () {
    expect(
      Decimal(value: '3.123', precision: 4, scale: 3).isFractional,
      false,
    );
  });

  test('should return false if it is unconstrained', () {
    expect(Decimal(value: '0').isFractional, false);
  });
}
