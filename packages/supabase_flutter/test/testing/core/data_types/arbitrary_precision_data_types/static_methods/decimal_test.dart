import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if parameters are a valid Decimal', () {
    expect(Decimal.isValid(value: '123.456'), true);
  });

  test('should return false if parameters are not a valid Decimal', () {
    expect(Decimal.isValid(value: 'invalid'), false);
  });

  test('should return a Decimal if parameters are valid', () {
    final value = Decimal.tryCreate(value: '123.456');
    final expected = Decimal.tryCreate(value: '123.456');
    expect(value, expected);
  });

  test('should return null if parameters of Decimal are not valid', () {
    final value = Decimal.tryCreate(value: 'invalid');
    const expected = null;
    expect(value, expected);
  });
}
