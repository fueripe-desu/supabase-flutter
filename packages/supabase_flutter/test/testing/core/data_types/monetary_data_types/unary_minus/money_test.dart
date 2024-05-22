import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should become negative if value is positive', () {
    final value = Money(r'$30.50', overrideCurrency: Currencies.usd);
    final expected = Money(r'-$30.50', overrideCurrency: Currencies.usd);
    final operation = -value;
    expect(operation.identicalTo(expected), true);
  });

  test('should becomes positive if value is negative', () {
    final value = Money(r'-$30.50', overrideCurrency: Currencies.usd);
    final expected = Money(r'$30.50', overrideCurrency: Currencies.usd);
    final operation = -value;
    expect(operation.identicalTo(expected), true);
  });
}
