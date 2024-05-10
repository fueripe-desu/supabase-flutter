import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/src/testing/core/data_types/integer_data_types.dart';

void main() {
  test('should return a Integer zero', () {
    expect(Integer.zero.value, 0);
  });

  test('should return a Integer positive one', () {
    expect(Integer.positiveOne.value, 1);
  });

  test('should return a Integer negative one', () {
    expect(Integer.negativeOne.value, -1);
  });

  test('should return a Integer max', () {
    expect(Integer.max.value, Integer.max);
  });

  test('should return a Integer min', () {
    expect(Integer.min.value, Integer.min);
  });
}
