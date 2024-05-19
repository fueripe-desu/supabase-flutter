import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return the maximum amount of digits before the fractional point',
      () {
    expect(Decimal.maxDigitsBefore, 131072);
  });

  test('should return the maximum amount of digits after the fractional point',
      () {
    expect(Decimal.maxDigitsAfter, 16383);
  });

  test('should return the default scale for recurring decimals', () {
    expect(Decimal.defaultScaleForInfiniteDecimal, 20);
  });
}
