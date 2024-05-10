import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a SmallInteger zero', () {
    expect(SmallInteger.zero.value, 0);
  });

  test('should return a SmallInteger positive one', () {
    expect(SmallInteger.positiveOne.value, 1);
  });

  test('should return a SmallInteger negative one', () {
    expect(SmallInteger.negativeOne.value, -1);
  });

  test('should return a SmallInteger max', () {
    expect(SmallInteger.max.value, SmallInteger.max);
  });

  test('should return a SmallInteger min', () {
    expect(SmallInteger.min.value, SmallInteger.min);
  });
}
