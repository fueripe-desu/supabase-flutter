import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if the value has a decimal point', () {
    expect(
      Numeric(value: '3.14', precision: 3, scale: 1).hasDecimalPoint,
      true,
    );
  });

  test('should return false if the value does not have a decimal point', () {
    expect(
      Numeric(value: '3', precision: 1, scale: 0).hasDecimalPoint,
      false,
    );
  });
}
