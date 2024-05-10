import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return true if other has same type and value', () {
    expect(Serial(20).identicalTo(Serial(20)), true);
  });

  test('should return false if other has same type but different value', () {
    expect(Serial(20).identicalTo(Serial(40)), false);
  });

  test('should return false if other has different type and value', () {
    expect(Serial(20).identicalTo(BigInteger(40)), false);
  });
}
