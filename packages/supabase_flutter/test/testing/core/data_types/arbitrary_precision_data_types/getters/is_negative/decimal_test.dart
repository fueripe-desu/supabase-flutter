import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if value is less than 0', () {
    expect(
      Decimal(value: '-1', precision: 1, scale: 0).isNegative,
      true,
    );
  });

  test('should return false if value is equal to 0', () {
    expect(
      Decimal(value: '0', precision: 1, scale: 0).isNegative,
      false,
    );
  });

  test('should return false if value is greater than 0', () {
    expect(
      Decimal(value: '1', precision: 1, scale: 0).isNegative,
      false,
    );
  });
}
