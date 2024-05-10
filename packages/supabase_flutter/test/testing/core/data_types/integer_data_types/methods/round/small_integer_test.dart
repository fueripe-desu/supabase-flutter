import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return itself if value is positive', () {
    final value = SmallInteger(10);
    final expected = SmallInteger(10);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is zero value', () {
    final value = SmallInteger(0);
    final expected = SmallInteger(0);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });

  test('should return itself if value is negative value', () {
    final value = SmallInteger(-10);
    final expected = SmallInteger(-10);
    final operation = value.round();
    expect(operation.identicalTo(expected), true);
  });
}
