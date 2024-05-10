import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should create BigInteger successfully if value is in range', () {
    expect(BigInteger(365).value, 365);
  });
}
