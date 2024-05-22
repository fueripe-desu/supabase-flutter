import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/currency/currencies.dart';
import 'package:supabase_flutter/src/testing/core/data_types/monetary_data_types.dart';

void main() {
  test('should throw UnsupportedError when performing index assignment', () {
    final value1 = Money(r'$0.00', overrideCurrency: Currencies.usd);
    expect(() => value1[0] = 2, throwsUnsupportedError);
  });
}
