import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/arbitrary_precision_data_types.dart';

void main() {
  test('should return true if parameters are a valid Numeric', () {
    expect(Numeric.isValid(value: '123.456'), true);
  });

  test('should return false if parameters are not a valid Numeric', () {
    expect(Numeric.isValid(value: 'invalid'), false);
  });

  test('should return a Numeric if parameters are valid', () {
    final value = Numeric.tryCreate(value: '123.456');
    final expected = Numeric.tryCreate(value: '123.456');
    expect(value, expected);
  });

  test('should return null if parameters of Numeric are not valid', () {
    final value = Numeric.tryCreate(value: 'invalid');
    const expected = null;
    expect(value, expected);
  });
}
